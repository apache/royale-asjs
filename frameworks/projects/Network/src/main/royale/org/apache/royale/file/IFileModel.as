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
package org.apache.royale.file
{
	import org.apache.royale.utils.BinaryData;
	COMPILE::SWF
	{
		import flash.net.FileReference;
	}

	public interface IFileModel
	{
		/**
		 *  The type of the file
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function get type():String;
		
		/**
		 *  The size of the file
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function get size():Number;

		/**
		 *  The last modified time of the file, in millisecond since the UNIX epoch (January 1st, 1970 at Midnight).
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function get lastModified():uint;

		/**
		 *  The name of the file
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		function get name():String;

		/**
		 *  A representation of the file model in binary format
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		function get blob():Object;

		/**
		 *  The file content
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		function set fileContent(value:BinaryData):void;

		/**
		 *  The file reference containing meta data on the file
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		COMPILE::SWF
		function set fileReference(value:FileReference):void;

		COMPILE::JS
		function set fileReference(value:File):void;
		
		COMPILE::SWF
		function get fileReference():FileReference;

		COMPILE::JS
		function get fileReference():File;
	}
}
