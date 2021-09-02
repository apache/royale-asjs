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
package org.apache.royale.jewel.beads.validators
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ILocalizedValuesImpl;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Strand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Point;
	import org.apache.royale.jewel.supportClasses.tooltip.ErrorTipLabel;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;

	/**
	 *  The Validator class is the base class for all validators.
	 *  This class implements the ability for create/destroy error tips,
	 *  user should set custom validateFunction or use sub class for validation.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Validator extends Strand implements IBead
	{
		/**
		 * locale
		 * @royalesuppresspublicvarwarning
		 */
		public static var locale :String = "en_US";

		[Embed("locale/en_US/validator.properties", mimeType="text/plain")]
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var en_USvalidator:String;
		[Embed("locale/de_DE/validator.properties", mimeType="text/plain")]
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var de_DEvalidator:String;
		[Embed("locale/es_ES/validator.properties", mimeType="text/plain")]
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var es_ESvalidator:String;

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Validator()
		{
		}

		public static const TOP:int = 10000;
		public static const BOTTOM:int = 10001;
		public static const LEFT:int = 10002;
		public static const RIGHT:int = 10003;
		public static const MIDDLE:int = 10004;

		private var _errorTip:ErrorTipLabel;
		private var _host:IPopUpHost;

		private var _xPos:int = RIGHT;
		private var _yPos:int = MIDDLE;
		private var xoffset:int = 14;
		private var yoffset:int = 0;

		protected var hostComponent:UIBase;

		private var _trigger:IEventDispatcher;
		/**
		 * Specifies the component generating the event that triggers the validator.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get trigger():IEventDispatcher
		{
			return _trigger;
		}

		public function set trigger(value:IEventDispatcher):void
		{
			if (triggerEvent)
			{
				if (trigger)
				{
					trigger.removeEventListener(triggerEvent, validate);
				}

				if (value)
				{
					value.addEventListener(triggerEvent, validate);
				}
			}
			_trigger = value;
		}

		private var _triggerEvent:String = Event.CHANGE;
		/**
		 * Specifies the event that triggers the validation.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable(event="triggerEventChanged")]
		public function get triggerEvent():String
		{
			return _triggerEvent;
		}

		public function set triggerEvent(value:String):void
		{
			if (triggerEvent != value)
			{
				if(trigger)
				{
					if(triggerEvent)
					{
						trigger.removeEventListener(triggerEvent, validate);
					}

					if(value)
					{
						trigger.addEventListener(value, validate);
					}
				}

				_triggerEvent = value;
				if(hostComponent != null)
				{
					hostComponent.dispatchEvent(new Event("triggerEventChanged"));
				}
			}
		}

		COMPILE::JS
		protected var hostClassList:DOMTokenList;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			hostComponent = value as UIBase;
			trigger = hostComponent;
			COMPILE::JS
			{
				hostClassList = hostComponent.positioner.classList;
			}
		}

		/**
		 * @private
		 */
		private var _resourceManager:ILocalizedValuesImpl;
		/**
		 *  The Validator's resource manager to get translations from bundles	
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion org.apache.royale.core.ILocalizedValuesImpl
		 */
		public function get resourceManager():ILocalizedValuesImpl
		{
			if (_resourceManager == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(this, "iLocalizedValuesImpl");
				if (c) {
					_resourceManager = new c() as ILocalizedValuesImpl;
					_resourceManager.localeChain = locale;
					addBead(_resourceManager);
				}
			}
			return _resourceManager;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ILocalizedValuesImpl
		 */
		public function set resourceManager(value:ILocalizedValuesImpl):void
		{
			_resourceManager = value;
		}

		/**
		 *  Contains true if the field generated a validation failure.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get isError():Boolean {
			return (_errorTip != null);
		}

		/**
		 *  A function that determines the logic in this validator
		 *  the method signature has the following form:
		 *  validateFunction(item:Object):String
		 *  Where item is the hostComponent object
		 *  and return the error text, if valid return null
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		private var _validateFunction:Function;

		public function get validateFunction():Function{
			return _validateFunction;
		}
		/**
		 *  set your custom validation logic
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set validateFunction(func:Function):void{
			_validateFunction = func;
		}

		private var _required:int;

		public function get required():int {
			return _required;
		}

		/**
		 *  specifies that at least required quantity causes a validation error.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set required(value:int):void {
			_required = value;
		}

		private var _requiredFieldError:String;
		/**
		 *  The string to use as the errorTip.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get requiredFieldError():String
		{
			if(_requiredFieldError == null) {
				_requiredFieldError = resourceManager.getValue("validator", "requiredFieldError");
			}
			return _requiredFieldError;
		}
		public function set requiredFieldError(value:String):void
		{
            _requiredFieldError = value;
		}

		/**
		 *  Performs validation and return the result.
		 *  When result is false(invalid), errorTip appears on the control.
		 *  And true(valid), the errorTip will disappear.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function validate(event:Event = null):Boolean {
			if (validateFunction) {
				var errorText:String = validateFunction(hostComponent);

				if (errorText) {
					createErrorTip(errorText);
				} else {
					destroyErrorTip();
				}

				return !isError;
			}
			return true;
		}

		/**
		 *  Sets the errortip y relative position to one of
		 *  LEFT, MIDDLE or RIGHT.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set xPos(pos:int):void
		{
			_xPos = pos;
		}

		/**
		 *  Sets the errortip y relative position to one of
		 *  TOP, MIDDLE or BOTTOM.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set yPos(pos:int):void
		{
			_yPos = pos;
		}


		/**
		 *  Create an errorTip that floats a error text over a control
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		protected function createErrorTip(errorText:String):void
		{
			if (!errorText)
				return;

			if (_errorTip == null) {
				_errorTip = new ErrorTipLabel();

				_host = UIUtils.findPopUpHost(hostComponent);
				_host.popUpParent.addElement(_errorTip, false);
				IEventDispatcher(_host.popUpParent).addEventListener("cleanValidationErrors", cleanValidationErrorsHandler);
			}
			COMPILE::JS
			{
				hostComponent.element.addEventListener("blur",removeTip);
			}

            _errorTip.text = errorText;

			COMPILE::JS
			{
				window.addEventListener('resize', repositionHandler, false);
				window.addEventListener('scroll', repositionHandler, true);
				repositionHandler();

				createErrorBorder();
			}
		}

		COMPILE::JS
		protected function createErrorBorder():void
		{
			if (!hostClassList.contains("errorBorder"))
			{
				hostClassList.add("errorBorder");
			}
		}

		protected function repositionHandler(event:Event = null):void
		{
            var pt:Point = determinePosition();
            _errorTip.x = pt.x;
            _errorTip.y = pt.y;
		}

		private function removeTip(ev:Event):void
		{
			COMPILE::JS
			{
			window.removeEventListener('resize', repositionHandler, false);
			window.removeEventListener('scroll', repositionHandler, true);
			}
			if(_errorTip){
				IEventDispatcher(_errorTip.parent).removeEventListener("cleanValidationErrors", cleanValidationErrorsHandler);
				_errorTip.parent.removeElement(_errorTip);
				_errorTip = null;
			}
			COMPILE::JS
			{
				hostComponent.element.removeEventListener("blur",removeTip);
			}
		}

		/**
		 * errorTip css class that position the arrow
		 */
		private var arrowclass:String = "";

		/**
		 *  Determines the position of the errorTip.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		protected function determinePosition():Point
		{
			var xFactor:Number = 1;
			var yFactor:Number = 1;
			var ex:Number = 0;
			var ey:Number = 0;
			var hp:Point = PointUtils.localToGlobal(new Point(0,0), _host);
			var pt:Point;

			var arrowclass:String = "";
			// remove a previous arrow position
			//_errorTip.removeClass(arrowclass);

			if (_xPos == LEFT) {
				xFactor = Number.POSITIVE_INFINITY;
				arrowclass = "left-";
			}
			else if (_xPos == MIDDLE) {
				xFactor = 2;
				arrowclass = "middle-";
				ex = - _errorTip.width / xFactor;
			}
			else if (_xPos == RIGHT) {
				xFactor = 1;
				arrowclass = "right-";
			}
			if (_yPos == TOP) {
				yFactor = Number.POSITIVE_INFINITY;
				arrowclass += "top";
			}
			else if (_yPos == MIDDLE) {
				yFactor = 2;
				ey = _errorTip.height / yFactor;
				arrowclass += "middle";
			}
			else if (_yPos == BOTTOM) {
				yFactor = 1;
				arrowclass += "bottom";
			}

			_errorTip.addClass(arrowclass);

			pt = new Point(hostComponent.width/xFactor + ex - hp.x + xoffset, hostComponent.height/yFactor + ey - hp.y + yoffset);
			pt = PointUtils.localToGlobal(pt, hostComponent);

			return pt;
		}

		protected function cleanValidationErrorsHandler(event:Event):void
		{
			destroyErrorTip();
		}

        /**
         *  Destroy the created errorTip
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         */
        internal function destroyErrorTip():void
        {
			COMPILE::JS
			{
				window.removeEventListener('resize', repositionHandler, false);
				window.removeEventListener('scroll', repositionHandler, true);
			}
            if (_errorTip) {
				IEventDispatcher(_host.popUpParent).removeEventListener("cleanValidationErrors", destroyErrorTip);
                _host.popUpParent.removeElement(_errorTip);
				_errorTip = null;
			}

			COMPILE::JS
			{
				destroyErrorBorder();
			}
        }

		COMPILE::JS
		protected function destroyErrorBorder():void
		{
			if (hostClassList && hostClassList.contains("errorBorder"))
			{
				hostClassList.remove("errorBorder");
			}
		}
	}
}
