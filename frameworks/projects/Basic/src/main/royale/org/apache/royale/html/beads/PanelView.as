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
package org.apache.royale.html.beads
{
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
	import org.apache.royale.html.TitleBar;
	import org.apache.royale.html.beads.layouts.VerticalFlexLayout;
	import org.apache.royale.html.supportClasses.PanelLayoutProxy;
	import org.apache.royale.utils.sendStrandEvent;

	COMPILE::SWF {
		import org.apache.royale.core.SimpleCSSStylesWithFlex;
	}

	/**
	 *  The Panel class creates the visual elements of the org.apache.royale.html.Panel
	 *  component. A Panel has a org.apache.royale.html.TitleBar, and content.  A
	 *  different View, PanelWithControlBarView, can display a ControlBar.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class PanelView extends GroupView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function PanelView()
		{
			super();
		}

		private var _titleBar:UIBase;

		/**
		 *  The org.apache.royale.html.TitleBar component of the
		 *  org.apache.royale.html.Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get titleBar():UIBase
		{
			return _titleBar;
		}

		/**
		 *  @private
		 */
		public function set titleBar(value:UIBase):void
		{
			_titleBar = value;
		}

		private var _contentArea:UIBase;

		/**
		 * The content area of the panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get contentArea():UIBase
		{
			return _contentArea;
		}
		public function set contentArea(value:UIBase):void
		{
			_contentArea = value;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IBeadLayout
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IViewport
		 *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			var host:UIBase = value as UIBase;

			// Look for a layout and/or viewport bead on the host's beads list. If one
			// is found, pull it off so it will not be added permanently
			// to the strand.
			var beads: Array = host.beads;
			var transferLayoutBead: IBeadLayout;
			var transferViewportBead: IViewport;
			if (host.beads != null) {
				for(var i:int=host.beads.length-1; i >= 0; i--) {
					if (host.beads[i] is IBeadLayout) {
						transferLayoutBead = host.beads[i] as IBeadLayout;
						host.beads.splice(i, 1);
					}
					else if (host.beads[i] is IViewport) {
						transferViewportBead = host.beads[i] as IViewport
						host.beads.splice(i, 1);
					}
				}
			}

			if (!_titleBar) {
				_titleBar = new TitleBar();
			}

			_titleBar.id = "panelTitleBar";

			_titleBar.addEventListener("close", handleClose);

			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will
			// be picked up automatically by the TitleBar.
			titleBar.model = host.model;
			if (titleBar.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(titleBar);
			}

			if (!_contentArea) {
				var cls:Class = ValuesManager.valuesImpl.getValue(_strand, "iPanelContentArea");
				_contentArea = new cls() as UIBase;
				_contentArea.id = "panelContent";
				_contentArea.typeNames = "PanelContent";

				// add the layout bead to the content area.
				if (transferLayoutBead) 
					_contentArea.addBead(transferLayoutBead);
				else
					setupContentAreaLayout();
				
				// add the viewport bead to the content area.
				if (transferViewportBead) _contentArea.addBead(transferViewportBead);

			}

			COMPILE::SWF {
				listenOnStrand("widthChanged", handleSizeChange);
				listenOnStrand("heightChanged", handleSizeChange);
				listenOnStrand("sizeChanged", handleSizeChange);
				listenOnStrand("childrenAdded", handleChildrenAdded);
		listenOnStrand("initComplete", handleInitComplete);
			}

			super.strand = value;

			if (contentArea.parent == null) {
				(_strand as IContainerBaseStrandChildrenHost).$addElement(contentArea as IChild);
			}

			setupLayout();
		}
		
		protected function setupContentAreaLayout():void
		{
			
		}
		
		protected function setupLayout():void
		{
			COMPILE::JS {
				_titleBar.element.style["flex-grow"] = "0";
				_titleBar.element.style["order"] = "1";
			}
				
			COMPILE::SWF {
				_contentArea.percentWidth = 100;
				
				if (_contentArea.style == null) {
					_contentArea.style = new SimpleCSSStylesWithFlex();
				}
				_contentArea.style.flexGrow = 1;
				_contentArea.style.order = 2;
			}
				
			COMPILE::SWF {
				_titleBar.percentWidth = 100;
				
				if (_titleBar.style == null) {
					_titleBar.style = new SimpleCSSStylesWithFlex();
				}
				_titleBar.style.flexGrow = 0;
				_titleBar.style.order = 1;
			}
			
			COMPILE::JS {
				_contentArea.element.style["flex-grow"] = "1";
				_contentArea.element.style["order"] = "2";
				_contentArea.element.style["overflow"] = "auto"; // temporary
			}
			
			// Now give the Panel its own layout
			var layoutBead:IBeadLayout = new VerticalFlexLayout();
			_strand.addBead(layoutBead);
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
		
		private var sawInitComplete:Boolean;

		private function handleChildrenAdded(event:Event):void
		{
			var host:UIBase = _strand as UIBase;
			if (sawInitComplete || 
				((host.isHeightSizedToContent() || !isNaN(host.explicitHeight)) &&
					(host.isWidthSizedToContent() || !isNaN(host.explicitWidth))))
			{
				_contentArea.dispatchEvent(new Event("layoutNeeded"));
				performLayout(event);
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function handleClose(event:Event):void
		{
			sendStrandEvent(_strand,"close");
		}

	}
}
