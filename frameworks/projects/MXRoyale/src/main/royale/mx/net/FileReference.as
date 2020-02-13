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

package mx.net
{

 import org.apache.royale.file.FileProxy;
 import org.apache.royale.file.beads.FileBrowserWithFilter;
 import mx.utils.ByteArray;
 import org.apache.royale.file.beads.FileLoader;
 import org.apache.royale.file.beads.FileModel;
 import org.apache.royale.file.beads.FileLoaderAndUploader;
 import org.apache.royale.events.Event;
 import org.apache.royale.net.URLRequest;

   public class FileReference extends FileProxy
   {
      
      private var _model:FileModel;
      private var _browser:FileBrowserWithFilter;
      private var _loader:FileLoader;
      private var _uploader:FileLoaderAndUploader;
      public function FileReference()
      {
		  super();
		  _model = new FileModel();
		  _browser = new FileBrowserWithFilter();
		  _uploader = new FileLoaderAndUploader();
		  addBead(_model);
		  addBead(_browser);
		  addBead(_uploader);
		  addEventListener("modelChanged", modelChangedHandler);
	  }
  
      
      public function browse(typeFilter:Array = null):Boolean
      {
         var allFilters:Array = [];
         if (typeFilter)
		 {
			for (var i:int = 0; i < typeFilter.length; i++)
			{
				var fileFilter:FileFilter = typeFilter[i] as FileFilter;
				var filters:Array = fileFilter.extension.split(";");
				allFilters = allFilters.concat(filters);
			}
			_browser.filter = allFilters.join(",");
		 }
		 _browser.browse();
         return true;
      }
		 
	  public function load():void
	  {
		  if (!_loader)
		  {
			  // FileLoaderAndUploader has injected this
			  _loader = getBeadByType(FileLoader) as FileLoader;
		  }
		  _loader.load();
	  }
	  
	  public function get data():ByteArray
	  {
        return blob as ByteArray; // need to create a model that actually returns a ByteArray
	  }

	  public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Boolean = false):void
	  {
		  _uploader.upload(request.url);
	  }
	  
	  private function modelChangedHandler(event:Event):void
	  {
		  dispatchEvent(new Event(Event.SELECT));
	  }
	  
	  public function save(data:*, defaultFileName:String = null):void
          {

          }

      

   }

            

}
