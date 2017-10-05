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
package org.apache.royale.storage
{
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 * The IPermanentStorage interface provides the template for creating
	 * an interface to a device's native file system.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IPermanentStorage extends IEventDispatcher
	{	
		/**
		 * A convenience function to read an entire file as a single 
		 * string of text. The file is storaged in the application's
		 * data storage directory. 
		 * 
		 *  @param fileName The name of the file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function readTextFromDataFile( fileName:String ) : void;
		
		/**
		 * A convenience function write a string into a file that resides in the
		 * application's data storage directory. If the file already exists it is 
		 * replaced with the string.
		 * 
		 *  @param fileName The name of file.
		 *  @param text The string to be stored.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function writeTextToDataFile( fileName:String, text:String ) : void;
		
		/**
		 * Opens an output stream into a file in the data storage directory. A Ready
		 * event is dispatched when the stream has been opened. Use the stream to
		 * write data to the file.
		 * 
		 *  @param fileName The name of file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function openOutputDataStream( fileName:String ) : void;
		
		/**
		 * Opens an input stream into a file in the data storage directory. A Ready
		 * event is dispatched when the stream has been opened. Use the stream to
		 * read data from the file.
		 * 
		 *  @param fileName The name of file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function openInputDataStream( fileName:String ) : void;
	}
}
