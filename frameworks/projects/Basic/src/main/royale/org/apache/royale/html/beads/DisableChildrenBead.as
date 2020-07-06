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
package org.apache.royale.html.beads
{
	COMPILE::SWF {
	import flash.display.DisplayObjectContainer;
	}
	
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIHTMLElementWrapper;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.utils.sendStrandEvent;

	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.core.HTMLElementWrapper;
	}
	/**
	 *  The DisableChildrenBead class is a specialty bead that can be used with
	 *  any UIBase. When disabled is true, the bead prevents interaction with the component and its children.
	 *  The appearance of the component when disabled is controlled by a separate bead.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DisableChildrenBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DisableChildrenBead()
		{
		}
		
		private var _disabled:Boolean;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			listenOnStrand("childrenAdded",childrenAddedHandler);
		}
		
		public function get disabled():Boolean
		{
			return _disabled;
		}
		
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
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

		private function childrenAddedHandler(e:Event):void
		{
			updateHost();
		}
		/**
		 * 	@royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		
		COMPILE::JS
		private var _lastTabVal:String;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		private function updateHost():void
		{
			if(!_strand)//bail out
				return;
			COMPILE::SWF {
				var interactiveObject:DisplayObjectContainer = _strand as DisplayObjectContainer;
				interactiveObject.mouseChildren = !disabled;
			}
			
			COMPILE::JS {
				setDecendants((_strand as HTMLElementWrapper).element);
			}
				
		}
		/**
		 * 	@royaleignorecoercion HTMLElement
		 */
		COMPILE::JS
		private function setDecendants(elem:HTMLElement):void
		{
			elem.style["pointerEvents"] = _disabled ? "none" : "";
			_disabled ? elem.setAttribute("tabindex", "-1") : elem.removeAttribute("tabindex");
			elem = elem.firstElementChild as HTMLElement;
			while (elem) {
				setDecendants(elem);
				elem = elem.nextElementSibling as HTMLElement;
			}
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function throwChangeEvent():void
		{
			if (_strand)
			{
				sendStrandEvent(_strand,new ValueEvent("disabledChange", disabled));
			}
		}

		
	}
}
