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

package spark.core
{
	// import flash.events.IEventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 *  The IDisplayText interface defines the properties and methods
	 *  for simple text display.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Flex 4.5
	 */
	public interface IDisplayText extends IEventDispatcher
	{       
		/**
		 *  The text displayed by this text component.
		 *
		 *  <p>The formatting of this text is controlled by CSS styles.
		 *  The supported styles depend on the subclass.</p>
		 *
		 *  @default ""
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get text():String;
		function set text(value:String):void;
		
		
		/**
		 *  A flag that indicates whether the text has been truncated.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.1
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		function get isTruncated():Boolean;
	}
}