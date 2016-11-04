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
	import org.apache.flex.core.UIBase;
	
	
	/**
	 *  The Badge class provides a MDL UI-like appearance for a badge.
	 *  A Badge is an onscreen notification element consists of a small circle, 
     *  typically containing a number or other characters, that appears in 
     *  proximity to another object
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Badge implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Badge()
		{
		}

		private var _dataBadge:Number = 0;

		/**
		 *  The current value of the Badge that appers inside the circle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataBadge():Number
		{
			return _dataBadge;
		}
		public function set dataBadge(value:Number):void
		{
			_dataBadge = value;
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
				var host:UIBase = value as UIBase;
				
				if (host.element is HTMLSpanElement)
				{
					var span:HTMLSpanElement = host.element as HTMLSpanElement;
					span.className = "mdl-badge " + _noBackground + _overlap;
					span.setAttribute('data-badge', _dataBadge.toString());
				} else if (host.element is HTMLDivElement)
				{
					var div:HTMLDivElement = host.element as HTMLDivElement;
					div.className = "mdl-badge " + _noBackground + _overlap;
					div.setAttribute('data-badge', _dataBadge.toString());
				} else if (host.element is HTMLElement)
				{
					var a:HTMLElement = host.element as HTMLElement;
					a.className = "mdl-badge " + _noBackground + _overlap;
					a.setAttribute('data-badge', _dataBadge.toString());
				} else
				{
					throw new Error("Host component must be an MDL Host for Badges.");
				}
			}
		}
	}
}
