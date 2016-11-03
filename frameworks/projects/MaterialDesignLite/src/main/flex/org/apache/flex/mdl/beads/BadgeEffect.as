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
package org.apache.flex.mdl.beads
{
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IBead;
	import org.apache.flex.mdl.Badge;
	
	
	/**
	 *  The BadgeEffect class is a specialty bead that can be used with
	 *  a MDL Badge control to apply some MDL complementary effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class BadgeEffect implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function BadgeEffect()
		{
		}

		private var _noBackground:String = "";
        /**
		 *  A boolean flag to activate "mdl-badge--no-background" effect selector.
		 *  Applies open-circle effect to badge
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get noBackground():Boolean
        {
            return _noBackground;
        }
        public function set noBackground(value:Boolean):void
        {
            if(value) {
                _noBackground = " mdl-badge--no-background";
            } else {
                _noBackground = "";
            }   
        }

        private var _overlap:String = "";
        /**
		 *  A boolean flag to activate "mdl-badge--overlap" effect selector.
		 *  Make the badge overlap with its container
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get overlap():Boolean
        {
            return _overlap;
        }
        public function set overlap(value:Boolean):void
        {
            if(value) {
                _overlap = " mdl-badge--overlap";
            } else {
                _overlap = "";
            }   
        }

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion org.apache.flex.mdl.TextInput;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				if (value is Badge) {
					var badge:Badge = value as Badge;
					badge.className = _noBackground + _overlap;
				} else {
					throw new Error("Host component must be an MDL Badge.");
				}
			}
		}
	}
}
