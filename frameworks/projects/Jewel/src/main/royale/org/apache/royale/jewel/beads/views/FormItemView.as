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
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainerBaseStrandChildrenHost;
    import org.apache.royale.core.ILayoutView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IViewport;
    import org.apache.royale.core.SimpleCSSStylesWithFlex;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.GroupView;
    import org.apache.royale.jewel.FormItem;
    import org.apache.royale.jewel.Label;
    import org.apache.royale.jewel.beads.controls.TextAlign;
    import org.apache.royale.jewel.beads.layouts.VerticalLayout;
    import org.apache.royale.jewel.beads.models.FormItemModel;
    import org.apache.royale.jewel.supportClasses.LayoutProxy;
    import org.apache.royale.jewel.HGroup;


    /**
	 *  The FormItemView class creates the visual elements of the org.apache.royale.jewel.FormItem
	 *  component. A FormItem has two org.apache.royale.jewel.Label (one for text and other to show requeriment),
	 *  and content.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class FormItemView extends GroupView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FormItemView()
		{
			super();
		}

        /**
		 *  The org.apache.royale.jewel.FormItem component
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		protected var formItem:FormItem;

        private var _contentArea:UIBase;
		/**
		 *  The content area of the formItem.
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

        protected var model:FormItemModel;

        protected var textLabel:Label;
        protected var textLabelAlign:TextAlign;

        protected var requiredLabel:Label;


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
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            formItem = value as FormItem;

            model = _strand.getBeadByType(FormItemModel) as FormItemModel;
			model.addEventListener("textChange", textChangeHandler);
			model.addEventListener("htmlChange", textChangeHandler);
            model.addEventListener("requiredChange", requiredChangeHandler);

            // Look for a layout and/or viewport bead on the formItem's beads list delcared in MXML.
			// If one is found, pull it off so it will not be added permanently to the strand.
            var beads:Array = formItem.beads;
            var transferLayoutBead:IBeadLayout;
            var transferViewportBead:IViewport;
			if (formItem.beads != null) {
				for(var i:int=formItem.beads.length-1; i >= 0; i--) {
					if (formItem.beads[i] is IBeadLayout) {
						transferLayoutBead = formItem.beads[i] as IBeadLayout;
						formItem.beads.splice(i, 1);
					}
					else if (formItem.beads[i] is IViewport) {
						transferViewportBead = formItem.beads[i] as IViewport
						formItem.beads.splice(i, 1);
					}
				}
			}

            if (!_contentArea) {
                var cls:Class = ValuesManager.valuesImpl.getValue(_strand, "iFormItemContentArea");
				_contentArea = new cls() as UIBase;
				_contentArea.className = "content";

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
			var labelGroup:HGroup;
			if (labelGroup == null) {
				labelGroup = new HGroup();
				labelGroup.gap = 2;
				labelGroup.itemsVerticalAlign = "itemsCenter";
				labelGroup.className = "labelGroup";
			}
			if (labelGroup != null && labelGroup.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(labelGroup);
			}

            if (textLabel == null) {
				textLabel = createLabel(model.text);
				textLabel.multiline = true;
				textLabel.className = "formlabel";
			}
			if (textLabel != null && textLabel.parent == null) {
				labelGroup.addElement(textLabel);
				textLabelAlign = new TextAlign();
				textLabelAlign.align = model.labelAlign;
				textLabel.addBead(textLabelAlign);
			}

			if (requiredLabel == null) {
				var ast:String = model.required ? "*" : "";
				requiredLabel = createLabel(ast);
				requiredLabel.className = "required";
			}
			if (requiredLabel != null && requiredLabel.parent == null) {
				labelGroup.addElement(requiredLabel);
			}

			if (contentArea.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(contentArea as IChild);
			}

            setupLayout();
        }

        /**
		 *
		 */
		public function createLabel(labelText:String = null):Label
		{
			var l:Label = new Label();
			if(labelText != null)
				l.text = labelText;
			return l;
		}

		/**
		 *
		 */
		public function textChangeHandler(event:Event):void
		{
			textLabel.text = model.text;
		}

        public function requiredChangeHandler(event:Event):void
        {
            requiredLabel.text = model.required ? "*" : "";
        }

        protected function setupContentAreaLayout():void
        {
			var defaultContentAreaLayout:VerticalLayout = new VerticalLayout();
			defaultContentAreaLayout.gap = 2;
			// defaultContentAreaLayout.itemsHorizontalAlign = "itemsCenter";
            contentArea.addBead(defaultContentAreaLayout);
        }

        protected function setupLayout():void
        {
            COMPILE::SWF {
                _contentArea.percentWidth = 100;

                if (_contentArea.style == null) {
                    _contentArea.style = new SimpleCSSStylesWithFlex();
                }
                _contentArea.style.flexGrow = 1;
                _contentArea.style.order = 2;
            }

            // Now give the FormItem its own layout
			//var layoutBead:IBeadLayout = new VerticalLayout();
			//layoutBead.itemsVerticalAlign = "itemsCenter";
			//_strand.addBead(layoutBead);
		}

        private var _formItemLayoutProxy:LayoutProxy;

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
			// we want to return a proxy for the formItem which will have numElements, getElementAt, etc.
			// functions that will use the formItem.$numElements, formItem.$getElementAt, etc. functions
			if (_formItemLayoutProxy == null) {
				_formItemLayoutProxy = new LayoutProxy(_strand);
			}
			return _formItemLayoutProxy;
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
                ((formItem.isHeightSizedToContent() || !isNaN(formItem.explicitHeight)) &&
                    (formItem.isWidthSizedToContent() || !isNaN(formItem.explicitWidth))))
            {
    			_contentArea.dispatchEvent(new Event("layoutNeeded"));
	    		performLayout(event);
            }
		}
    }
}
