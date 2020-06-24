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
		protected var lastElementTabVal:String = null;

		protected var initialized:Boolean = false;

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
				_disabled = value;
				COMPILE::JS
				{
				if(_strand)
				{
					updateHost();
					sendStrandEvent(_strand, new ValueEvent("disabledChange", disabled));
				}
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
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			updateHost();
		}

		protected function updateHost():void
		{
			COMPILE::JS
			{
			var elem:HTMLElement = (_strand as HTMLElementWrapper).element;
			var pos:HTMLElement = (_strand as IUIBase).positioner;
			
			if(!initialized){
				initialized = true;
            	lastElementTabVal = elem.getAttribute("tabindex");
			}
			
			if(_disabled) {
				setDisableAndTabIndex(pos, true);
				setDisableAndTabIndex(elem);
			} else {
				removeDisableAndTabIndex(pos, true);
				removeDisableAndTabIndex(elem, false, lastElementTabVal);
			}
			}
		}

		COMPILE::JS
		protected function setDisableAndTabIndex(o:HTMLElement, positioner:Boolean = false):void
		{
			o.setAttribute("disabled", "");
			if(!positioner)
				o.tabIndex = -1;
		}

		COMPILE::JS
		protected function removeDisableAndTabIndex(o:*, positioner:Boolean = false, lastTabVal:String = null):void
		{
			o.removeAttribute("disabled");
			if(!positioner)
				o.tabIndex = (lastTabVal == null) ? null : lastTabVal;
		}
	}
}
