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
package org.apache.flex.file.beads
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;

	/**
	 *  The FileLoaderAndUploader is a compound bead that allows you
	 *  to load a file and upload it in one operation.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.9
	 */
	public class FileLoaderAndUploader extends FileUploader
	{
		private var _loader:FileLoader;
		private var _url:String;
		public function FileLoaderAndUploader()
		{
			super();
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.9
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_loader = value.getBeadByType(FileLoader) as FileLoader;
			if (!_loader)
			{
				_loader = new FileLoader();
				value.addBead(_loader);
			}
		}
		
		/**
		 *  Upload a file to the specified url. If file hasn't been loaded already it will be.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.9
		 */
		
		override public function upload(url:String):void
		{
			var fileModel:FileModel = host.model as FileModel;
			if (!fileModel.blob)
			{
				_url = url;
				host.model.addEventListener("blobChanged", blobChangedHandler);
				_loader.load();
			} else
			{
				super.upload(url);
			}
		}
		
		/**
		 * @private
		 */
		private function blobChangedHandler(e:Event):void
		{
			host.model.removeEventListener('blobChanged', blobChangedHandler);
			super.upload(_url);
		}
		
	}
}