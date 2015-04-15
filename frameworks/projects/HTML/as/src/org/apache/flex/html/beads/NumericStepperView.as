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
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.ILayoutParent;
    import org.apache.flex.core.IParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.html.Label;
	import org.apache.flex.html.Spinner;
	import org.apache.flex.html.TextInput;
	import org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.ScrollBar;
	
	/**
	 *  The NumericStepperView class creates the visual elements of the 
	 *  org.apache.flex.html.NumericStepper component. A NumberStepper consists of a 
	 *  org.apache.flex.html.TextInput component to display the value and a 
	 *  org.apache.flex.html.Spinner to change the value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class NumericStepperView extends BeadViewBase implements IBeadView, ILayoutParent
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function NumericStepperView()
		{
		}
		
		private var label:Label;
		private var input:TextInput;
		private var spinner:Spinner;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// add a horizontal layout bead
			value.addBead(new NonVirtualHorizontalLayout());
            
			// add an input field
			input = new TextInput();
			IParent(value).addElement(input);
			
			// add a spinner
			spinner = new Spinner();
			spinner.addBead( UIBase(value).model );
			IParent(value).addElement(spinner);
			spinner.width = 17;
			spinner.height = input.height;
			
			// listen for changes to the text input field which will reset the
			// value. ideally, we should either set the input to accept only
			// numeric values or, barring that, reject non-numeric entries. we
			// cannot do that right now however.
			input.model.addEventListener("textChange",inputChangeHandler);
			
			// listen for change events on the spinner so the value can be updated as
			// as resizing the component
			spinner.addEventListener("valueChange",spinnerValueChanged);
			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);
			
			// listen for changes to the model itself and update the UI accordingly
			IEventDispatcher(UIBase(value).model).addEventListener("valueChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("minimumChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("maximumChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("stepSizeChange",modelChangeHandler);
			IEventDispatcher(UIBase(value).model).addEventListener("snapIntervalChange",modelChangeHandler);
			
			input.text = String(spinner.value);
			
			// set a default size which will trigger the sizeChangeHandler
			var minWidth:Number = Math.max(50+spinner.width,UIBase(value).width);
			
			UIBase(value).width = minWidth;
			UIBase(value).height = spinner.height;
		}
		
		/**
		 * @private
		 */
		private function sizeChangeHandler(event:Event) : void
		{
			input.x = 2;
			input.y = (UIBase(_strand).height - input.height)/2;
			input.width = UIBase(_strand).width-spinner.width-2;
			spinner.x = input.width+2;
			spinner.y = 0;
		}
		
		/**
		 * @private
		 */
		private function spinnerValueChanged(event:Event) : void
		{
			input.text = String(spinner.value);
			
			var newEvent:Event = new Event(event.type,event.bubbles);
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
		 *  @productversion FlexJS 0.0
		 */
		public function get contentView():IParentIUIBase
		{
			return _strand as IParentIUIBase;
		}
		
		/**
		 *  @private
		 */
		public function get border():Border
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function get vScrollBar():ScrollBar
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function get hScrollBar():ScrollBar
		{
			return null;
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
