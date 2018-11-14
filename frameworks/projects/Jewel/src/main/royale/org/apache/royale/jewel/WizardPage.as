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
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.beads.models.WizardModel;
    import org.apache.royale.jewel.beads.models.WizardStep;

	/**
	 *  Dispatched When the wizard reach to this page
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	[Event(name="enterPage", type="org.apache.royale.events.Event")]

	/**
	 *  Dispatched When the wizard exit this page
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
    [Event(name="exitPage", type="org.apache.royale.events.Event")]

	/**
	 * WizardPage is the main class for a page inside the WizardContent
	 */
    public class WizardPage extends SectionContent
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function WizardPage()
		{
			super();

            typeNames = "jewel section wizardpage";
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var initialized:Boolean;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        // public var previousButton:Button;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        // public var nextButton:Button;

		private var _step:WizardStep;
		/**
		 *  the step data of this page
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable("change")]
        public function get step():WizardStep
		{
			return _step;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function set step(value:WizardStep):void
		{
			_step = value;
		}

		/**
		 * Determines whether a view is valid or not
		 *
		 * defaults true if the form has no validation
		 */
		public function validate():Boolean
		{
			return true;
		}

		/**
		 * add listeners to wizard events when add this page to the wizard
		 */
		public function addWizardListeners(wizard:Wizard):void
		{
			wizard.addEventListener("goToPreviousStep", goToPreviousStepHandler);
			wizard.addEventListener("goToNextStep", goToNextStepHandler);
		}

		/**
		 * remove listeners to wizard events when remove this page from the wizard
		 */
		public function removeWizardListeners(wizard:Wizard):void
		{
			wizard.removeEventListener("goToPreviousStep", goToPreviousStepHandler);
			wizard.removeEventListener("goToNextStep", goToNextStepHandler);
		}

		/**
		 *
		 */
		protected function goToPreviousStepHandler(event:Event):void
		{
			var model:WizardModel = (event.target as Wizard).getBeadByType(WizardModel) as WizardModel;
			if(model.currentStep.name == step.name)
			{
				dispatchEvent(new Event("exitPage"));
				exitPage();
			}
			if(model.currentStep.previousStep == step.name)
			{
				dispatchEvent(new Event("enterPage"));
				enterPage();
			}
		}

		/**
		 * exit page
		 */
		public function exitPage():void
		{
			// trace("exitPage", step.name);
		}

		/**
		 *
		 */
		protected function goToNextStepHandler(event:Event):void
		{
			var model:WizardModel = (event.target as Wizard).getBeadByType(WizardModel) as WizardModel;
			if(model.currentStep.name == step.name)
			{
				dispatchEvent(new Event("exitPage"));
				exitPage();
			}
			if(model.currentStep.nextStep == step.name)
			{
				dispatchEvent(new Event("enterPage"));
				enterPage();
			}
		}

		/**
		 * enter page
		 */
		public function enterPage():void
		{
			// trace("enterPage", step.name);
		}
    }
}
