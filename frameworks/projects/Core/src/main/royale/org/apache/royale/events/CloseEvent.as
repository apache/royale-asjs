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
package org.apache.royale.events
{
	/**
	 * The CloseEvent class represents event objects specific to popup windows, such as the Alert control.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9
     * 
     *  @royalesuppresspublicvarwarning
	 */
    public class CloseEvent extends Event
	{
		public static const CLOSE:String = "close";

		public function CloseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
                                   detail:uint = 0x000004):void
		{
			super(type, bubbles, cancelable);

			this.detail = detail;
		}

        /**
         *  Identifies the button in the popped up control that was clicked. This property is for controls with multiple    		 *	buttons. The Alert control sets this property to one of the following constants:
		 *
         *  Alert.YES
         *  Alert.NO
         *  Alert.OK
         *  Alert.CANCEL
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		public var detail:uint;
    }
}
