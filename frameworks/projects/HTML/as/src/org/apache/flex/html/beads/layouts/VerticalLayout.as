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
package org.apache.flex.html.beads.layouts
{
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.utils.dbg.DOMPathUtil;
	
	/**
	 *  The VerticalLayout class is a simple layout
	 *  bead.  It takes the set of children and lays them out
	 *  vertically in one column, separating them according to
	 *  CSS layout rules for margin and horizontal-align styles.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class VerticalLayout implements IBeadLayout
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function VerticalLayout()
		{
		}
		
		// the strand/host container is also an ILayoutChild because
		// can have its size dictated by the host's parent which is
		// important to know for layout optimization
		private var host:ILayoutChild;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			host = value as ILayoutChild; 
		}
		
		private var _viewportModel:IViewportModel;
		
		/**
		 *  The data that describes the viewport used by this layout.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get viewportModel():IViewportModel
		{
			return _viewportModel;
		}
		public function set viewportModel(value:IViewportModel):void
		{
			_viewportModel = value;
		}
		
		public function layout():Boolean
		{
			var layoutParent:ILayoutParent = host.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
			
			// this layout will use and modify the IViewportMode
			var viewport:IViewport = host.getBeadByType(IViewport) as IViewport;
			if (viewport) viewportModel = viewport.model;

			var n:int = contentView.numElements;
			var hasHorizontalFlex:Boolean;
			var hostSizedToContent:Boolean = host.isWidthSizedToContent();
			var flexibleHorizontalMargins:Array = [];
			var ilc:ILayoutChild;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			var maxWidth:Number = 0;
			// asking for contentView.width can result in infinite loop if host isn't sized already
			var w:Number = hostSizedToContent ? 0 : contentView.width;
			
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				ilc = child as ILayoutChild;
				var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
				var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
				margin = ValuesManager.valuesImpl.getValue(child, "margin");
				if (margin is Array)
				{
					if (margin.length == 1)
						marginLeft = marginTop = marginRight = marginBottom = margin[0];
					else if (margin.length <= 3)
					{
						marginLeft = marginRight = margin[1];
						marginTop = marginBottom = margin[0];
					}
					else if (margin.length == 4)
					{
						marginLeft = margin[3];
						marginBottom = margin[2];
						marginRight = margin[1];
						marginTop = margin[0];					
					}
				}
				else if (margin == null)
				{
					marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
					marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
					marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
					marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
				}
				else
				{
					marginLeft = marginTop = marginBottom = marginRight = margin;
				}
				var ml:Number;
				var mr:Number;
				var mt:Number;
				var mb:Number;
				var lastmb:Number;
				mt = Number(marginTop);
				if (isNaN(mt))
					mt = 0;
				mb = Number(marginBottom);
				if (isNaN(mb))
					mb = 0;
				var yy:Number;
				if (i == 0)
					child.y = mt;
				else
					child.y = yy + Math.max(mt, lastmb);
				if (ilc)
				{
					if (!isNaN(ilc.percentHeight))
						ilc.setHeight(contentView.height * ilc.percentHeight / 100, !isNaN(ilc.percentWidth));
				}
				lastmb = mb;
				var marginObject:Object = {};
				flexibleHorizontalMargins[i] = marginObject;
				if (marginLeft == "auto")
				{
					ml = 0;
					marginObject.marginLeft = marginLeft;
					hasHorizontalFlex = true;
				}
				else
				{
					ml = Number(marginLeft);
					if (isNaN(ml))
					{
						ml = 0;
						marginObject.marginLeft = marginLeft;
					}
					else
						marginObject.marginLeft = ml;
				}
				if (marginRight == "auto")
				{
					mr = 0;
					marginObject.marginRight = marginRight;
					hasHorizontalFlex = true;
				}
				else
				{
					mr = Number(marginRight);
					if (isNaN(mr))
					{
						mr = 0;
						marginObject.marginRight = marginRight;
					}
					else
						marginObject.marginRight = mr;
				}
				if (!hostSizedToContent)
				{
					// if host is sized by parent,
					// we can position and size children horizontally now
					setPositionAndWidth(child, left, ml, right, mr, w);
				}
				else
				{
					if (!isNaN(left))
					{
						ml = left;
						marginObject.left = ml;
					}
					if (!isNaN(right))
					{
						mr = right;
						marginObject.right = mr;
					}
					maxWidth = Math.max(maxWidth, ml + child.width + mr);                    
				}
				yy = child.y + child.height;
			}
			if (hostSizedToContent)
			{
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					var obj:Object = flexibleHorizontalMargins[i];
					setPositionAndWidth(child, obj.left, obj.marginLeft,
						obj.right, obj.marginRight, maxWidth);
				}
			}
			if (hasHorizontalFlex)
			{
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					ilc = child as ILayoutChild;
					obj = flexibleHorizontalMargins[i];
					if (hasHorizontalFlex)
					{
						if (obj.marginLeft == "auto" && obj.marginRight == "auto")
							child.x = maxWidth - child.width / 2;
						else if (obj.marginLeft == "auto")
							child.x = maxWidth - child.width - obj.marginRight;
					}
				}
			}
			
			// Only return true if the contentView needs to be larger; that new
			// size is stored in the model.
			var sizeChanged:Boolean = false;
			if (viewportModel != null) {
				if (viewportModel.contentHeight != yy) {
					viewportModel.contentHeight = yy;
					sizeChanged = true;
				}
				if (viewportModel.contentWidth != maxWidth) {
					viewportModel.contentWidth = maxWidth;
					sizeChanged = true;
				}
			}
			
			host.dispatchEvent( new Event("layoutComplete") );

			return sizeChanged;
		}
		
		private function setPositionAndWidth(child:IUIBase, left:Number, ml:Number,
											 right:Number, mr:Number, w:Number):void
		{
			var widthSet:Boolean = false;
			
			var ww:Number = w;
			var ilc:ILayoutChild = child as ILayoutChild;
			if (!isNaN(left))
			{
				child.x = left + ml;
				ww -= left + ml;
			}
			else 
			{
				child.x = ml;
				ww -= ml;
			}
			if (!isNaN(right))
			{
				if (!isNaN(left))
				{
					if (ilc)
						ilc.setWidth(ww - right - mr, true);
					else
					{
						child.width = ww - right - mr;
						widthSet = true;
					}
				}
				else
					child.x = w - right - mr - child.width;
			}
			if (ilc)
			{
				if (!isNaN(ilc.percentWidth))
					ilc.setWidth(w * ilc.percentWidth / 100, true);
				else
					ilc.setWidth(w, true);
			}
			if (!widthSet)
				child.dispatchEvent(new Event("sizeChanged"));
		}
		
	}
}
