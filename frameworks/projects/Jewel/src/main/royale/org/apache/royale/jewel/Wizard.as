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
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainerBaseStrandChildrenHost;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.beads.models.WizardModel;
    import org.apache.royale.jewel.beads.models.WizardStep;
    import org.apache.royale.jewel.beads.views.WizardView;

	/**
	 *  Indicates that wizard navigates to the previous page.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	[Event(name="goToPreviousStep", type="org.apache.royale.events.Event")]

	/**
	 *  Indicates that wizard navigates to the next page.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
    [Event(name="goToNextStep", type="org.apache.royale.events.Event")]
	
	/**
	 *  Indicates a change of step
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
    [Event(name="change", type="org.apache.royale.events.Event")]

	/**
	 * Wizard is a container that navigates from one content to the next.
	 * The content is organized in wizard pages It can provide previous and next navigation buttons
	 * 
	 * @see org.apache.royale.jewel.WizardPage
	 */
    public class Wizard extends Group implements IContainerBaseStrandChildrenHost
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Wizard()
		{
			super();

            typeNames = "jewel wizard";
		}

		/**
		 * Update currentStep by name finding the appropiate step
		 * 
		 * @param stepName, that is the "id" of the content (the WizardPage) to activate
		 * 
		 * @see org.apache.royale.jewel.WizardContent.selectedContent
		 */
		public function showPage(stepName:String):void
		{
			var step:WizardStep = findStepByName(stepName);
			if (step) {
				currentStep = step;
			} else {
				throw new Error('Unknown wizard step:'+ stepName)
			}
		}

		public function findStepByName(name:String):WizardStep
		{
			var n:int = numElements;
            for (var i:int = 0; i < n; i++)
            {
                var page:WizardPage = getElementAt(i) as WizardPage;
                if(page.step.name == name)
                {
                    return page.step;
                }
            }
            
            return null;
		}

		/**
		 *  The string to display in the org.apache.royale.jewel.TitleBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function get title():String
		{
			return WizardModel(model).text;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function set title(value:String):void
		{
			WizardModel(model).text = value;
		}
		
		/**
		 *  turn on/off the transition effects
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function get activateEffect():Boolean
		{
			return WizardModel(model).activateEffect;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function set activateEffect(value:Boolean):void
		{
			WizardModel(model).activateEffect = value;
		}
		
		/**
		 *  The HTML string to display in the org.apache.royale.jewel.TitleBar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function get htmlTitle():String
		{
			return WizardModel(model).html;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function set htmlTitle(value:String):void
		{
			WizardModel(model).html = value;
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var previousButton:UIBase = null;

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var nextButton:UIBase = null;

		/**
		 * the pages of the wizard
		 */
		public function get content():WizardContent
		{
			return (view as WizardView).contentArea as WizardContent;
		}

		/**
		 *  the current step or page visualized in this wizard
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable("change")]
        public function get currentStep():WizardStep
		{
			return WizardModel(model).currentStep;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		public function set currentStep(value:WizardStep):void
		{
			WizardModel(model).currentStep = value;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.views.WizardView
		 * @royaleignorecoercion org.apache.royale.jewel.WizardPage
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var page:WizardPage = c as WizardPage;
			page.model = model;
			
			var wizardView:WizardView = view as WizardView;
			wizardView.contentArea.addElement(page, dispatchEvent);
			wizardView.contentArea.dispatchEvent(new Event("layoutNeeded"));

			page.step.page = c as WizardPage;
			page.addWizardListeners(this);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.views.WizardView
		 * @royaleignorecoercion org.apache.royale.jewel.WizardPage
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			var page:WizardPage = c as WizardPage;
			page.model = model;

			var wizardView:WizardView = view as WizardView;
			wizardView.contentArea.addElementAt(page, index, dispatchEvent);
			wizardView.contentArea.dispatchEvent(new Event("layoutNeeded"));
			
			page.step.page = c as WizardPage;
			page.addWizardListeners(this);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.views.WizardView
		 * @royaleignorecoercion org.apache.royale.jewel.WizardPage
		 */
		override public function getElementIndex(c:IChild):int
		{
			var wizardView:WizardView = view as WizardView;
			return wizardView.contentArea.getElementIndex(c);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.views.WizardView
		 * @royaleignorecoercion org.apache.royale.jewel.WizardPage
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var wizardView:WizardView = view as WizardView;
			wizardView.contentArea.removeElement(c, dispatchEvent);
			
			var page:WizardPage = c as WizardPage;
			page.removeWizardListeners(this);
			page.step.page = null;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.views.WizardView
		 */
		override public function get numElements():int
		{
			var wizardView:WizardView = view as WizardView;
			return wizardView.contentArea.numElements;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.views.WizardView
		 */
		override public function getElementAt(index:int):IChild
		{
			var wizardView:WizardView = view as WizardView;
			return wizardView.contentArea.getElementAt(index);
		}



		public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            super.addElementAt(c, index, dispatchEvent);
        }
        
		public function get $numElements():int
		{
			return super.numElements;
		}
		
		public function $getElementAt(index:int):IChild
		{
			return super.getElementAt(index);
		}
		
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            super.removeElement(c, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $getElementIndex(c:IChild):int
        {
            return super.getElementIndex(c);
        }
    }
}