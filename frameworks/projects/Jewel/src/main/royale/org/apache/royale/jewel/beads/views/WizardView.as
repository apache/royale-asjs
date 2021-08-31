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
	COMPILE::SWF {
	import org.apache.royale.core.SimpleCSSStylesWithFlex;
	import org.apache.royale.events.IEventDispatcher;
	}
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IContainerBaseStrandChildrenHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.jewel.HGroup;
	import org.apache.royale.jewel.IconButton;
	import org.apache.royale.jewel.Label;
	import org.apache.royale.jewel.VGroup;
	import org.apache.royale.jewel.Wizard;
	import org.apache.royale.jewel.WizardPage;
	import org.apache.royale.jewel.beads.models.WizardModel;
	import org.apache.royale.jewel.supportClasses.LayoutProxy;

	/**
	 *  The Wizard class creates the visual elements of the org.apache.royale.jewel.Wizard
	 *  component. A Wizard has two org.apache.royale.jewel.Button, and content. The buttons
	 *  navigate pages to previous or next.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class WizardView extends GroupView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function WizardView()
		{
			super();
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
		 *  The org.apache.royale.jewel.Wizard.previousButton
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get previousButton():UIBase
        {
        	return wizard.previousButton;
        }
        public function set previousButton(value:UIBase):void
        {
        	wizard.previousButton = value;
        }

		/**
		 *  The org.apache.royale.jewel.Wizard.nextButton
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get nextButton():UIBase
        {
        	return wizard.nextButton;
        }
        public function set nextButton(value:UIBase):void
        {
        	wizard.nextButton = value;
        }

		private var _titleLabel:UIBase;
		/**
		 *  The org.apache.royale.jewel.TitleBar component of the
		 *  org.apache.royale.jewel.Wizard.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get titleLabel():UIBase
		{
			return _titleLabel;
		}
        /**
         *  @private
         */
        public function set titleLabel(value:UIBase):void
        {
            _titleLabel = value;
        }

		private var _contentArea:UIBase;
		/**
		 * The content area of the wizard.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get contentArea():UIBase
		{
			return _contentArea;
		}
		public function set contentArea(value:UIBase):void
		{
			_contentArea = value;
		}

		private var model:WizardModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IBeadLayout
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IViewport
		 *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            wizard = value as Wizard;
			
			model = _strand.getBeadByType(WizardModel) as WizardModel;
			model.addEventListener("currentStepChange", handleStepChange);
			model.addEventListener("showPreviousButtonChange", handleStepChange);
			model.addEventListener("showNextButtonChange", handleStepChange);

			if (!_titleLabel) {
                _titleLabel = new Label();
				(_titleLabel as Label).text = wizard.model.text;
			}
			//_titleLabel.id = "wizardTitle";
			titleLabel.className = "wizardTitle";
			// replace the Label's model with the Wizard's model (it implements ITextModel) so that
			// any changes to values in the Wizard's model that correspond values in the Label will
			// be picked up automatically by the Title Label.
			titleLabel.model = wizard.model;

			model.addEventListener("textChange", textChangeHandler);
			model.addEventListener("htmlChange", textChangeHandler);
			
			if (!_contentArea) {
                var cls:Class = ValuesManager.valuesImpl.getValue(_strand, "iWizardContentArea");
				_contentArea = new cls() as UIBase;
				// _contentArea.id = "content";
				setupContentAreaLayout();
			}

			COMPILE::SWF {
				IEventDispatcher(value).addEventListener("widthChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("heightChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("sizeChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("childrenAdded", handleChildrenAdded);
                IEventDispatcher(value).addEventListener("initComplete", handleInitComplete);
			}

			// adds an vgroup so we can arrange vertically the title and then the rest of content
			var vg:VGroup = new VGroup();
			vg.className = "jewel wizard main"
			vg.gap = 3;
			(_strand as IContainerBaseStrandChildrenHost).$addElement(vg);

			// add title
            if (titleLabel.parent == null) {
				vg.addElement(titleLabel);
			}

			var g:HGroup = new HGroup();
			g.className = "precontent";
			g.gap = 3;
			g.itemsVerticalAlign = "itemsCenter";
			// add the group that holds buttons and content
            if (g.parent == null) {
				vg.addElement(g);
				//g.addBead(_strand.getBeadByType(IBeadLayout));
			}
			
			// add previous button
			if (previousButton == null) {
				previousButton = createButton("previous", StyledUIBase.SECONDARY) as UIBase;
			}
			previousButton.className = "jewel wizard previous";
			if (previousButton != null && previousButton.parent == null) {
				g.addElement(previousButton);
			}

			// add content
			if (contentArea.parent == null) {
				g.addElement(contentArea);
			}

			// add next button
			if (nextButton == null) {
				nextButton = createButton("next", StyledUIBase.SECONDARY) as UIBase;
			}
			nextButton.className = "jewel wizard next";
			if (nextButton != null && nextButton.parent == null) {
				g.addElement(nextButton);
			}

            setupLayout();
        }

		/**
		 *
		 */
		public function createButton(labelText:String = null, emphasis:String = null):IconButton
		{
			var b:IconButton = new IconButton();
			if(labelText != null)
				b.text = labelText;
			if(emphasis != null)
				b.emphasis = emphasis;

			return b;
		}

		/**
		 *
		 */
		public function textChangeHandler(event:Event):void
		{
			(titleLabel as Label).text = model.text;
		}

		/**
		 * @private
		 */
		protected function handleStepChange(event:Event):void
		{
			stepChangeAction();
		}

		/**
		 *
		 */
		public function showPreviousButtonChangeHandler(event:Event):void
		{
			model.showPreviousButton = (event.target as WizardPage).showPreviousButton;
		}

		/**
		 *
		 */
		public function showNextButtonChangeHandler(event:Event):void
		{
			model.showNextButton = (event.target as WizardPage).showNextButton;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		protected function stepChangeAction():void
		{
			if(model.activateEffect) {
				COMPILE::JS
				{
				previousButton.element.style.visibility = model.showPreviousButton && model.currentStep && model.currentStep.previousStep != null ? "visible" : "hidden";
				nextButton.element.style.visibility = model.showNextButton && model.currentStep && model.currentStep.nextStep != null ? "visible" : "hidden";
				}
			} else {
				previousButton.visible = model.showPreviousButton && model.currentStep && model.currentStep.previousStep != null;
				nextButton.visible = model.showNextButton && model.currentStep && model.currentStep.nextStep != null;
			}
		}

        protected function setupContentAreaLayout():void
        {
        
        }
        
        protected function setupLayout():void
        {
            // COMPILE::JS {
            //     _titleLabel.element.style["flex-grow"] = "0";
            //     _titleLabel.element.style["order"] = "1";
            // }
            
            COMPILE::SWF {
                _contentArea.percentWidth = 100;
                
                if (_contentArea.style == null) {
                    _contentArea.style = new SimpleCSSStylesWithFlex();
                }
                _contentArea.style.flexGrow = 1;
                _contentArea.style.order = 2;
            }
            
            // COMPILE::SWF {
            //     _titleLabel.percentWidth = 100;
            
            //     if (_titleLabel.style == null) {
            //         _titleLabel.style = new SimpleCSSStylesWithFlex();
            //     }
            //     _titleLabel.style.flexGrow = 0;
            //     _titleLabel.style.order = 1;
            // }
            
            // COMPILE::JS {
            //     _contentArea.element.style["flex-grow"] = "1";
            //     _contentArea.element.style["order"] = "2";
            //     _contentArea.element.style["overflow"] = "auto"; // temporary
            // }
            
			// Now give the Wizard its own layout
			// var layoutBead:WizardLayout = new WizardLayout();
			// layoutBead.itemsVerticalAlign = "itemsCenter";
			// _strand.addBead(layoutBead);
		}

		private var _wizardLayoutProxy:LayoutProxy;

		/**
		 * The sub-element used as the parent of the container's elements. This does not
		 * include the chrome elements.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function get contentView():ILayoutView
		{
			// we want to return a proxy for the wizard which will have numElements, getElementAt, etc.
			// functions that will use the wizard.$numElements, wizard.$getElementAt, etc. functions
			if (_wizardLayoutProxy == null) {
				_wizardLayoutProxy = new LayoutProxy(_strand);
			}
			return _wizardLayoutProxy;
		}

		override protected function completeSetup():void
		{
			super.completeSetup();

			performLayout(null);
		}

		protected function handleSizeChange(event:Event):void
		{
			COMPILE::JS {
				// _titleLabel.percentWidth = 100;
				_contentArea.percentWidth = 100;
			}

			performLayout(event);
		}
        
        private var sawInitComplete:Boolean;

		private function handleChildrenAdded(event:Event):void
		{
            if (sawInitComplete ||
                ((wizard.isHeightSizedToContent() || !isNaN(wizard.explicitHeight)) &&
                    (wizard.isWidthSizedToContent() || !isNaN(wizard.explicitWidth))))
            {
    			_contentArea.dispatchEvent(new Event("layoutNeeded"));
	    		performLayout(event);
            }
		}
	}
}
