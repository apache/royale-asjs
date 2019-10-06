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
package org.apache.royale.jewel.beads.controllers
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.Wizard;
	import org.apache.royale.jewel.WizardPage;
	import org.apache.royale.jewel.beads.models.WizardModel;
	import org.apache.royale.jewel.beads.models.WizardStep;
	import org.apache.royale.jewel.beads.views.WizardView;
	import org.apache.royale.jewel.events.WizardEvent;
	
    /**
     *  The WizardController class is the controller for
     *  org.apache.royale.jewel.Wizard.  Controllers
     *  watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     * 
     *  This controller watches for the click event in previous/next buttons
     *  and makes the wizard navigate to the corresponding view
     *  updates the selection model accordingly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class WizardController implements IBead, IBeadController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function WizardController()
		{
		}
		
		/**
		 *  The org.apache.royale.jewel.Wizard component
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		protected var wizard:Wizard;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function set strand(value:IStrand):void
		{
			wizard = value as Wizard;
            wizard.addEventListener("initComplete", finishSetUp);
            
            model = wizard.getBeadByType(WizardModel) as WizardModel;
            model.addEventListener("currentStepChange", handleStepChange);
            
            view = wizard.getBeadByType(WizardView) as WizardView;
		}

        /**
		 * @private
		 */
		protected function handleStepChange(event:Event):void
		{
            setUpEffects();
            wizard.title = model.currentStep.stepLabel;
            wizard.content.selectedContent = model.currentStep.name;
		}

        private var model:WizardModel;
        private var view:WizardView;

        private function finishSetUp(event:Event):void
        {
            view.previousButton.addEventListener(MouseEvent.CLICK, previousButtonClickHandler);
            view.nextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler);

            var n:int = wizard.numElements;
            for (var i:int = 0; i < n; i++)
            {
                var page:WizardPage = wizard.getElementAt(i) as WizardPage;
                
                if(page.step.initialPage)
                {
                    wizard.currentStep = page.step;
                    page.enterPage();
                    break;
                }
            }
        }

        /**
         * logic to perform when user clicks previous button
         * We assume previous button is visible and enabled so we have a previous step to go
         * We consider going backwards doesn't require validation
         */
        private function previousButtonClickHandler(event:MouseEvent):void
        {
            // if(model.currentStep.page.validate())
            // {
            var stepToGo:WizardStep = findStep(model.currentStep, true);
            wizard.dispatchEvent(new Event("goToPreviousStep"));
            model.currentStep = stepToGo;
            // }
        }

        /**
         * logic to perform when user clicks next button
         * We assume next button is visible and enabled so we have a next step to go
         * - First validate the data in the actual page
         * - if valid findStep to go forward
         */
        private function nextButtonClickHandler(event:MouseEvent):void
        {
            if(model.currentStep.page.validate())
            {
                var stepToGo:WizardStep = findStep(model.currentStep, false);
                wizard.dispatchEvent(new Event("goToNextStep"));
                model.currentStep = stepToGo;
            }
        }

        /**
         * Given a step, find a next or previous one taking autoSkip into account
         * autoSkip is only evaluated when going forward.
         * 
         * @param step, the step to discover its next
         * @param previous, if true find the previous step, if false find the next step. Defaults to find next step
         */
        private function findStep(step:WizardStep, previous:Boolean):WizardStep
        {
            var n:int = wizard.numElements;
            for (var i:int = 0; i < n; i++)
            {
                var page:WizardPage = wizard.getElementAt(i) as WizardPage;
                if(page.step.name == (previous ? step.previousStep : step.nextStep))
                {
                    return !previous && step.autoSkip ? findStep(page.step, previous) : page.step;
                }
            }
            
            return null;
        }

        public function setUpEffects():void
		{
			if(model.activateEffect)
			{
                model.currentStep.page.removeClass(WizardPage.LEFT_EFFECT);
                model.currentStep.page.removeClass(WizardPage.RIGHT_EFFECT);
                
                var previous:WizardStep = findStep(model.currentStep, true);

                while(previous != null)
                {
                    // this prevents bindings not done
                    if(previous != null && !previous.name)
                        break;
                    previous.page.removeClass(WizardPage.RIGHT_EFFECT);
				    previous.page.addClass(WizardPage.LEFT_EFFECT);
                    previous = findStep(previous, true);
                }
                
                var next:WizardStep = findStep(model.currentStep, false);
                while(next != null)
                {
                    // this prevents bindings not done
                    if(next != null && !next.name)
                        break;
                    next.page.removeClass(WizardPage.LEFT_EFFECT);
	    			next.page.addClass(WizardPage.RIGHT_EFFECT);
                    next = findStep(next, false);
                }

                // depending on step config we still can have pages not configured to transition correctly
                var n:int = wizard.numElements;
                var foundSelected:Boolean;
                for (var i:int = 0; i < n; i++)
                {
                    var page:WizardPage = wizard.getElementAt(i) as WizardPage;
                    if (page == model.currentStep.page) 
                    {
                        foundSelected = true;
                        continue;
                    }
                    if(!page.containsClass(WizardPage.LEFT_EFFECT) && !page.containsClass(WizardPage.LEFT_EFFECT))
                    {
                        if (foundSelected)
                            page.addClass(WizardPage.RIGHT_EFFECT)
                        else
                            page.addClass(WizardPage.LEFT_EFFECT)
                    }
                }
            }
		}
    }
}