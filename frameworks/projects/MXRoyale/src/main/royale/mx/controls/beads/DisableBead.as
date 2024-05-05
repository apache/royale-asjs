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
package mx.controls.beads
{

	import org.apache.royale.core.UIBase;

	COMPILE::SWF {
		import flash.display.InteractiveObject;
	}
	
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.sendStrandEvent;

	COMPILE::JS{
		import org.apache.royale.core.HTMLElementWrapper;
	}
	/**
	 *  The DisableBead class is a specialty bead that can be used with
	 *  UIComponent. When disabled is true, the bead prevents interaction with the component.
	 *  The appearance of the component when disabled is also controlled by this bead.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DisableBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DisableBead()
		{
		}


		private var _enabledAlpha:Number = 1.0;
		/**
		 *  The alpha of the element when enabled. Defaults to 1.0;
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get enabledAlpha():Number
		{
			return _enabledAlpha;
		}
		public function set enabledAlpha(value:Number):void
		{
			_enabledAlpha = value;
		}

		private var _disabledAlpha:Number = 0.5;

		/**
		 *  The alpha of the element when disabled. Defaults to 0.5;
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get disabledAlpha():Number
		{
			return _disabledAlpha;
		}
		public function set disabledAlpha(value:Number):void
		{
			_disabledAlpha = value;
		}

		
		private var _disabled:Boolean;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			COMPILE::JS
			{
				_lastTabVal = (_strand as HTMLElementWrapper).element.getAttribute("tabindex");
			}
			updateHost();
			if (_disabled) { //non-default
				throwChangeEvent();
			}
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
				COMPILE::JS
				{
					if(value && _strand)
						_lastTabVal = (_strand as HTMLElementWrapper).element.getAttribute("tabindex");
				}
				_disabled = value;
				updateHost();
				throwChangeEvent();
			}
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

		COMPILE::JS
		private var _nativeControlChildren:Array;

		COMPILE::JS
		private var _nonNativeControlChildren:Array;

		COMPILE::JS
		public function setComposedContent(nativeControlChildren:Array,nonNativeControlChildren:Array):void{
			_nativeControlChildren = nativeControlChildren;
			_nonNativeControlChildren = nonNativeControlChildren;
		}


		
		/**
		 * @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		private function updateHost():void
		{
			if(!_strand)//bail out
				return;

			var disabled:Boolean = this.disabled;
			COMPILE::SWF {
				var interactiveObject:InteractiveObject = _strand as InteractiveObject;
				interactiveObject.mouseEnabled = !disabled;
			}
			
			COMPILE::JS {
				var elem:HTMLElement = (_strand as HTMLElementWrapper).element;
				elem.style["pointerEvents"] = disabled ? "none" : "";
				if(disabled) {
					elem.setAttribute("tabindex", "-1");
					if (_nativeControlChildren) {
						setDisabledNativeControls(_nativeControlChildren, true);
					}
				}
				else {
					_lastTabVal ?
							elem.setAttribute("tabindex", _lastTabVal) :
							elem.removeAttribute("tabindex");
					if (_nativeControlChildren) {
						setDisabledNativeControls(_nativeControlChildren, false);
					}
				}
				if (_nonNativeControlChildren) {
					setAlphaNonNativeContent(_nonNativeControlChildren, disabled ? disabledAlpha : enabledAlpha);
				}
				else host.alpha = disabled ? disabledAlpha : enabledAlpha;
			}
				
		}
		
		private function throwChangeEvent():void
		{
			if (_strand)
			{
				//this is the event that UIComponent is expecting to be dispatched (for any listeners and for binding)
				sendStrandEvent(_strand,new Event("enabledChanged"));
			}
		}


		COMPILE::JS
		private static function setDisabledNativeControls(array:Array, disabled:Boolean):void{
			for each(var element:Element in array) {
				if (disabled) {
					element.setAttribute('disabled','');
				} else {
					element.removeAttribute('disabled');
				}
			}
		}

		COMPILE::JS
		private static function setAlphaNonNativeContent(array:Array, alpha:Number):void{
			for each(var thing:Object in array) {
				if (thing is UIBase) {
					UIBase(thing).alpha = alpha;
				} else {
					thing.style.opacity = alpha;
				}
			}
		}
	}
}
