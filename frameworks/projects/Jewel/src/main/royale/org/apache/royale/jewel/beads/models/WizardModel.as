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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	/**
	 *  The WizardModel bead class holds the values for a org.apache.royale.jewel.Wizard
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class WizardModel extends EventDispatcher implements IBeadModel, ITextModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function WizardModel()
		{
			super();
		}

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
        private var _activateEffect:Boolean = true;
		/**
		 *  turn on/off the transition effects
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		[Bindable(event="activateEffectChange")]
		public function get activateEffect():Boolean
		{
			return _activateEffect;
		}
		public function set activateEffect(value:Boolean):void
		{
			if(value != _activateEffect) {
				_activateEffect = value;
				dispatchEvent(new Event('activateEffectChange'));
			}
		}
        
		private var _text:String;
		/**
		 *  The title string for the org.apache.royale.jewel.Wizard.
		 *
		 *  @copy org.apache.royale.jewel.beads.models.WizardModel#title
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable(event="textChange")]
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			if(value != _text) {
				_text = value;
				dispatchEvent(new Event('textChange'));
			}
		}

		private var _html:String;
		/**
		 *  The HTML string for the title.
		 *
		 *  @copy org.apache.royale.jewel.beads.models.WizardModel#html
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable(event="htmlChange")]
		public function get html():String
		{
			return _html;
		}
		public function set html(value:String):void
		{
			if( value != _html ) {
				_html = value;
				dispatchEvent( new Event('htmlChange') );
			}
		}
		
		private var _currentStep:WizardStep;
		/**
		 *  the current step or page visualized in this wizard
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable(event="currentStepChange")]
		public function get currentStep():WizardStep
		{
			return _currentStep;
		}
		public function set currentStep(value:WizardStep):void
		{
			if(value != _currentStep) {
				if (_currentStep) {
					amendCurrentStepListeners(_currentStep, true);
				}
				_currentStep = value;
				if (value) {
					amendCurrentStepListeners(value, false);
				}
				dispatchEvent(new Event('currentStepChange'));
			}
		}
		
		private function amendCurrentStepListeners(step:WizardStep, remove:Boolean):void{
			if (remove) {
				step.removeEventListener('nextStepChange', onCurrentStepNextPreviousChange);
				step.removeEventListener('previousStepChange', onCurrentStepNextPreviousChange);
			} else {
				step.addEventListener('nextStepChange', onCurrentStepNextPreviousChange);
				step.addEventListener('previousStepChange', onCurrentStepNextPreviousChange);
			}
		}
		
		private function onCurrentStepNextPreviousChange(event:Event):void{
			//something else changed within the currentStep that is important...
			dispatchEvent(new Event('currentStepChange'));
		}
		

		private var _showPreviousButton:Boolean = true;
		/**
		 *  show/hide wizard navigator previous button in the wizard
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable(event="showPreviousButtonChange")]
		public function get showPreviousButton():Boolean
		{
			return _showPreviousButton;
		}
		public function set showPreviousButton(value:Boolean):void
		{
			if(value != _showPreviousButton)
			{
				_showPreviousButton=value;
				dispatchEvent(new Event("showPreviousButtonChange"));
			}
		}
		
		private var _showNextButton:Boolean = true;
		/**
		 *  show/hide wizard navigator next button in the wizard
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable(event="showNextButtonChange")]
		public function get showNextButton():Boolean
		{
			return _showNextButton;
		}
		public function set showNextButton(value:Boolean):void
		{
			if(value != _showNextButton)
			{
				_showNextButton=value;
				dispatchEvent(new Event("showNextButtonChange"));
			}
		}
	}
}
