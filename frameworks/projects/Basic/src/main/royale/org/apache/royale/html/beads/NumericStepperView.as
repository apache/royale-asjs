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
	import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 *  The NumericStepperView class creates the visual elements of the 
	 *  org.apache.royale.html.NumericStepper component. A NumberStepper consists of a 
	 *  org.apache.royale.html.TextInput component to display the value and a 
	 *  org.apache.royale.html.Spinner to change the value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class NumericStepperView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function NumericStepperView()
		{
		}
		
		protected var label:Label;
		protected var input:TextInput;
		protected var spinner:Spinner;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IBead
		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// add an input field
			input = new TextInput();
			input.className = "NumericStepperInput";
			input.typeNames = "NumericStepperInput";
			(value as IParent).addElement(input);
			COMPILE::JS
			{
				input.positioner.style.display = 'inline-block';
				input.positioner.style.width = '100px';
			}
			// add a spinner
			spinner = new Spinner();
			spinner.addBead( (value as UIBase).model as IBead );
			(value as IParent).addElement(spinner);
			// delay this until the resize event in JS
			COMPILE::SWF
			{
				spinner.height = input.height;
				spinner.width = input.height/2;
			}
			COMPILE::JS
			{
				spinner.positioner.style.display = 'inline-block';
				spinner.positioner.style.position = '';
			}
			
			// listen for changes to the text input field which will reset the
			// value. ideally, we should either set the input to accept only
			// numeric values or, barring that, reject non-numeric entries. we
			// cannot do that right now however.
			input.addEventListener("change",inputChangeHandler);
			
			// listen for change events on the spinner so the value can be updated as
			// as resizing the component
			spinner.addEventListener("valueChange",spinnerValueChanged);
			listenOnStrand("widthChanged",sizeChangeHandler);
			listenOnStrand("heightChanged",sizeChangeHandler);
			listenOnStrand("sizeChanged",sizeChangeHandler);
			
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
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function sizeChangeHandler(event:Event) : void
		{
			// first reads
			var widthToContent:Boolean = (event == null) && (_strand as UIBase).isWidthSizedToContent();
			var inputWidth:Number = input.width;
			var inputHeight:Number = input.height;
			var strandWidth:Number;
			if (!widthToContent)
			{
				strandWidth = (_strand as UIBase).width;
			}
			COMPILE::JS
			{
				spinner.height = inputHeight;
				spinner.width = inputHeight/2;
			}
			
			input.x = 0;
			input.y = 0;
			if (!widthToContent)
				input.width = strandWidth - spinner.width - 2;
			
			COMPILE::SWF
			{
				spinner.x = inputWidth;
				spinner.y = 0;
			}
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function spinnerValueChanged(event:ValueChangeEvent) : void
		{
			input.text = "" + spinner.value;
			
			var newEvent:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", event.oldValue, event.newValue);
			sendStrandEvent(_strand,newEvent);
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
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
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
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 */
		public function get contentView():IParentIUIBase
		{
			return _strand as IParentIUIBase;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function get resizableView():IUIBase
		{
			return _strand as IUIBase;
		}
	}
}
