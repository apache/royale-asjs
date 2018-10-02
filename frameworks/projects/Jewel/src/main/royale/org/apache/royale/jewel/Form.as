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
package org.apache.royale.jewel
{
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IPopUpHostParent;

    /**
     *  Dispatched when the form validation succeeds.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    [Event("valid","org.apache.royale.events.Event")]

    /**
     *  Dispatched when the form validation fails.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    [Event("invalid","org.apache.royale.events.Event")]

    /**
	 *  The Form class works with all validators,
	 *  which implements IPopUpHost can host error tips.
	 *  strand with FormValidator to dispatch invalid/valid event.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
    public class Form extends Group implements IPopUpHost, IPopUpHostParent {
        
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Form()
		{
			super();
            typeNames = "jewel form";
		}
        /**
         *  Form can host error tips but they will be in the layout, if any
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get popUpParent():IPopUpHostParent
        {
            return this;
        }

        /**
         */
        public function get popUpHost():IPopUpHost
        {
            return this;
        }
    }
}