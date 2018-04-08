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
package org.apache.royale.storage.events
{
	import org.apache.royale.events.Event;
	import org.apache.royale.storage.file.IDataStream;
	
	/**
	 * The FileEvent class is used to signal varies events in the life and
	 * use of permanent files. 
	 * 
	 * READY    - The file has been created or opened successfully.
	 * READ     - Some (or all) of the data has been read.
	 * WRITE    - Some (or all) of the data has been written.
	 * COMPLETE - The read or write process has finished and the file is closed.
	 * ERROR    - An error occurred reading or opening the file.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class FileEvent extends Event
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function FileEvent(type:String)
		{
			super(type);
		}
		
		/**
		 * The data read from the file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public var data:String;
		
		/**
		 * Contains the IDataOutput or IDataInput stream to use for streaming.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public var stream:IDataStream;
		
		/**
		 * If not null, the error that occurred opening or reading the file.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public var errorMessage:String;
	}
}
