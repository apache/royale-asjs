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
package org.apache.royale.events.utils
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;

	/**
	 *  This class maps common event functions for MouseEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class MouseUtils
	{
		public function MouseUtils()
		{
		}
		
		/**
		 *  Returns the event target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		static public function eventTarget(event:MouseEvent):Object
		{
			return event.target;
		}
		
		/**
		 *  Returns the localX value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		static public function localX(event:MouseEvent):Number
		{
			return event.localX;
		}
		
		/**
		 *  Returns the localY value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		static public function localY(event:MouseEvent):Number
		{
			return event.localY;
		}
		
		/**
		 *  Returns the globel X value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		static public function globalX(event:MouseEvent):Number
		{
			return event.screenX;
		}
		
		/**
		 *  Returns the global Y value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		static public function globalY(event:MouseEvent):Number
		{
			return event.screenY;
		}
	}
}
