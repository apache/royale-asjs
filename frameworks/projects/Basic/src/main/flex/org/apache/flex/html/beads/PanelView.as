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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.geom.Size;
	import org.apache.flex.html.Group;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.Panel;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;
	import org.apache.flex.html.beads.layouts.VerticalFlexLayout;
	import org.apache.flex.html.supportClasses.PanelLayoutProxy;

	COMPILE::SWF {
		import org.apache.flex.core.SimpleCSSStylesWithFlex;
	}

	/**
	 *  The Panel class creates the visual elements of the org.apache.flex.html.Panel
	 *  component. A Panel has a org.apache.flex.html.TitleBar, and content.  A
     *  different View, PanelWithControlBarView, can display a ControlBar.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PanelView extends GroupView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function PanelView()
		{
			super();
		}

		private var _titleBar:TitleBar;

		/**
		 *  The org.apache.flex.html.TitleBar component of the
		 *  org.apache.flex.html.Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}

        /**
         *  @private
         */
        public function set titleBar(value:TitleBar):void
        {
            _titleBar = value;
        }

		private var _contentArea:Container;

		/**
		 * The content area of the panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get contentArea():Container
		{
			return _contentArea;
		}
		public function set contentArea(value:Container):void
		{
			_contentArea = value;
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;

            var host:UIBase = UIBase(value);

            if (!_titleBar) {
                _titleBar = new TitleBar();
			}
			
			_titleBar.id = "panelTitleBar";

			COMPILE::SWF {
				_titleBar.percentWidth = 100;

				if (_titleBar.style == null) {
					_titleBar.style = new SimpleCSSStylesWithFlex();
				}
				_titleBar.style.flexGrow = 0;
				_titleBar.style.order = 1;
			}

			COMPILE::JS {
				_titleBar.element.style["flex-grow"] = "0";
				_titleBar.element.style["order"] = "1";
			}
			
			_titleBar.addEventListener("close", handleClose);

			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will
			// be picked up automatically by the TitleBar.
			titleBar.model = host.model;
			if (titleBar.parent == null) {
				(_strand as Panel).$addElement(titleBar);
			}

			if (!_contentArea) {
				_contentArea = new Container();
				_contentArea.id = "panelContent";
				_contentArea.className = "PanelContent";

				COMPILE::SWF {
					_contentArea.percentWidth = 100;

					if (_contentArea.style == null) {
						_contentArea.style = new SimpleCSSStylesWithFlex();
					}
					_contentArea.style.flexGrow = 1;
					_contentArea.style.order = 2;
				}

				COMPILE::JS {
					_contentArea.element.style["flex-grow"] = "1";
					_contentArea.element.style["order"] = "2";
					_contentArea.element.style["overflow"] = "auto"; // temporary
				}
			}

			COMPILE::SWF {
				IEventDispatcher(value).addEventListener("widthChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("heightChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("sizeChanged", handleSizeChange);
				IEventDispatcher(value).addEventListener("childrenAdded", handleChildrenAdded);
			}

            super.strand = value;

			// If the Panel was given a layout, transfer it to the content area.
			var layoutBead:IBeadLayout = value.getBeadByType(IBeadLayout) as IBeadLayout;
			if (layoutBead) {
				value.removeBead(layoutBead);

				var contentLayout:IBeadLayout = _contentArea.getBeadByType(IBeadLayout) as IBeadLayout;
				if (contentLayout) {
					_contentArea.removeBead(contentLayout);
				}
				_contentArea.addBead(layoutBead);
			}

			// If the Panel was given a viewport, transfer it to the content area.
			var viewportBead:IViewport = value.getBeadByType(IViewport) as IViewport;
			if (viewportBead) {
				value.removeBead(viewportBead);
				_contentArea.addBead(viewportBead);
			}

			if (contentArea.parent == null) {
				(_strand as Panel).$addElement(contentArea as IChild);
			}

			// Now give the Panel its own layout
			layoutBead = new VerticalFlexLayout();
			value.addBead(layoutBead);
		}

		private var _panelLayoutProxy:PanelLayoutProxy;

		/**
		 * The sub-element used as the parent of the container's elements. This does not
		 * include the chrome elements.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override public function get contentView():ILayoutView
		{
			// we want to return a proxy for the host which will have numElements, getElementAt, etc.
			// functions that will use the host.$numElements, host.$getElementAt, etc. functions
			if (_panelLayoutProxy == null) {
				_panelLayoutProxy = new PanelLayoutProxy(_strand);
			}
			return _panelLayoutProxy;
		}

		override protected function completeSetup():void
		{
			super.completeSetup();
			
			performLayout(null);
		}

		protected function handleSizeChange(event:Event):void
		{
			COMPILE::JS {
				_titleBar.percentWidth = 100;
				_contentArea.percentWidth = 100;
			}

			performLayout(event);
		}

		private function handleChildrenAdded(event:Event):void
		{
			_contentArea.dispatchEvent(new Event("layoutNeeded"));
			performLayout(event);
		}
		
		private function handleClose(event:Event):void
		{
			IEventDispatcher(_strand).dispatchEvent(new Event("close"));
		}
		
	}
}
