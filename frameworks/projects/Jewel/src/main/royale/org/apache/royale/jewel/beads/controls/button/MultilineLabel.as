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
package org.apache.royale.jewel.beads.controls.button
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.jewel.Button;
	
	/**
	 *  The MultilineLabel bead is a specialty bead that can be used with
	 *  any DropDownList control to force a data item always be selected in the control
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class MultilineLabel implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function MultilineLabel()
		{
		}
		
		private var button:Button;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function set strand(value:IStrand):void
		{
			button = value as Button;
			updateHost();
		}	

		private var _multiline:Boolean;
        /**
		 *  A boolean flag to activate "multiline" effect selector.
		 *  Allow the Button to have more than one line label if needed
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get multiline():Boolean
        {
            return _multiline;
        }

        public function set multiline(value:Boolean):void
        {
            if (_multiline != value)
            {
                _multiline = value;
				updateHost();
            }
        }

		protected function updateHost():void
		{
			if (button)
			{
                button.toggleClass("multiline", _multiline);
            }
		}
	}
}
