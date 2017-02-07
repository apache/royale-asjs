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
package org.apache.flex.html.beads
{
	COMPILE::SWF {
	import flash.display.InteractiveObject;
	}
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIHTMLElementWrapper;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.ValueEvent;

	COMPILE::JS{
		import org.apache.flex.core.WrappedHTMLElement;
	}
	/**
	 *  The DisableBead class is a specialty bead that can be used with
	 *  any TextInput control. The bead places a string into the input field
	 *  when there is no value associated with the text property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DisableBead implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DisableBead()
		{
		}
		
		private var _strand:IStrand;
		private var _disabled:Boolean;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion HTMLInputElement
		 *  @flexjsignorecoercion org.apache.flex.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{	
			_strand = value;
			updateHost();
		}
		
		public function get disabled():Boolean
		{
			return _disabled;
		}
		
		/**
		 *  @private
		 */
		public function set disabled(value:Boolean):void
		{
			if (value != _disabled)
			{
				_disabled = value;
				updateHost();
				throwChangeEvent();
			}
		}

		private function disabledChangeHandler(e:Event):void
		{
			updateHost();
		}
		
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		private function updateHost():void
		{
			COMPILE::SWF {
				var interactiveObject:InteractiveObject = (_strand as UIHTMLElementWrapper).$displayObject as InteractiveObject;
				interactiveObject.mouseEnabled = !disabled;
			}
			
			COMPILE::JS {
				(_strand as Object).element.style.pointerEvents = disabled ? "none" : "auto";
			}
				
		}
		
		private function throwChangeEvent():void
		{
			if (_strand)
			{
				IEventDispatcher(_strand).dispatchEvent(new ValueEvent("disabledChange", disabled));
			}
		}

		
	}
}
