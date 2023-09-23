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
    import mx.core.UIComponent;
    
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.html.beads.NumericStepperView;
    import org.apache.royale.events.Event;
    import mx.events.FocusEvent;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DispatchInputFinishedBead;
    import org.apache.royale.html.accessories.RestrictTextInputBead;
	
    /**
     *  The NumericStepperView class overrides the Basic
     *  NumericStepperView and sets default sizes to better 
     *  emulate Flex.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royaleignorecoercion mx.core.UIComponent
     */
	public class NumericStepperView extends org.apache.royale.html.beads.NumericStepperView
	{
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            COMPILE::SWF
            {
                input.width = 41;
            }
            COMPILE::JS
            {
                input.width = 44; // should be same as SWF after we adjust defaults for spinner
                (value as UIComponent).measuredWidth = 60;
            }
            input.addBead(new DispatchInputFinishedBead());
            var restrictBead:RestrictTextInputBead = new RestrictTextInputBead();
            restrictBead.restrict = "0-9\\-\\.\\,";
            input.addBead(restrictBead);
            input.addEventListener(DispatchInputFinishedBead.INPUT_FINISHED, syncTextAndSpinner);
        }

		public function getInput():IUIBase
		{
			return input;
		}


		/**
		 * @private
		 */
		override protected function inputChangeHandler(event:Event) : void
		{
		}

        protected function syncTextAndSpinner(event:Event=null):void
        {
			var signAndNumber:Array = input.text.split("-");
			var newValue:Number = Number(signAndNumber.length == 2 ? signAndNumber[1] : signAndNumber[0]);
			var sign:int = signAndNumber.length == 2 ? -1 : 1;

			if( !isNaN(newValue) ) {
				spinner.value = newValue * sign;
			}
			else {
				input.text = String(spinner.value);
			}
        }

	}


}
