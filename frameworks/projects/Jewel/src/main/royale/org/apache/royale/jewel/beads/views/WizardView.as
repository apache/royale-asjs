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
	}
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IContainerBaseStrandChildrenHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.IconButton;
	import org.apache.royale.jewel.Wizard;
	import org.apache.royale.jewel.beads.models.WizardModel;
	import org.apache.royale.jewel.supportClasses.wizard.WizardLayoutProxy;

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
        public function get previousButton():IconButton
        {
        	return wizard.previousButton;
        }
        public function set previousButton(value:IconButton):void
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
        public function get nextButton():IconButton
        {
        	return wizard.nextButton;
        }
        public function set nextButton(value:IconButton):void
        {
        	wizard.nextButton = value;
        }

		// private var _titleBar:UIBase;

		/**
		 *  The org.apache.royale.jewel.TitleBar component of the
		 *  org.apache.royale.jewel.Wizard.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		// public function get titleBar():UIBase
		// {
		// 	return _titleBar;
		// }

        /**
         *  @private
         */
        // public function set titleBar(value:UIBase):void
        // {
        //     _titleBar = value;
        // }

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

			// Look for a layout and/or viewport bead on the wizard's beads list. If one
			// is found, pull it off so it will not be added permanently
			// to the strand.
            var beads:Array = wizard.beads;
            var transferLayoutBead:IBeadLayout;
            var transferViewportBead:IViewport;
			if (wizard.beads != null) {
				for(var i:int=wizard.beads.length-1; i >= 0; i--) {
					if (wizard.beads[i] is IBeadLayout) {
						transferLayoutBead = wizard.beads[i] as IBeadLayout;
						wizard.beads.splice(i, 1);
					}
					else if (wizard.beads[i] is IViewport) {
						transferViewportBead = wizard.beads[i] as IViewport
						wizard.beads.splice(i, 1);
					}
				}
			}

            // if (!_titleBar) {
            //     _titleBar = new TitleBar();
			// }
			// _titleBar.id = "wizardTitleBar";
			// _titleBar.addEventListener("close", handleClose);
			// replace the TitleBar's model with the Wizard's model (it implements ITitleBarModel) so that
			// any changes to values in the Wizard's model that correspond values in the TitleBar will
			// be picked up automatically by the TitleBar.
			// titleBar.model = wizard.model;
			// if (titleBar.parent == null) {
			// 	(_strand as IContainerBaseStrandChildrenHost).$addElement(titleBar);
			// }
			
			if (!_contentArea) {
                var cls:Class = ValuesManager.valuesImpl.getValue(_strand, "iWizardContentArea");
				_contentArea = new cls() as UIBase;
				// _contentArea.id = "content";

				// add the layout bead to the content area.
				if (transferLayoutBead) 
                    _contentArea.addBead(transferLayoutBead);
                else
                    setupContentAreaLayout();
                
				// add the viewport bead to the content area.
				if (transferViewportBead) 
					_contentArea.addBead(transferViewportBead);

			}

			COMPILE::SWF {
				IEventDispatcher(value).addEventListener("widthChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("heightChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("sizeChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("childrenAdded", handleChildrenAdded);
                IEventDispatcher(value).addEventListener("initComplete", handleInitComplete);
			}

            // super.strand = value;

			if (previousButton == null) {
				previousButton = createButton("previous", Button.SECONDARY);
			}
			previousButton.className = "previous";
			if (previousButton != null && previousButton.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(previousButton);
			}

			if (contentArea.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(contentArea as IChild);
			}

			if (nextButton == null) {
				nextButton = createButton("next", Button.SECONDARY);
			}
			nextButton.className = "next";
			if (nextButton != null && nextButton.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(nextButton);
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
		 * @private
		 */
		protected function handleStepChange(event:Event):void
		{
			stepChangeAction();
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.beads.models.WizardModel
		 */
		protected function stepChangeAction():void
		{
			previousButton.visible = (model.currentStep.previousStep != null);
			nextButton.visible = (model.currentStep.nextStep != null);
		}
		
        protected function setupContentAreaLayout():void
        {
            
        }
        
        protected function setupLayout():void
        {
            // COMPILE::JS {
            //     _titleBar.element.style["flex-grow"] = "0";
            //     _titleBar.element.style["order"] = "1";
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
            //     _titleBar.percentWidth = 100;
                
            //     if (_titleBar.style == null) {
            //         _titleBar.style = new SimpleCSSStylesWithFlex();
            //     }
            //     _titleBar.style.flexGrow = 0;
            //     _titleBar.style.order = 1;
            // }
            
            // COMPILE::JS {
            //     _contentArea.element.style["flex-grow"] = "1";
            //     _contentArea.element.style["order"] = "2";
            //     _contentArea.element.style["overflow"] = "auto"; // temporary
            // }
            
			// Now give the Wizard its own layout
			// var layoutBead:WizardLayout = new WizardLayout();
			// layoutBead.itemsVerticalAlign = "itemsCentered";
			// _strand.addBead(layoutBead);
		}

		private var _wizardLayoutProxy:WizardLayoutProxy;

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
				_wizardLayoutProxy = new WizardLayoutProxy(_strand);
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
				// _titleBar.percentWidth = 100;
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
