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
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Point;
	import org.apache.royale.jewel.ErrorTip;
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
	public class Validator implements IBead
	{
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
		
		private var _errorTip:ErrorTip;
		private var _host:IPopUpHost;
		private var _xPos:int = LEFT;
		private var _yPos:int = TOP;

		protected var hostComponent:UIBase;

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
			COMPILE::JS
			{
				hostComponent = value as UIBase;
				hostClassList = hostComponent.positioner.classList;
			}
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

		private var _requiredFieldError:String = "This field is required.";
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
				_errorTip = new ErrorTip();

				_host = UIUtils.findPopUpHost(hostComponent);
				_host.popUpParent.addElement(_errorTip, false);
			}

            _errorTip.text = errorText;

			var pt:Point = determinePosition();
			_errorTip.x = pt.x;
			_errorTip.y = pt.y;

			COMPILE::JS
			{
				if (!hostClassList.contains("errorBorder")) 
					hostClassList.add("errorBorder");
			}
		}
		

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
			var hp:Point = PointUtils.localToGlobal(new Point(0,0), _host);
			var pt:Point;

			if (_xPos == LEFT) {
				xFactor = Number.POSITIVE_INFINITY;
			}
			else if (_xPos == MIDDLE) {
				xFactor = 2;
			}
			else if (_xPos == RIGHT) {
				xFactor = 1;
			}
			if (_yPos == TOP) {
				yFactor = Number.POSITIVE_INFINITY;
			}
			else if (_yPos == MIDDLE) {
				yFactor = 2;
			}
			else if (_yPos == BOTTOM) {
				yFactor = 1;
			}

			pt = new Point(hostComponent.width/xFactor - hp.x, hostComponent.height/yFactor - hp.y);
			pt = PointUtils.localToGlobal(pt, hostComponent);

			return pt;
		}

        /**
         *  Destroy the created errorTip
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         */
        protected function destroyErrorTip():void
        {
            if (_errorTip) {
                _host.popUpParent.removeElement(_errorTip);

				_errorTip = null;
				
				COMPILE::JS
				{
					if (hostClassList.contains("errorBorder"))
						hostClassList.remove("errorBorder");
				}
			}
        }
	}
}
