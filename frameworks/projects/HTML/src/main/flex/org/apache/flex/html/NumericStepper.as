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
package org.apache.flex.html
{
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.UIBase;
    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;            
    }

	[Event(name="valueChange", type="org.apache.flex.events.Event")]
	
	/**
	 *  The NumericStepper class is a component that displays a numeric
	 *  value and up/down controls (using a org.apache.flex.html.Spinner) to 
	 *  increase and decrease the value by specific amounts. The NumericStepper uses the following beads:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model for the component of type org.apache.flex.core.IRangeModel.
	 *  org.apache.flex.core.IBeadView: constructs the parts of the component.
	 *  org.apache.flex.core.IBeadController: handles the input events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class NumericStepper extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function NumericStepper()
		{
			super();
		}
		
        [Bindable("valueChange")]
		/**
		 *  The current value of the control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get value():Number
		{
			return IRangeModel(model).value;
		}
		public function set value(newValue:Number):void
		{
			IRangeModel(model).value = newValue;
		}
		
		/**
		 *  The minimum value the control will display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get minimum():Number
		{
			return IRangeModel(model).minimum;
		}
		public function set minimum(value:Number):void
		{
			IRangeModel(model).minimum = value;
		}
		
		/**
		 *  The maximum value the control will display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get maximum():Number
		{
			return IRangeModel(model).maximum;
		}
		public function set maximum(value:Number):void
		{
			IRangeModel(model).maximum = value;
		}
		
		/**
		 *  The amount to increase or descrease the value. The value
		 *  will not exceed the minimum or maximum value. The final
		 *  value is affected by the snapInterval.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get stepSize():Number
		{
			return IRangeModel(model).stepSize;
		}
		public function set stepSize(value:Number):void
		{
			IRangeModel(model).stepSize = value;
		}
		
		/**
		 *  The modulus for the value. If this property is set,
		 *  the value displayed with a muliple of the snapInterval.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get snapInterval():Number
		{
			return IRangeModel(model).snapInterval;
		}
		public function set snapInterval(value:Number):void
		{
			IRangeModel(model).snapInterval = value;
		}
        
        COMPILE::JS
        private var input:TextInput;
        
        COMPILE::JS
        private var spinner:Spinner;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            element = document.createElement('div') as WrappedHTMLElement;
            positioner = element;
            positioner.style.position = 'relative';
            
            input = new TextInput();
            addElement(input);
            input.positioner.style.display = 'inline-block';
            input.positioner.style.width = '100px';
            
            spinner = new Spinner();
            spinner.positioner.style.display = 'inline-block';
            spinner.positioner.style.height = '24px';
            spinner.positioner.style.marginLeft = '-1px';
            spinner.positioner.style.marginTop = '-1px';
            addElement(spinner);
            
            /* TODO: ajh move to view and css */
            spinner.incrementButton.positioner.style.display = 'block';
            spinner.incrementButton.positioner.style.marginBottom = '-1px';
            spinner.incrementButton.positioner.style.paddingTop = '1.5px';
            spinner.incrementButton.positioner.style.paddingBottom = '2px';
            spinner.incrementButton.positioner.style.fontSize = '7px';
            spinner.decrementButton.positioner.style.marginTop = '0px';
            spinner.decrementButton.positioner.style.display = 'block';
            spinner.decrementButton.positioner.style.paddingTop = '2px';
            spinner.decrementButton.positioner.style.paddingBottom = '1.5px';
            spinner.decrementButton.positioner.style.fontSize = '7px';
            spinner.positioner.style.display = 'inline-block';
            goog.events.listen(spinner, 'valueChange',
                spinnerChange);
            
            element.flexjs_wrapper = this;
            className = 'NumericStepper';
            
            input.text = String(spinner.value);
            
            return element;
        }        

        /**
         * @param event The input event.
         */
        COMPILE::JS
        private function spinnerChange(event:Event):void
        {
            var newValue:Number = spinner.value;
            value = newValue;
            input.text = String(spinner.value);
            dispatchEvent(new Event('valueChange'));
        };
        
        
	}
}
