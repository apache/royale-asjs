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
	 * The FileErrorEvent class is used to signal varies errors that may occur
	 * while handling a permanent file. 
	 * 
	 * ERROR    - A genric error occurred reading or opening the file.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class FileErrorEvent extends Event
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function FileErrorEvent(type:String)
		{
			super(type);
		}
		
		/**
		 * Contains the IDataOutput or IDataInput stream on which the error occurred.
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
		
		/**
		 * An error code, if any, associated with the error that triggered this event.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public var errorCode:Number;
	}
}
