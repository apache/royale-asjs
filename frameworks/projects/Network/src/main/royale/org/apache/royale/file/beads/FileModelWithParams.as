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
package org.apache.royale.file.beads
{
	/**
	 *  The FileModelWithParams class should allow sending a file with parameters.
	 *  The js implementation uses FormData.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	import org.apache.royale.utils.BinaryData;
	public class FileModelWithParams extends FileModel
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		COMPILE::JS
		{
			private var _blob:FormData;
		}
		private var _fileParamName:String = "blob";
		public function FileModelWithParams()
		{
			super();
			COMPILE::JS 
			{
				_blob = new FormData();
			}
		}

        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		override public function set fileContent(value:BinaryData):void
		{
			COMPILE::JS
			{
				setParam(fileParamName, new Blob([value.data]), name);
				dispatchEvent(new Event("blobChanged"));
			}
			COMPILE::SWF
			{
				super.fileContent = value;
			}
		}
		
        /**
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		COMPILE::JS
		override public function get blob():Object
		{
			return _blob;
		}
		
		public function setParam(name:String, value:Object, fileName:String=null):void
		{
			COMPILE::JS
			{
				if (fileName)
				{
					_blob["set"](name, value, fileName);
				} else
				{
					_blob["set"](name, value);
				}
			}
			COMPILE::SWF
			{
				// TODO
			}
		}

		public function get fileParamName():String 
		{
			return _fileParamName;
		}
		
		public function set fileParamName(value:String):void 
		{
			_fileParamName = value;
		}
	
		override public function get size():Number
		{
			COMPILE::SWF 
			{
				return super.size;
			}
			COMPILE::JS 
			{
				var myBlob:Blob = _blob["get"](fileParamName) as Blob;
				return myBlob ? myBlob.size : -1;
			}
		}
	}
}
