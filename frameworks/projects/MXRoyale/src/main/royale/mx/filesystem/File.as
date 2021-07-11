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


package mx.filesystem
{
	import mx.net.FileReference;
         
    public class File extends FileReference
    {
		   public function File(path:String = null) 
		   {
				super();
		   }
		   
		 
		//----------------------------------
		//  modificationDate
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the <code>modificationDate</code> property.
		 */
		private var _modificationDate:Date = null;

		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get modificationDate():Date
		{
			trace("modificationDate in File is not implemented");
			return _modificationDate;
		}
		
		//----------------------------------
		//  exists
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the <code>exists</code> property.
		 */
		private var _exists:Boolean = false;

		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get exists():Boolean
		{
			trace("exists in File is not implemented");
			return _exists;
		}
		
		//----------------------------------
		//  getRootDirectories
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the <code>getRootDirectories</code> property.
		 */
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getRootDirectories():Array {
			trace("getRootDirectories in File is not implemented");
			return [];
		}
		
		//----------------------------------
		//  resolvePath
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the <code>resolvePath</code> property.
		 */
		 
		 private var _resolvePath:String = "";
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function resolvePath(path:String):File {
			trace("resolvePath in File is not implemented");
			path = _resolvePath;
			return path as File;
		}
		
		
		//----------------------------------
		//  getDirectoryListing
		//----------------------------------
		
		public function getDirectoryListing():Array {
			trace("getDirectoryListing in File is not implemented");
			return [];
		}
		
		
		//----------------------------------
		//  url
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the <code>resolvePath</code> property.
		 */
		 
		private var _url:String = "";
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get url():String {
			trace("get url in File is not implemented");
			return _url;
		}
		public function set url(value:String):void {
			trace("set url in File is not implemented");
			_url = value;
		}
		
		
		//----------------------------------
		//  lineEnding
		//----------------------------------
		
		public static function get lineEnding():String {
			trace("get lineEnding in File is not implemented");
			return "0x0D";
		}
		
		
		//----------------------------------
		//  applicationStorageDirectory
		//----------------------------------
		
		public static function get applicationStorageDirectory():File {
			trace("applicationStorageDirectory in File is not implemented");
			return null;
		}
		
		
		//----------------------------------
		//  deleteDirectory
		//----------------------------------
		
		public function deleteDirectory(deleteDirectoryContents:Boolean = false):void {
			trace("deleteDirectory in File is not implemented");
		}

	}
	
}
