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
	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 *  The ReadOnly bead class is a specialty bead that can be used to read-only a Jewel control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ReadOnly extends DispatcherBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function ReadOnly()
		{
		}

		COMPILE::JS
		protected var lastElementTabVal:String = null;

		protected var initialized:Boolean = false;

		private var _readonly:Boolean = true;
        /**
		 *  A boolean flag to lock or unlock the host control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable]
        public function get readOnly():Boolean
        {
            return _readonly;
        }
        public function set readOnly(value:Boolean):void
        {
			if(value != _readonly)
			{
				_readonly = value;
				COMPILE::JS
				{
				if(_strand)
				{
					updateHost();
					sendStrandEvent(_strand, new ValueEvent("readOnlyChange", readOnly));
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
			super.strand = value;
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
			
			if(_readonly) {
				setReadOnlyAndTabIndex(pos, true);
				setReadOnlyAndTabIndex(elem);
			} else {
				removeReadOnlyAndTabIndex(pos, true);
				removeReadOnlyAndTabIndex(elem, false, lastElementTabVal);
			}
			}
		}

		COMPILE::JS
		protected function setReadOnlyAndTabIndex(o:HTMLElement, positioner:Boolean = false):void
		{
			o.setAttribute("read-only", "");
			o.style.pointerEvents = 'none';
			//o.style.cursor = 'none';
			if(!positioner)
				o.tabIndex = -1;
		}

		COMPILE::JS
		protected function removeReadOnlyAndTabIndex(o:*, positioner:Boolean = false, lastTabVal:String = null):void
		{
			o.removeAttribute("read-only");
			o.style.pointerEvents = '';
			o.style.cursor = 'auto';
			if(!positioner)
				o.tabIndex = (lastTabVal == null) ? null : lastTabVal;
		}
	}
}
