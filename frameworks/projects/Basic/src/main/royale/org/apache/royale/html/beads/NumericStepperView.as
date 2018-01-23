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
    import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.ILayoutChild;
    import org.apache.royale.core.IParent;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.Label;
	import org.apache.royale.html.Spinner;
	import org.apache.royale.html.TextInput;
	import org.apache.royale.html.supportClasses.Border;
	import org.apache.royale.html.supportClasses.ScrollBar;
	
	/**
	 *  The NumericStepperView class creates the visual elements of the 
	 *  org.apache.royale.html.NumericStepper component. A NumberStepper consists of a 
	 *  org.apache.royale.html.TextInput component to display the value and a 
	 *  org.apache.royale.html.Spinner to change the value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class NumericStepperView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function NumericStepperView()
		{
		}
		
		private var label:Label;
		private var input:TextInput;
		private var spinner:Spinner;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
            
			// add an input field
			input = new TextInput();
            input.className = "NumericStepperInput";
            input.typeNames = "NumericStepperInput";
			IParent(value).addElement(input);
			COMPILE::JS
			{
	            input.positioner.style.display = 'inline-block';
    	        input.positioner.style.width = '100px';
			}
			// add a spinner
			spinner = new Spinner();
			spinner.addBead( UIBase(value).model as IBead );
			IParent(value).addElement(spinner);
			spinner.height = input.height;
			spinner.width = input.height/2;
			COMPILE::JS
			{
	            spinner.positioner.style.display = 'inline-block';
			}
			
			// listen for changes to the text input field which will reset the
			// value. ideally, we should either set the input to accept only
			// numeric values or, barring that, reject non-numeric entries. we
			// cannot do that right now however.
			input.addEventListener("change",inputChangeHandler);
			
			// listen for change events on the spinner so the value can be updated as
			// as resizing the component
			spinner.addEventListener("valueChange",spinnerValueChanged);
			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);
            IEventDispatcher(value).addEventListener("sizeChanged",sizeChangeHandler);
			
			// listen for changes to the model itself and update the UI accordingly
			IEventDispatcher(UIBase(value).model).addEventListener("valueChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("minimumChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("maximumChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("stepSizeChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("snapIntervalChange",modelChangeHandler);
			
			input.text = String(spinner.value);
			
			COMPILE::SWF
			{
				var host:ILayoutChild = ILayoutChild(value);
				
				// Complete the setup if the height is sized to content or has been explicitly set
				// and the width is sized to content or has been explicitly set
				if ((host.isHeightSizedToContent() || !isNaN(host.explicitHeight)) &&
					(host.isWidthSizedToContent() || !isNaN(host.explicitWidth)))
					sizeChangeHandler(null);
			}
			COMPILE::JS
			{
				// always run size change since there are no size change events
				sizeChangeHandler(null);
			}
					
		}
		
		/**
		 * @private
		 */
		private function sizeChangeHandler(event:Event) : void
		{
			COMPILE::JS
			{
				spinner.height = input.height;
				spinner.width = input.height/2;
			}
			
			input.x = 0;
			input.y = 0;
			if (!UIBase(_strand).isWidthSizedToContent())
				input.width = UIBase(_strand).width-spinner.width-2;
			
			COMPILE::SWF
			{
				spinner.x = input.width;
				spinner.y = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function spinnerValueChanged(event:ValueChangeEvent) : void
		{
			input.text = String(spinner.value);
			
			var newEvent:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", event.oldValue, event.newValue);
			IEventDispatcher(_strand).dispatchEvent(newEvent);
		}
		
		/**
		 * @private
		 */
		private function inputChangeHandler(event:Event) : void
		{
			var newValue:Number = Number(input.text);

			if( !isNaN(newValue) ) {
				spinner.value = newValue;
			}
			else {
				input.text = String(spinner.value);
			}
		}
		
		/**
		 * @private
		 */
		private function modelChangeHandler( event:Event ) : void
		{
			var n:Number = IRangeModel(UIBase(_strand).model).value;
			input.text = String(IRangeModel(UIBase(_strand).model).value);
		}
		
		/**
		 *  The area containing the TextInput and Spinner controls.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get contentView():IParentIUIBase
		{
			return _strand as IParentIUIBase;
		}
		
		/**
		 * @private
		 */
		public function get resizableView():IUIBase
		{
			return _strand as IUIBase;
		}
	}
}
