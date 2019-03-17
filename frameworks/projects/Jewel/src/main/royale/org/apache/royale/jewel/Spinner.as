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
package org.apache.royale.jewel
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.StyledUIBase;

	[Event(name="valueChange", type="org.apache.royale.events.Event")]

	/**
	 *  The Spinner class is a component that displays a control for incrementing a value
	 *  and a control for decrementing a value. The org.apache.royale.jewel.NumericStepper
	 *  uses a Spinner as part of the component. Spinner uses the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: an IRangeModel to hold the properties.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the Spinner.
	 *  org.apache.royale.core.IBeadController: a bead that handles the input events.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Spinner extends StyledUIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Spinner()
		{
			super();
			typeNames = "jewel spinner";
		}

		/**
		 *  The current value of the Spinner.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function get value():Number
		{
			return IRangeModel(model).value;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function set value(newValue:Number):void
		{
			IRangeModel(model).value = newValue;
		}

		/**
		 *  The minimum value of the Spinner.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function get minimum():Number
		{
			return IRangeModel(model).minimum;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function set minimum(value:Number):void
		{
			IRangeModel(model).minimum = value;
		}

		/**
		 *  The maximum value of the Spinner.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function get maximum():Number
		{
			return IRangeModel(model).maximum;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function set maximum(value:Number):void
		{
			IRangeModel(model).maximum = value;
		}

		/**
		 *  The modulus for the value. If this property is set,
		 *  the value displayed with a muliple of the snapInterval.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function get snapInterval():Number
		{
			return IRangeModel(model).snapInterval;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function set snapInterval(value:Number):void
		{
			IRangeModel(model).snapInterval = value;
		}

		/**
		 *  The amount to increase or descrease the value. The value
		 *  will not exceed the minimum or maximum value. The final
		 *  value is affected by the snapInterval.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function get stepSize():Number
		{
			return IRangeModel(model).stepSize;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function set stepSize(value:Number):void
		{
			IRangeModel(model).stepSize = value;
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');
            return element;
        }
	}
}
