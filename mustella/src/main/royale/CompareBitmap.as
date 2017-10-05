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
package  { 

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.LocalConnection;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.engine.ContentElement;
import flash.text.engine.TextBlock;
import flash.text.engine.TextLine;
import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

import mx.core.IChildList;
import mx.core.IRawChildrenContainer;
import mx.core.mx_internal;

use namespace mx_internal;

/**
*  Vector of conditionalValue objects.
**/
[DefaultProperty("conditionalValues")]

/**
 *  The test step that compares a bitmap against a reference bitmap
 *  MXML attributes:
 *  target
 *  url
 *  timeout (optional);
 *  maxColorVariance
 *  numColorVariances
 *  waitTarget Do Not Use
 *  waitEvent Do Not Use
 *  stageText - placeholder, does nothing
 *
 *
 *  Do not set waitEvent or waitTarget on this step.  They are set internally
 *  to manage the loading of the reference bitmap.  The step prior to this
 *  step must wait for the system to synch up.
 *  
 *  CompareBitmap will parse the url attribute for $testID, replacing with the current testID
 */
public class CompareBitmap extends Assert
{ 
	public static var useRemoteDiffer:Boolean = false;
	
	private static var identityMatrix:String = new Matrix().toString();
	private static var identityColorTransform:String = new ColorTransform().toString();
	
	public static var DEFAULT_MAX_COLOR_VARIANCE:int = 0;
	public static var DEFAULT_NUM_COLOR_VARIANCES:int = 0;
	public static var DEFAULT_MAX_MATRIX_VARIANCE:Number = 0.1;

	// This is the default property.
	public var conditionalValues:Vector.<ConditionalValue> = null;
	
	/**
	 *  The url of the file to read. If UnitTester.createBitmapReferences = true,
	 *  the url to store the bitmap
	 */
	public var url:String;

	
	/**
	 *  placeHolder for stageText, does nothing
	 */
	public var stageText:String;

	private var _maxColorVariance:int = 0;
	/**
	 *  The maximum color variation allowed in a bitmap compare.
	 *  Some machines render slightly differently and thus we have
	 *  to allow the the compare to not be exact.
	 */
	public function get maxColorVariance():int
	{
		if (_maxColorVariance)
			return _maxColorVariance;

		return DEFAULT_MAX_COLOR_VARIANCE;
	}
	public function set maxColorVariance(value:int):void
	{
		_maxColorVariance = value;
	}

	private var _ignoreMaxColorVariance:Boolean = false;
	
	/**
	 * Sometimes you have numColorVariance defined and you don't really care by how much the pixel really differ.
	 * as long as the number of mismatching pixels is &lt;= numColorVariance
	 * Setting this to true will skip the maxColorVariance check (and take the guess work out of picture). default is false
	 */
	public function get ignoreMaxColorVariance():Boolean
	{
		return _ignoreMaxColorVariance;
	}
	
	public function set ignoreMaxColorVariance(value:Boolean):void
	{
		_ignoreMaxColorVariance = value;
	}


	private var _numColorVariances:int = 0;
	/**
	 *  The number of color variation allowed in a bitmap compare.
	 *  Some machines render slightly differently and thus we have
	 *  to allow the the compare to not be exact.
	 */
	public function get numColorVariances():int
	{
		if (_numColorVariances)
			return _numColorVariances;

		return DEFAULT_NUM_COLOR_VARIANCES;
	}
	public function set numColorVariances(value:int):void
	{
		_numColorVariances = value;
	}

	private var _maxMatrixVariance:Number = 0.1;
	/**
	 *  The maximum color variation allowed in a bitmap compare.
	 *  Some machines render slightly differently and thus we have
	 *  to allow the the compare to not be exact.
	 */
	public function get maxMatrixVariance():Number
	{
		if (_maxMatrixVariance)
			return _maxMatrixVariance;
		
		return DEFAULT_MAX_MATRIX_VARIANCE;
	}
	public function set maxMatrixVariance(value:Number):void
	{
		_maxMatrixVariance = value;
	}

	/**
	 *  Suffix to add to the file being written out (the case of a compare failure)
	 */
	public static var fileSuffix:String = "";

	private var reader:Loader;
	private var xmlreader:URLLoader;
	private var writer:URLLoader;

	private static var connection:LocalConnection;
	private static var commandconnection:LocalConnection;
	
	private var baselineMissing:Boolean = false;
	private var baselineMissingMessage:String = "Baseline image could not be read.  Created image file as a .bad.png.";
	private var baselineMissingMessageFail:String = "Baseline image could not be read, and we failed to write the .bad.png";
	
	private function statusHandler(event:Event):void
	{
	}

	/**
	 *  Constructor
	 */
	public function CompareBitmap() 
	{ 
		if (useRemoteDiffer)
		{
			if (!connection)
			{
				connection = new LocalConnection();
				connection.allowDomain("*");
				connection.addEventListener(StatusEvent.STATUS, statusHandler);
	
				commandconnection = new LocalConnection();
				commandconnection.allowDomain("*");
	
				try
				{
					commandconnection.connect("_ImageDifferCommands");
				}
				catch (e:Error)
				{
					trace("connection failed");
				}
			}
		}
	}

	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		var cv:ConditionalValue = null;
		var configID:String = null;
		
		// Use MultiResult to determine the proper URL.
		if(conditionalValues){
			cv = new MultiResult().chooseCV(conditionalValues);
			if(cv){
				// This way, we use CompareBitmap's url (directory) if the CV's is not set.
				if( cv.url != null ){
					url = cv.url;
				}
			}
		}else{
			// We do not have ConditionalValues.  If the current config is unknown, it is probably
			// a desktop AIR run, and we should just let things take the course they always have.
			// If a config is known, then we want to use the new config ID suffix mechanism later.
			configID = TargetConfigurations.getTargetConfigID( UnitTester.cv );
			if( configID ){
				trace( "CompareBitmap: No ConditionalValues found.  configID is " + configID.toString() );
			}else{
				trace( "CompareBitmap: No ConditionalValues found.  configID is " + configID );
			}
		}

		if( url == null ){
			if( cv == null ){
				throw new Error("Found no url on the CompareBitmap for test case " + testCase.testID);
			}else{
				throw new Error("Found no url on the ConditionalValue for test case " + testCase.testID + ", ConditionalValue: " + cv.toString());
			}
		}

		// See if url ends with .png.  If not, create a file name.
		if( url.lastIndexOf( ".png" ) != url.length - 4 ){
			
			// Add a path separator if necessary.
			if( url.lastIndexOf( "/" ) != url.length - 1 ){
				url += "/";
			}		

			// Decide on a file name.
			if( conditionalValues ){
				// If we ended up with a matching CV, ask it to create a file name.
				// Otherwise, go with the test ID.
				// Keep this path alive until (if ever) ConditionalValues in CompareBitmaps have all been removed.
				if(cv){
					trace( "CompareBitmap: Asking the ConditionalValue to create the file name." );
					url += cv.createFilename( testCase.testID );
				} else {
					trace( "CompareBitmap: Creating the file name from the testID." );
					url += testCase.testID + ".png";
				}
			}else if( configID ){
				// We have no ConditionalValues and we're running a known config,
				// so use the config id in the suffix.
				trace( "CompareBitmap: Creating the file name from the configID." );
				url += testCase.testID + "@" + configID + ".png";
			}else{
				trace( "There is no file name, there are no Conditional Values, and there is no configID.  There's not much we can do now, is there?" );
			}
		}
		
		if (url != null && url.indexOf ("$testID") != -1) { 
			trace ("SAW THE REF, I'll plug it");
			url = url.replace ("$testID", UnitTester.currentTestID);
			trace ("result 2: " + url);
		}

		if (url == null)
			trace ("URL was null at execute time");

		if (commandconnection)
			commandconnection.client = this;

		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			return true;
		}

		if (stageText)
			updateStageTexts(actualTarget);
		
		this.root = root;
		this.context = context;
		this.testResult = testResult;

		if (UnitTester.createBitmapReferences)
		{
			if (UnitTester.checkEmbeddedFonts)
			{
				if (!checkEmbeddedFonts(actualTarget))
				{
					testResult.doFail ("Target " + actualTarget + " is using non-embedded or advanced anti-aliased fonts");	
					return true;
				}
			}

			writeBaselines(actualTarget);
			return false;
		}
		else
		{
			readPNG();
			return false;
		}

	}

	// there are a few mobile tests that use StageText in the bitmaps
	// which are TextFields in the emulator.  This makes them use
	// embedded fonts to get consistency across platforms.
	private function updateStageTexts(target:DisplayObject):void
	{
		var doc:DisplayObjectContainer = target as DisplayObjectContainer;
		var tf:Object;
		tf = findTextWidget(doc);
		if (tf)
		{
			var n:int = target.stage.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				var stf:TextField = target.stage.getChildAt(i) as TextField;
				if (stf)
				{
					var stfm:TextFormat = new TextFormat(tf.getStyle("fontFamily"),
															tf.getStyle("fontSize"),
															tf.getStyle("color"),
															tf.getStyle("fontWeight") == "bold",
															tf.getStyle("fontStyle") == "italic"
															);
					stf.defaultTextFormat = stfm;
					stf.embedFonts = true;
				}
			}
		}
	}
	
	private function findTextWidget(doc:DisplayObjectContainer):Object
	{
		if (!doc) return null;
		var n:int = doc.numChildren;
		for (var i:int = 0; i < n; i++)
		{
			var child:DisplayObject = doc.getChildAt(i);
			var className:String = getQualifiedClassName(child);
			if (className.indexOf("StyleableStageText") > -1)
				return child;
			else if (child is DisplayObjectContainer)
			{
				var tf:Object = findTextWidget(child as DisplayObjectContainer);
				if (tf) return tf;
			}
		}
		return null;
	}
	
	private function getTargetSize(target:DisplayObject):Point
	{
		var width:Number;
		var height:Number;

        try
        {  
            width = target["getUnscaledWidth"]() * Math.abs(target.scaleX) * target.root.scaleX;
            height = target["getUnscaledHeight"]() * Math.abs(target.scaleY) * target.root.scaleY;
        }
        catch(e:ReferenceError)
        {
            width = target.width * target.root.scaleX;
            height = target.height * target.root.scaleY;
        }
        trace("getTargetSize: height: ", target.height);
        trace("getTargetSize: root.height: ", target.root.height);
        trace("getTargetSize: stageHeight: ", target.stage.stageHeight);
        try {
        trace("getTargetSize: loaderInfo.height: ", target.loaderInfo.height);
        } catch (e:Error) {};
        
		return new Point(width, height);
	}

	// Given a displayObject, sets up the screenBits.
	private function getScreenBits(target:DisplayObject):void{
		try 
		{
			var targetSize:Point = getTargetSize(target);
			var stagePt:Point = target.localToGlobal(new Point(0, 0));
            var altPt:Point = target.localToGlobal(targetSize);
            stagePt.x = Math.min(stagePt.x, altPt.x);
            stagePt.y = Math.min(stagePt.y, altPt.y);
			screenBits = new BitmapData(targetSize.x, targetSize.y);
			screenBits.draw(target.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
		}
		catch (se:SecurityError)
		{
			UnitTester.hideSandboxes();
			try
			{
				screenBits.draw(target.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
			}
			catch (se2:Error)
			{
				try 
				{
					// if we got a security error and ended up here, assume we're in the
					// genericLoader loads us scenario
					screenBits.draw(target.root, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
				}
				catch (se3:Error)
				{
				}
			}
			UnitTester.showSandboxes();
			var sb:Array = UnitTester.getSandboxBitmaps();
			var n:int = sb.length;
			for (var i:int = 0; i < n; i++)
			{
				mergeSandboxBitmap(target, stagePt, screenBits, sb[i]);
			}
		}
		catch (e:Error)
		{
			testResult.doFail (e.getStackTrace());	
		}
	}

	private var MAX_LC:int = 12000;
	private var screenBits:BitmapData;
	private var baselineBits:BitmapData;

	private var compareVal:Object;
	
	public function comparePNG(target:DisplayObject):Boolean 
	{ 
		if (UnitTester.checkEmbeddedFonts)
		{
			if (!checkEmbeddedFonts(target))
			{
				testResult.doFail ("Target " + target + " is using non-embedded or advanced anti-aliased fonts");	
				return true;
			}
		}

		try {
			if (!reader.content)
			{
				testResult.doFail ("baseline image not available");
				return true;
			}
		} catch( e:Error ) {
			testResult.doFail ("CompareBitmap BIG FAIL! Content reader is null!");
			return true;
		}
		
		getScreenBits(target);

		try
		{
			baselineBits = new BitmapData(reader.content.width, reader.content.height);
			baselineBits.draw(reader.content, new Matrix());

			compareVal = baselineBits.compare (screenBits);
		
			if (compareVal is BitmapData && numColorVariances)
				compareVal = compareWithVariances(compareVal as BitmapData)

			if (compareVal != 0)
			{
				trace ("compare returned" + compareVal);
				
				var req:URLRequest = new URLRequest();
				if (UnitTester.isApollo) 
				{
					req.url = encodeURI2(CompareBitmap.adjustPath (url));
				} 
				else
				{
					req.url = url;
					var base:String = normalizeURL(context.application.url);
					base = base.substring(0, base.lastIndexOf("/"));
					while (req.url.indexOf("../") == 0)
					{
						base = base.substring(0, base.lastIndexOf("/"));
						req.url = req.url.substring(3);
					}
					
					req.url = encodeURI2(base + "/" + req.url);
				}
				
				req.url += ".xml";
				xmlreader = new URLLoader();
				xmlreader.addEventListener(Event.COMPLETE, readXMLCompleteHandler);
				xmlreader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, readErrorHandler);
				xmlreader.addEventListener(IOErrorEvent.IO_ERROR, readXMLIOErrorHandler);
				xmlreader.load (req);	
				return false;
			}
		}
		catch (e:Error) 
		{ 
			testResult.doFail (e.getStackTrace());	
		}
		return true;
	}
		
	private function readXMLCompleteHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		var s:String = getDisplayListXML(actualTarget).toXMLString();
		var t:String = xmlreader.data;
		s = s.replace(/\r/g, "");
		t = t.replace(/\r/g, "");		
		if (s !== t && xmldiffer(s, t))
		{
			testResult.doFail ("compare returned" + compareVal, absolutePathResult(url) + ".bad.png");
			
			if (useRemoteDiffer)
			{
				sendImagesToDiffer();
			} 
			else if (fileSuffix != "") 
			{ 
				writeBaselines (actualTarget);
			}
		}
		else
			stepComplete();
	}
	
	private function readXMLIOErrorHandler(event:Event):void
	{
		if (useRemoteDiffer)
		{
			sendImagesToDiffer();
		} 
		else if (fileSuffix != "") 
		{ 
			testResult.doFail ("compare returned" + compareVal, absolutePathResult(url) + ".bad.png");
			var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
			writePNG (actualTarget);
		}	
	}
	
	private function mergeSandboxBitmap(target:DisplayObject, pt:Point, bm:BitmapData, obj:Object):void
	{
		var targetSize:Point = getTargetSize(target);
		var sbm:BitmapData = new BitmapData(obj.width, obj.height);
		var srcRect:Rectangle = new Rectangle(0, 0, obj.width, obj.height);
		sbm.setPixels(srcRect, obj.bits);
		var targetRect:Rectangle = new Rectangle(pt.x, pt.y, targetSize.x, targetSize.y);
		var sbRect:Rectangle = new Rectangle(obj.x, obj.y, obj.width, obj.height);
		var area:Rectangle = targetRect.intersection(sbRect);
		if (area)
			bm.copyPixels(sbm, srcRect, target.globalToLocal(area.topLeft));
	}

	private function sendImagesToDiffer():void
	{
		UnitTester.callback = stringifyScreen;
	}

	private var ba:ByteArray;
	private function stringifyScreen():void
	{
		ba = screenBits.getPixels(screenBits.rect);
		ba.position = 0;
		connection.send("_ImageDiffer", "startScreenData", screenBits.width, screenBits.height, ba.length, UnitTester.currentTestID, UnitTester.currentScript);
		UnitTester.callback = sendScreen;
	}

	private function sendScreen():void
	{
		if (ba.position + MAX_LC < ba.length)
		{
			connection.send("_ImageDiffer", "addScreenData", stringify(ba));
			UnitTester.callback = sendScreen;
		}
		else
		{
			connection.send("_ImageDiffer", "addScreenData", stringify(ba));
			UnitTester.callback = stringifyBase;
		}
	}

	private function stringifyBase():void
	{
		ba = baselineBits.getPixels(baselineBits.rect);
		ba.position = 0;
		connection.send("_ImageDiffer", "startBaseData", baselineBits.width, baselineBits.height, ba.length);
		UnitTester.callback = sendBase;
	}

	private function sendBase():void
	{
		if (ba.position + MAX_LC < ba.length)
		{
			connection.send("_ImageDiffer", "addBaseData", stringify(ba));
			UnitTester.callback = sendBase;
		}
		else
		{
			connection.send("_ImageDiffer", "addBaseData", stringify(ba));
			connection.send("_ImageDiffer", "compareBitmaps");
		}
	}

	private function stringify(ba:ByteArray):String
	{
		var n:int = Math.min(ba.length - ba.position, MAX_LC);
		var arr:Array = [];
		for (var i:int = 0; i < n; i++)
		{
			var b:int = ba.readUnsignedByte();
			arr.push(b.toString(16))
		}
		return arr.toString();
	}

	private function readCompleteHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		if (comparePNG(actualTarget))
			preStepComplete();
	}

	private function readErrorHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		getScreenBits(actualTarget);
		
		baselineMissing = true;
		writePNG(actualTarget);
		// writePNG() creates error handlers which will handle the fail and stepComplete().
	}

	public function readPNG():void
	{
		var req:URLRequest = new URLRequest();
		if (UnitTester.isApollo) 
		{
			req.url = encodeURI2(CompareBitmap.adjustPath (url));
		} 
		else
        {
            req.url = url;
            var base:String = normalizeURL(context.application.url);
            base = base.substring(0, base.lastIndexOf("/"));
            while (req.url.indexOf("../") == 0)
            {
                    base = base.substring(0, base.lastIndexOf("/"));
                    req.url = req.url.substring(3);
            }

            req.url = encodeURI2(base + "/" + req.url);
        }
		//	req.url = encodeURI2(url);
		// }
	
		reader = new Loader();

		trace ("readPNG:requesting url: " + req.url);
    	reader.contentLoaderInfo.addEventListener(Event.COMPLETE, readCompleteHandler);
    	reader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, readErrorHandler);
    	reader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, readErrorHandler);

		reader.load (req);	
	}


	public static var adjustPath:Function = function(url:String):String { return url; };




    public function getPngByteArray(target:DisplayObject, bitmapData:BitmapData):ByteArray 
	{
		// add png headers
		if (UnitTester.createBitmapReferences)
		{
			var targetSize:Point = getTargetSize(target);
			var stagePt:Point = target.localToGlobal(new Point(0, 0));
            var altPt:Point = target.localToGlobal(targetSize);
            stagePt.x = Math.min(stagePt.x, altPt.x);
            stagePt.y = Math.min(stagePt.y, altPt.y);
			bitmapData = new BitmapData(targetSize.x, targetSize.y);
			bitmapData.draw(target.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));

		} 
		var png:MustellaPNGEncoder = new MustellaPNGEncoder();
		var ba:ByteArray = png.encode (bitmapData);

		return ba;
	}

	public function writeBaselines(target:DisplayObject, writeDisplayList:Boolean = true):void 
	{
		var req:URLRequest = new URLRequest();
		writer = new URLLoader();
		req.method = "POST";
		
		/**
		 * either we got called here to write new baselines
		 * or to save a .bad.png for investigation
		 * in addition, with failures, we upload baseline and failure to a server
		 */
		if (UnitTester.createBitmapReferences) 
		{	
			fileSuffix = "";
		} 
		

		if (writeDisplayList)
		{
			var s:String = getDisplayListXML(target).toXMLString();
			// request data goes on the URL Request
			req.data = s;
			
			req.contentType = "text/xml";
			if (UnitTester.isApollo) 
			{ 
				req.url = encodeURI2(UnitTester.bitmapServerPrefix + adjustWriteURI(adjustPath(url))) + fileSuffix + ".xml";
			} else 
			{
				req.url = encodeURI2(UnitTester.bitmapServerPrefix + absolutePath(url)) + fileSuffix + ".xml";
			}
			trace ("writing url: " + req.url);
			writer.addEventListener(Event.COMPLETE, writeXMLCompleteHandler);
			writer.addEventListener(SecurityErrorEvent.SECURITY_ERROR, writeErrorHandler);
			writer.addEventListener(IOErrorEvent.IO_ERROR, writeErrorHandler);
			
			writer.load (req);	
		}
	}
		
	private function writeXMLCompleteHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		writePNG(actualTarget);
	}
	
	private function writePNG(target:DisplayObject):void
	{
		var req:URLRequest = new URLRequest();
		writer = new URLLoader();
		req.method = "POST";
		
		var ba:ByteArray = getPngByteArray(target, screenBits);			
		trace ("image size: " + ba.length);
		// request data goes on the URL Request
		req.data = ba;
		// can't send this, don't need to anyway var rhArray:Array = new Array(new URLRequestHeader("Content-Length", new String(ba.length) ));
		
		req.contentType = "image/png";
		
		if (UnitTester.isApollo) 
		{ 
			req.url = encodeURI2(UnitTester.bitmapServerPrefix + adjustWriteURI(adjustPath(url))) + fileSuffix;
		} else 
		{
			req.url = encodeURI2(UnitTester.bitmapServerPrefix + absolutePath(url)) + fileSuffix;
		}
		trace ("writing url: " + req.url);
		writer.addEventListener(Event.COMPLETE, writeCompleteHandler);
		writer.addEventListener(SecurityErrorEvent.SECURITY_ERROR, writeErrorHandler);
		writer.addEventListener(IOErrorEvent.IO_ERROR, writeErrorHandler);
			
		writer.load (req);	
			

		/// If this is about creating bitmaps, skip the upload, we're done
		if (UnitTester.createBitmapReferences || UnitTester.run_id == "-1" || baselineMissing)
			return;

		//// Upload
		var writer2:URLLoader = new URLLoader();
		var reqScreen:URLRequest = new URLRequest();

		reqScreen.method = "POST";

		/// we already have the screen data in hand:
		reqScreen.data = ba;

		/// fill in the blanks
		reqScreen.contentType = "image/png";
		reqScreen.url = UnitTester.urlAssemble ("screen", 
			context.testDir, context.scriptName, this.testResult.testID, UnitTester.run_id);

		trace ("upload: " + reqScreen.url);
        	writer2.addEventListener(Event.COMPLETE, uploadCompleteHandler);
        	writer2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadErrorHandler);
        	writer2.addEventListener(IOErrorEvent.IO_ERROR, uploadErrorHandler);
		writer2.load (reqScreen);


		/// get the baseline stuff:
		var writer3:URLLoader = new URLLoader();
		var reqBaseline:URLRequest = new URLRequest();
		/// needed?
		var baBase:ByteArray = getPngByteArray(target, baselineBits);
		
		reqBaseline.data = baBase;
		reqBaseline.contentType = "image/png";
		reqBaseline.method = "POST";
		
		reqBaseline.url = UnitTester.urlAssemble ("baseline", 
			context.testDir, context.scriptName, this.testResult.testID, UnitTester.run_id);

		trace ("upload: " + reqBaseline.url);
        	writer3.addEventListener(Event.COMPLETE, upload2CompleteHandler);
        	writer3.addEventListener(SecurityErrorEvent.SECURITY_ERROR, upload2ErrorHandler);
        	writer3.addEventListener(IOErrorEvent.IO_ERROR, upload2ErrorHandler);
		writer3.load (reqBaseline);


    }

	private function adjustWriteURI(url:String):String
	{
		var pos:int = url.indexOf("file:///");
		if (pos != 0)
		{
			return url;
		}
		url = url.substring(8);
		pos = url.indexOf("|");

		if (pos != 1)
		{
			return url;
		}

		var drive:String = url.substring(0, 1);
		drive = drive.toLowerCase();
		return drive + ":" + url.substring(2);
	}

	private var screenDone:Boolean = false;
	private var baselineDone:Boolean = false;

	private function writeCompleteHandler(event:Event):void
	{
		trace("baseline write successful " + event);
		if( baselineMissing ){
			baselineMissing = false;
			testResult.doFail( baselineMissingMessage );
		}
		stepComplete();
	}

	private function uploadCompleteHandler(event:Event):void
	{
		trace("screen image upload successful " + event);
		screenDone = true;
		checkForStepComplete();
	}

	private function upload2CompleteHandler(event:Event):void
	{
		trace("baseline image upload successful " + event);
		baselineDone = true;
		checkForStepComplete();
	}

	private function writeErrorHandler(event:Event):void
	{
		if( baselineMissing ){
			baselineMissing = false;
			testResult.doFail( baselineMissingMessageFail );
			stepComplete();
		}else{
			testResult.doFail ("error on baseline write: " + event);
			trace("Image baseline write failed " + event);
			if (UnitTester.createBitmapReferences)
				stepComplete();
		}
	}
	private function uploadErrorHandler(event:Event):void
	{
		testResult.doFail ("error on baseline write: " + event);
		trace("Image screen upload failed " + event);
		screenDone = true;
		checkForStepComplete();
	}

	private function upload2ErrorHandler(event:Event):void
	{
		testResult.doFail ("error on baseline write: " + event);
		trace("Image baseline upload failed " + event);
		baselineDone = true;
		checkForStepComplete();
	}

	private function checkForStepComplete():void
	{

		if (baselineDone && screenDone)
			preStepComplete();


	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = (UnitTester.createBitmapReferences) ? "CreateBitmap: " : "CompareBitmap";
		if (target)
			s += ": target = " + target;
		if (url)
			s += ", url = " + url;
		return s;
	}

	private function absolutePathResult(url:String):String
	{ 

                var base:String = null;

		if (UnitTester.isApollo) 
		{
                	base = adjustWriteURI(adjustPath (url));
		} else 
		{
                	base = context.application.url;

		}

                base = normalizeURL(base);
		base = base.substring (base.indexOf ("mustella/tests")+14);


		if (!UnitTester.isApollo) 
		{
                	base = base.substring(0, base.lastIndexOf("/"));
		
			var tmp:String = url;

			while (tmp.indexOf("../") == 0)
			{
        			base = base.substring(0, base.lastIndexOf("/"));
        			tmp = tmp.substring(3);
			}

			return base +"/" + tmp;
		} else
		{
			return base;

		}



	}

	private function absolutePathHttp(url:String):String
	{

		if (url.indexOf ("..") == 0)
			return url.substring (3);
		else
			return url;


	}


	
	private function absolutePath(url:String):String
	{
		var swf:String = normalizeURL(root.loaderInfo.url);

		var pos:int = swf.indexOf("file:///");


		if (pos != 0)
		{
		
			var posH:int = swf.indexOf("http://");
			if (posH == 0)
			{
				return absolutePathHttp (url);
			} else
			{

				trace("WARNING: unexpected swf url format, no file:/// at offset 0");
				return url;
			}
		}
		swf = swf.substring(8);
		pos = swf.indexOf("|");
		if (pos != 1)
		{
			trace("WARNING: unexpected swf url format, no | at offset 1 in: " + swf);
			// assume we're on a mac or other unix box, it will do no harm
			return "/" + swf.substring(0, swf.lastIndexOf ("/")+1)  + url;
		}

		var drive:String = swf.substring(0, 1);
		drive = drive.toLowerCase();
		return drive + ":" + swf.substring(2, swf.lastIndexOf("/") + 1) + url;
	}


        public static function normalizeURL(url:String):String
        {
        	var results:Array = url.split("/[[DYNAMIC]]/");
        	return results[0];
        }


	public function keepGoing():void
	{
		trace("keepgoing", url, hasEventListener("stepComplete"));
		preStepComplete();
	}

	private function encodeURI2(s:String):String
	{
		var pos:int = s.lastIndexOf("/");
		if (pos != -1)
		{
			var fragment:String = s.substring(pos + 1);
			s = s.substring(0, pos + 1);
			fragment= encodeURIComponent(fragment);
			s = s + fragment;
		}
		return s;
	}

	private function compareWithVariances(bm:BitmapData):Object
	{

		var totalAllowed:int = numColorVariances * UnitTester.pixelToleranceMultiplier;
		var allowed:int = totalAllowed;
		var n:int = bm.height;
		var m:int = bm.width;

		for (var i:int = 0; i < n; i++)
		{
			for (var j:int = 0; j < m; j++)
			{
				var pix:int = bm.getPixel(j, i);
				if (pix)
				{
					if(!ignoreMaxColorVariance)
					{
						var red:int = pix >> 16 & 0xff;
						var green:int = pix >> 8 & 0xff;
						var blue:int = pix & 0xff;
						if (red & 0x80)
							red = 256 - red;
						if (blue & 0x80)
							blue = 256 - blue;
						if (green & 0x80)
							green = 256 - green;
						if (red > maxColorVariance ||
							blue > maxColorVariance ||
							green > maxColorVariance)
						{
							var max:int = Math.max(Math.max(red, blue), green);
							trace("CompareBitmap: exceeded maxColorVariance=" + maxColorVariance + " max(red,green,blue)=" + max);
							return bm;
						}
					}
					allowed--;
					if (allowed < 0)
					{
						trace("CompareBitmap: exceeded numColorVariances=" + numColorVariances);
						return bm;
					}
				}
			}
		}
		
		trace("CompareBitmap: numColorVariances seen=" + String(totalAllowed - allowed));
		return 0;
	}

	private function checkEmbeddedFonts(target:Object):Boolean
	{
		if ("rawChildren" in target)
			target = target.rawChildren;

		if (target is TextField)
		{
			if (target.embedFonts == false)
				return false;
			if (target.antiAliasType == "advanced")
				return false;
			return true;
		}
		else if ("numChildren" in target)
		{
			var n:int = target.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				if (!checkEmbeddedFonts(target.getChildAt(i)))
					return false;
			}
		}
		
		return true;
	}
	
	protected function preStepComplete():void
	{
		if (baselineBits != null)
            baselineBits.dispose();
        if (screenBits != null)
            screenBits.dispose();

		reader=null;
		writer=null;
		
		stepComplete();
	}

	/* this was sometimes getting called before the image was loaded into
	   'reader' which made it null and then the readCompleteHandler failed.
	override protected function stepComplete():void 
	{ 

                if (baselineBits != null)
                        baselineBits.dispose();
                if (screenBits != null)
                        screenBits.dispose();

		reader=null;
		writer=null;
		
		super.stepComplete();


	}*/

	/****** DisplayList Comparision ******/
	protected function getDisplayListProperties(d:DisplayObject, noMask:Boolean = false):XML
	{
		var xml:XML;
		var n:int;
		var i:int;
		var childXML:XML;
		var s:String = getQualifiedClassName(d);
		s = s.replace("::", ".");
		xml = new XML("<" + s + "/>");
		s = d.transform.concatenatedColorTransform.toString();
		if (s != identityColorTransform)
			xml.@concatenatedColorTransform = s;
		if (d.transform.matrix)
		{
			s = d.transform.matrix.toString();
			if (s != identityMatrix)
			{
				if (s.indexOf("(a=1, b=0, c=0, d=1, ") == -1)
					xml.@matrix = s;
			}
		}
		else
		{
			s = d.transform.matrix3D.rawData.toString();
			xml.@matrix3D = s;
		}
		if (d.x != 0)
			xml.@x = d.x;
		if (d.y != 0)
			xml.@y = d.y;
		xml.@width = d.width;
		xml.@height = d.height;
		if (xml.visible == false)
			xml.@visible = "false";
		if (d.mask && d.mask != d.parent && !noMask)
		{
			xml.mask = <mask/>;
			childXML = getDisplayListProperties(d.mask, true);
			xml.mask.appendChild = childXML;
		}
		if (d.scrollRect)
		{
			s = d.scrollRect.toString();
			xml.@scrollRect = s;
		}
		if (d.blendMode && d.blendMode != "normal")
			xml.@blendMode = d.blendMode;
		if (d.cacheAsBitmap)
			xml.@cacheAsBitmap = "true";
        try {
    		if (d.filters && d.filters.length > 0)
    		{
    			s = d.filters.toString();
    			xml.@filters = s;
    		}
        } catch (e:Error)
        {
            // seems to throw arg error when Shader applied
        }
		if (d.opaqueBackground)
			xml.@opaqueBackground = "true";
		if (d.scale9Grid)
		{
			s = d.scale9Grid.toString();
			xml.@scale9Grid = s;
		}
		if (d is TextField)
		{
			xml.@underline = TextField(d).defaultTextFormat.underline;
			xml.htmlText = TextField(d).htmlText;
		}
		if (d is Loader && Loader(d).contentLoaderInfo.contentType.indexOf("image") != -1)
		{
			s = Loader(d).contentLoaderInfo.url;
			s = s.substring(s.lastIndexOf("/") + 1);
			xml.@loaderbitmap = s;
		}
		if (d is TextLine)
		{
			var tl:TextLine = TextLine(d);
			xml.@ascent = tl.ascent;
			xml.@descent = tl.descent;
			xml.@atomCount = tl.atomCount;
			xml.@hasGraphicElement = tl.hasGraphicElement;
			if (tl.textBlock)
			{
				var tb:TextBlock = TextLine(d).textBlock;
				var ce:ContentElement = tb.content;
				s = ce.rawText.substr(tl.textBlockBeginIndex, tl.rawTextLength);
				xml.@text = s;
			}
		}
		
		if (d is IRawChildrenContainer)
		{
			var rawChildren:IChildList = IRawChildrenContainer(d).rawChildren;
			n = rawChildren.numChildren;
			for (i = 0; i < n; i++)
			{
				childXML = getDisplayListProperties(rawChildren.getChildAt(i));
				xml.appendChild(childXML);				
			}
		}
		else if (d is DisplayObjectContainer)
		{
			var doc:DisplayObjectContainer = d as DisplayObjectContainer;
			n = doc.numChildren;
			for (i = 0; i < n; i++)
			{
                var child:DisplayObject = doc.getChildAt(i);
                if (child) // was null in an FCK test.
                {
    				childXML = getDisplayListProperties(child);
    				xml.appendChild(childXML);				
                }
                else
                    xml.appendChild(<NullChild />);
			}
		}
		return xml;
	}
	
	// scan entire display list, but only dump objects intersecting target
	protected function getDisplayListXML(target:DisplayObject):XML
	{
		var i:int;
		var n:int;
		var child:DisplayObject;
		var childXML:XML;
		
		var doc:DisplayObjectContainer = DisplayObjectContainer(target.root);
		var xml:XML = <DisplayList />;
		if (doc is IRawChildrenContainer)
		{
			var rawChildren:IChildList = IRawChildrenContainer(doc).rawChildren;
			n = rawChildren.numChildren;
			for (i = 0; i < n; i++)
			{
				child = rawChildren.getChildAt(i);
				if (target.hitTestObject(child))
				{
					childXML = getDisplayListProperties(child);
					xml.appendChild(childXML);	
				}
			}
		}
		else 
		{
			n = doc.numChildren;
			for (i = 0; i < n; i++)
			{
				child = doc.getChildAt(i);
				if (target.hitTestObject(child))
				{
					childXML = getDisplayListProperties(child);
					xml.appendChild(childXML);									
				}
			}
		}
		return xml;
	}

	private function differ(s:String, t:String):Boolean
	{
		var retval:Boolean = false;
		
		var sl:Array = s.split("\n");
		var tl:Array = t.split("\n");
		trace(sl.length, tl.length);
		var n:int = Math.max(sl.length, tl.length);
		for (var i:int = 0; i < n; i++)
		{
			var a:String = (i < sl.length) ? sl[i] : "";
			var b:String = (i < tl.length) ? tl[i] : "";
			if (a != b)
			{
				a = trimTag(a);
				b = trimTag(b);
				if (a != b && !nullChildOrStaticText(a, b))
				{
					retval = true;
					var c:String = "";
					var d:String = "";
					trace(i, "cur: ", a);
					trace(i, "xml: ", b);
					var m:int = Math.max(a.length, b.length);
					for (var j:int = 0; j < m; j++)
					{
						c += a.charCodeAt(j) + " ";
						d += b.charCodeAt(j) + " ";
					}
					trace(i, "cur: ", c);
					trace(i, "xml: ", d);
				}
			}
		}
		return retval;
	}
	
	// attempt to strip off random unique name chars for embedded assets
	private function trimTag(a:String):String
	{
		var c:int;
		var d:int;
		
		d = a.indexOf("<");
		if (d != -1)
		{
			c = a.indexOf(" ", d);
			if (c == -1 && a.length > d + 2 && a.charAt(d + 1) == '/')
				c = a.indexOf(">"); // closing tag
			if (c != -1)
			{
				var rest:String = a.substring(c);
				for (var i:int = c - 1;i > 0; i--)
				{
					var ch:String = a.charAt(i);
					if ((ch >= '0' && ch <= '9') || ch == '_')
					{
						// assume it is a random char
					}
					else
						break;
				}
				return a.substring(0, i + 1) + rest;
			}
		}
		return a;
	}
	
    // attempt to strip off random unique name chars for embedded assets
    private function trimName(a:String):String
    {
        var c:int;
        var d:int;
        
        c = a.length;
        for (var i:int = c - 1;i >= 0; i--)
        {
            var ch:String = a.charAt(i);
            if ((ch >= '0' && ch <= '9') || ch == '_')
            {
                // assume it is a random char
            }
            else
                break;
        }
        return a.substring(0, i + 1);
    }

    // static text seems to float around a bit so ignore it.
	private function nullChildOrStaticText(a:String, b:String):Boolean
	{
		if (a.indexOf("<NullChild") != -1)
			return true;
		if (b.indexOf("<NullChild") != -1)
			return true;
		if (a.indexOf("<flash.text.StaticText") != -1)
			return true;
		if (b.indexOf("<flash.text.StaticText") != -1)
			return true;
		return false;
	}

    private function xmldiffer(s:String, t:String):Boolean
    {
        var retval:Boolean = false;
        
        var xmls:XML = XML(s);
        var xmlt:XML = XML(t);
        retval = compareNodes(xmls, xmlt);
        if (retval)
            differ(s, t);
        return retval;
    }
    
    private static var xywidthheight:Object = { x: 1, y: 1, width: 1, height: 1};
    
    private function compareNodes(s:XML, t:XML):Boolean
    {
        var retval:Boolean = false;
        var q:String;
        var i:int;
        var j:int;
        var n:int;
        var m:int;
        var st:String;
        var tt:String;
        var sv:String;
        var tv:String;
        
        if (s.toXMLString() == t.toXMLString())
            return false;
        
        // compare tag names
        var sn:String = s.name().toString();
        var tn:String = t.name().toString();
        var sparts:Array = sn.split(".");
        var tparts:Array = tn.split(".");
        n = sparts.length;
        for (i = 0; i < n; i++)
            sparts[i] = trimName(sparts[i]);
        n = tparts.length;
        for (i = 0; i < n; i++)
            tparts[i] = trimName(tparts[i]);
        sn = sparts.join(".");
        tn = tparts.join(".");
        if (tn != sn)
        {
            if (sn == "NullChild" || sn == "flash.display.StaticText" ||
                tn == "NullChild" || tn == "flash.display.StaticText")
            {
                // inconsistent behavior around StaticText   
                return false;
            }
            else if (!oneMoreNameCompare(sn, tn))
            {
                trace("tag name mismatch: cur=", sn, "xml=", tn);
                retval = true;
            }
        }
        
        var sa:XMLList = s.attributes();
        var ta:XMLList = t.attributes();
        n = sa.length();
        m = ta.length();
        if (n != m)
        {
            trace(sn, "different number of attributes: cur=", n, "xml=", m);
            retval = true;
        }
        else
        {
            for (i = 0; i < n; i++)
            {
                st = sa[i].name().toString();
                tt = ta[i].name().toString();
                if (st != tt)
                {
                    trace(sn, "attribute name mismatch: cur=", st, "xml=", tt);
                    retval = true;
                }
                else 
                {
                    sv = s['@' + st].toString();
                    tv = t['@' + tt].toString();
                    if (sv != tv)
                    {
                        if (xywidthheight[st] == 1)
                        {
                            var sf:Number = Number(sv);
                            var tf:Number = Number(tv);
                            if (Math.abs(tf - sf) > maxMatrixVariance)
                            {
                                trace(sn + '@' + st, "attribute value mismatch: cur=", sv, "xml=", tv);
                                retval = true;
                            }
                        }
                        else if (st == "matrix")
                        {
                            // strip parens
                            sv = sv.substring(1, sv.length - 2);
                            tv = tv.substring(1, tv.length - 2);
                            sparts = sv.split(",");
                            tparts = tv.split(",");
                            m = sparts.length;
                            for (j = 0; j < m; j++)
                            {
                                sv = sparts[j];
                                tv = tparts[j];
                                sv = sv.split("=")[1];
                                tv = tv.split("=")[1];
                                sf = Number(sv);
                                tf = Number(tv);
                                if (Math.abs(tf - sf) > maxMatrixVariance)
                                {
                                    trace(sn + '@' + st, "matrix value mismatch: cur=", sv, "xml=", tv);
                                    retval = true;                                    
                                }
                            }
                        }
                        else
                        {
                            trace(sn + '@' + st, "attribute value mismatch: cur=", sv, "xml=", tv);
                            retval = true;
                        }
                    }
                }
            }
        }
        
        var sl:XMLList = s.children();
        var tl:XMLList = t.children();
        n = sl.length();
        m = tl.length();
        if (n != m)
        {
            trace(sn, "different number of children: cur=", n, "xml=", m);
            retval = true;
        }
        else
        {
            for (i = 0; i < n; i++)
            {
                var nk:String = sl[i].nodeKind();
                if (nk == "text")
                {
                    if (sl[i].text() != tl[i].text())
                    {
                        trace(sn, "different number of text nodes: cur=", sl[i].text(), "xml=", tl[i].text());
                        retval = true;
                    }
                }
                else if (nk == "element")
                {
                    if (compareNodes(sl[i], tl[i]))
                        retval = true;
                }
            }
        }
        return retval;
    }

	private function oneMoreNameCompare(a:String, b:String):Boolean
	{
		var aParts:Array = a.split("_");
		var bParts:Array = b.split("_");
		var i:int;
		var n:int;
		n = aParts.length;
		for (i = 0; i < n; i++)
			aParts[i] = trimName(aParts[i]);
		n = bParts.length;
		for (i = 0; i < n; i++)
			bParts[i] = trimName(bParts[i]);
		a = aParts.join("_");
		b = bParts.join("_");
		return a == b;
	}
}

}
