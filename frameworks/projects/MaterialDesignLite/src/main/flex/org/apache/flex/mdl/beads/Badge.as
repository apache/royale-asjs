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
	 *  The Badge class provides a small status descriptors for UI elements.
	 *
	 *  A Badge is an onscreen notification element consists of a small circle, 
     *  typically containing a number or other characters, that appears in 
     *  proximity to another object
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Badge implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		public function get dataBadge():Number
		{
			return _dataBadge;
		}
		public function set dataBadge(value:Number):void
		{
			_dataBadge = value;
		}

		private var _noBackground:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-badge--no-background" effect selector.
		 *  Applies open-circle effect to badge
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get noBackground():Boolean
        {
            return _noBackground;
        }
        public function set noBackground(value:Boolean):void
        {
			_noBackground = value;
			
			COMPILE::JS
            {
				if(host)
				{
                	host.element.classList.toggle("mdl-badge--no-background", _noBackground);
					host.typeNames = host.element.className;
				}
            }   
        }

        private var _overlap:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-badge--overlap" effect selector.
		 *  Make the badge overlap with its container
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get overlap():Boolean
        {
            return _overlap;
        }
        public function set overlap(value:Boolean):void
        {
			_overlap = value;
			
			COMPILE::JS
            {
				if(host) 
				{
                	host.element.classList.toggle("mdl-badge--overlap", _overlap);
					host.typeNames = host.element.className;
				}
            }
        }

		private var host:UIBase;

		private var _strand:IStrand;		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion HTMLDivElement;
		 *  @royaleignorecoercion HTMLSpanElement;
		 *  @royaleignorecoercion HTMLElement;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				host = value as UIBase;
				
				if (host.element is HTMLSpanElement || host.element is HTMLDivElement || host.element is HTMLElement)
				{
					host.element.classList.add("mdl-badge");
					host.element.classList.toggle("mdl-badge--no-background", _noBackground);
					host.element.classList.toggle("mdl-badge--overlap", _overlap);
					host.element.setAttribute('data-badge', _dataBadge.toString());
				}
				else
				{
					throw new Error("Host component must be an MDL Host for Badges.");
				}
			}
		}
	}
}
