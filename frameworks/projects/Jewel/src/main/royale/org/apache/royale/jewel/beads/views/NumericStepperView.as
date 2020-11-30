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
package org.apache.royale.jewel.beads.views
{
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.ILayoutChild;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IParentIUIBase;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.jewel.Label;
    import org.apache.royale.jewel.Spinner;
    import org.apache.royale.jewel.TextInput;
	
	/**
	 *  The NumericStepperView class creates the visual elements of the 
	 *  org.apache.royale.jewel.NumericStepper component. A NumberStepper consists of a 
	 *  org.apache.royale.jewel.TextInput component to display the value and a 
	 *  org.apache.royale.jewel.Spinner to change the value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class NumericStepperView extends BeadViewBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function NumericStepperView()
		{
		}
		
		private var label:Label;
		public var input:TextInput;
		public var spinner:Spinner;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
            (value as IParent).addElement(input);
			
			// add a spinner
			spinner = new Spinner();
			spinner.addBead((value as UIBase).model as IBead);
			(value as IParent).addElement(spinner);

			// now we parent the spinner buttons to the numeric stepper
			// we'll be using flex box column layout with wrapping to get the buttons to the right side
			// on phones and tablets, we want to reorder elements (again flexbox) and position :
			// button down + text input + button up
			var spinnerview:SpinnerView = spinner.getBeadByType(SpinnerView) as SpinnerView;
			(value as IParent).addElement(spinnerview.increment as IChild);
			(value as IParent).addElement(spinnerview.decrement as IChild);
			
			input.text = String(spinner.value);

			initSize();

			// delay this until the resize event in JS
			COMPILE::SWF
			{
				spinner.height = input.height;
				spinner.width = input.height/2;

			// 	var host:ILayoutChild = ILayoutChild(value);
				
			// 	// Complete the setup if the height is sized to content or has been explicitly set
			// 	// and the width is sized to content or has been explicitly set
			// 	if ((host.isHeightSizedToContent() || !isNaN(host.explicitHeight)) &&
			// 		(host.isWidthSizedToContent() || !isNaN(host.explicitWidth)))
			// 		sizeChangeHandler(null);
			// always run size change since there are no size change events
			// sizeChangeHandler(null);
			}
		}

		public static const DEFAULT_BUTTON_WIDTH:Number = 38;
		public static const DEFAULT_WIDTH:Number = 142;

		/**
		 * Size the component at start up
		 *
		 * @private
		 */
		protected function initSize():void
		{
			spinner.width = DEFAULT_BUTTON_WIDTH;

			var df:ILayoutChild = host as ILayoutChild;

			// if no width (neither px or %), set default width
			if(df.isWidthSizedToContent())
				df.width = DEFAULT_WIDTH;
			
			// input.percentWidth = 100;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		// COMPILE::SWF
		// private function sizeChangeHandler(event:Event) : void
		// {
		// 	// first reads
		// 	var ns:ILayoutChild = host as ILayoutChild;
		// 	var widthToContent:Boolean = ns.isWidthSizedToContent();
		// 	var inputWidth:Number = input.width;
		// 	var inputHeight:Number = input.height;
		// 	var strandWidth:Number;
		// 	if (!widthToContent)
		// 	{
		// 		strandWidth = ns.width;
		// 	}
			
		// 	// input.x = 0;
		// 	// input.y = 0;
		// 	if (!widthToContent)
		// 		input.width = strandWidth - spinner.width - 2;
			
		// 	COMPILE::SWF
		// 	{
		// 		spinner.x = inputWidth;
		// 		spinner.y = 0;
		// 	}
		// }
		
		/**
		 *  The area containing the TextInput and Spinner controls.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
