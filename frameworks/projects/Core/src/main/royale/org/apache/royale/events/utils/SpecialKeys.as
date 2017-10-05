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
	/**
	 *  This class holds constants for special keys
     *  See: https://w3c.github.io/uievents-key/#keys-special
     *  See: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values#Special_values
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
    public class SpecialKeys
    {
        /**
         * The user agent wasn't able to map the event's virtual keycode to a specific key value.
         * This can happen due to hardware or software constraints, or because of constraints
         * around the platform on which the user agent is running.
         */
        public static const UNIDENTIFIED:String = "Unidentified";
    }
}
