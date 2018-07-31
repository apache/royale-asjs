////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package textEditBar
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.ITextExporter;
	import flashx.textLayout.conversion.ITextImporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.debug.assert;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import textEditBar.StatusPopup;
	
	public class FileIOHelper
	{
		static public var parentWindow:DisplayObject;
		static public var changeContent:Function;

		static private var _openedFile:String;
		
		// called when the app has a specific file it wants to read (at startup)
		static public function fileOpen(fileName:String):void
		{
			var localHTTP:HTTPService = new HTTPService();
  			localHTTP.url = fileName;
  			_openedFile = fileName;
			localHTTP.method = "GET";
			localHTTP.resultFormat="text"
			localHTTP.showBusyCursor=true;
			localHTTP.addEventListener(ResultEvent.RESULT,parseIntoFlowFromHTTP,false,0,true);
			localHTTP.addEventListener(IOErrorEvent.IO_ERROR,errorOnReadFromHTTP,false,0,true);
			localHTTP.send();
		}

		// called when user picks a file
		static public function fileChoose(fileName:FileReference) : void
		{
			fileName.addEventListener(Event.COMPLETE,onFileReferenceLoadComplete,false,0,true);
			fileName.addEventListener(IOErrorEvent.IO_ERROR,errorOnReadFromFileReference,false,0,true);
			fileName.load();
		}
		
		static private function onFileReferenceLoadComplete(event:Event):void
		{
			var fileReference:FileReference = FileReference(event.target);
	   		_extension= getExtension(fileReference.name).toLowerCase();
	   		_fileData = String(fileReference.data);
	   		parseCurrentDataWithExtension();
		}

		static private function errorOnReadFromFileReference(event:IOErrorEvent):void
        {
        	var curFileReference:FileReference = FileReference(event.target);
        	// Text content will be an error string
			var errorString:String = "Error reading file " + curFileReference.name;
 			errorString += "\n";
 			errorString += event.toString();
 			_extension = "txt";
 			_fileData = errorString;
 			parseCurrentDataWithExtension();
			//CursorManager.removeBusyCursor(); //get rid of hourglass cursor. 			
  		}
  		
 		static private function parseIntoFlowFromHTTP(event:ResultEvent):void 
 		{
	   		_fileData = String(event.result);
	   		_extension = getExtension(_openedFile).toLowerCase();
	   		parseCurrentDataWithExtension();
	   		_openedFile = null;
 		}
 		
 		static private function errorOnReadFromHTTP(event:Object):void
 		{
 			// Text content will be an error string
			var errorString:String = "Error reading file " + _openedFile;
 			errorString += "\n";
 			errorString += event.fault;
 			_extension = "txt";
 			_fileData = errorString;
 			parseCurrentDataWithExtension();
			CursorManager.removeBusyCursor(); //get rid of hourglass cursor. 
 	   		_openedFile = null;
		}
		
		static private function getExtension(fileName:String):String
		{
			var dotPos:int = fileName.lastIndexOf(".");
			if (dotPos >= 0)
				return fileName.substring(dotPos + 1);
			return fileName;
		}
		
		// hold onto these two in case we need to recreate textFlow
		static private var _extension:String;
		static private var _fileData:String;
		
		static public function parseCurrentDataWithExtension():void
		{
	   		switch (_extension)
	   		{
	   			case "xml":		// use Vellum markup
	   				parseStringIntoFlow(_fileData, TextConverter.TEXT_LAYOUT_FORMAT);
	   				break;
	   			case "txt":
	   				parseStringIntoFlow(_fileData, TextConverter.PLAIN_TEXT_FORMAT);
	   				break;
				case "html":
	   				parseStringIntoFlow(_fileData, TextConverter.TEXT_FIELD_HTML_FORMAT);
	   				break;

	   		}
		}
				
		static private function parseStringIntoFlow(source:String, format:String):void
		{
			var textImporter:ITextImporter = TextConverter.getImporter(format);
			var newFlow:TextFlow = textImporter.importToFlow(source);
			reportImportErrors(textImporter.errors);
			// no TextFlow found - Flow will display an empty TextFlow by design 
			// - alternative is to do some kind of error string
			changeContent(newFlow ? newFlow : new TextFlow());
		} 
 		
		static private function reportImportErrors(errors:Vector.<String>):void
		{
			if (errors)
			{
				var errorText:String = "ERRORS REPORTED ON IMPORT";
				for each(var e:String in errors)
					errorText += "\n" + e;
					
				var dlg:StatusPopup = new StatusPopup();
				dlg.closeFunction = closeStatusPopup;

				PopUpManager.addPopUp(dlg, parentWindow, true);
				PopUpManager.centerPopUp(dlg);
				// stick it in the upper left
				dlg.x = 0;
				dlg.y = 0;
			
				dlg.textArea.text = errorText;
			}
		}
 		static private function closeStatusPopup(dlg:StatusPopup):void
 		{
 			PopUpManager.removePopUp(dlg);
 		}
 			
		static private function importStatusPopupContent(dlg:StatusPopup):void
		{
			switch(dlg.textFormat)
			{
				case TextConverter.TEXT_LAYOUT_FORMAT:
					_extension = "xml";
					break;
				case TextConverter.TEXT_FIELD_HTML_FORMAT:
					_extension = "html";
					break;
			}
			_fileData = dlg.textArea.text;
			parseCurrentDataWithExtension();
			PopUpManager.removePopUp(dlg);
		}
		
		static private function saveStatusPopupContent(dlg:StatusPopup):void
		{
			var extension:String;
			switch(dlg.textFormat)
			{
				case TextConverter.TEXT_LAYOUT_FORMAT:
					extension = "xml";
					break;
				case TextConverter.TEXT_FIELD_HTML_FORMAT:
					extension = "html";
					break;
			}
			
	  		var fileReference:FileReference = new FileReference();
  			fileReference.save(dlg.textArea.text,extension == null ? null : "NewFile."+extension);
		}
		


		// Export related code
		static public function textLayoutExport(activeFlow:TextFlow) : void
		{		
			export(activeFlow, TextConverter.TEXT_LAYOUT_FORMAT);
		}


		static public function htmlExport(activeFlow:TextFlow) : void
		{
			export(activeFlow, TextConverter.TEXT_FIELD_HTML_FORMAT);
		}

		static private const xmlBoilerPlate:String = '<?xml version="1.0" encoding="utf-8"?>\n';
										
		static public function export(activeFlow:TextFlow, format:String) : void
		{
			//CONFIG::debug
			{	
				var originalSettings:Object = XML.settings();
				try
				{
					XML.ignoreProcessingInstructions = false;		
					XML.ignoreWhitespace = false;
					XML.prettyPrinting = false;
					
					
					var exporter:ITextExporter = TextConverter.getExporter(format);
					var xmlExport:XML = exporter.export(activeFlow, ConversionType.XML_TYPE) as XML;
					var result:String = xmlBoilerPlate + xmlExport;					
					XML.setSettings(originalSettings);
				}
				
				catch(e:Error)
				{
					XML.setSettings(originalSettings);
					throw(e);
				}
			}
			
			// show it in the pop-up dialog
			var dlg:StatusPopup = new StatusPopup();
			dlg.closeFunction = closeStatusPopup;
			dlg.importFunction = importStatusPopupContent;
			dlg.saveFunction   = saveStatusPopupContent;
			dlg.textFormat = format;
			
			PopUpManager.addPopUp(dlg, parentWindow, true);
			PopUpManager.centerPopUp(dlg);
			// stick it in the upper left
			dlg.x = 0;
			dlg.y = 0;
	
			dlg.textArea.text = result.replace(/\u000D\u000A/g, "\r"); // workaround for TextArea bug SDK-14797
		}
		


	}
}
