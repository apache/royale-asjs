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
package org.apache.royale.jewel.beads.controls
{
	COMPILE::JS
	{
	import org.apache.royale.core.HTMLElementWrapper;
	import org.apache.royale.core.IUIBase;
	}
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 *  The Disabled bead class is a specialty bead that can be used to disable a Jewel control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Disabled extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Disabled()
		{
		}

		COMPILE::JS
		protected var lastTabVal:String;

		private var _disabled:Boolean = true;
        /**
		 *  A boolean flag to enable or disable the host control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable]
        public function get disabled():Boolean
        {
            return _disabled;
        }
        public function set disabled(value:Boolean):void
        {
			if(value != _disabled)
			{
				COMPILE::JS
				{
				if(value && _strand)
					lastTabVal = (_strand as HTMLElementWrapper).element.getAttribute("tabindex");
				}
				_disabled = value;
				if(_strand)
				{
					updateHost();
					sendStrandEvent(_strand, new ValueEvent("disabledChange", disabled));
				}	
			}
        }

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS
            {
            lastTabVal = (_strand as HTMLElementWrapper).element.getAttribute("tabindex");
            }
			updateHost();
		}

		protected function updateHost():void
		{
			COMPILE::JS
			{
			var elem:HTMLElement = (_strand as HTMLElementWrapper).element;
			var pos:HTMLElement = (_strand as IUIBase).positioner;
			
			if(_disabled) {
				setDisableAndTabIndex(elem);
				setDisableAndTabIndex(pos);
			} else {
				removeDisableAndTabIndex(elem);
				removeDisableAndTabIndex(pos);
			}
			}
		}

		COMPILE::JS
		protected function setDisableAndTabIndex(o:HTMLElement):void
		{
			o.setAttribute("disabled", "");
			o.tabIndex = -1;
		}

		COMPILE::JS
		protected function removeDisableAndTabIndex(o:*):void
		{
			o.removeAttribute("disabled");
				
			lastTabVal ?
				o.tabIndex = lastTabVal :
				o.tabIndex = null;
		}
	}
}
