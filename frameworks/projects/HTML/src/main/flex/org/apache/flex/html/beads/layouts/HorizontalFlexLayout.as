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
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	
	COMPILE::SWF {
		import org.apache.flex.core.UIBase;
		import org.apache.flex.core.IUIBase;
		import org.apache.flex.core.IParentIUIBase;
		import org.apache.flex.core.ValuesManager;
		import org.apache.flex.events.Event;
		import org.apache.flex.events.IEventDispatcher;
		import org.apache.flex.geom.Rectangle;
		import org.apache.flex.utils.CSSUtils;
		import org.apache.flex.utils.CSSContainerUtils;
	}
	
	public class HorizontalFlexLayout extends HorizontalLayout
	{
		public function HorizontalFlexLayout()
		{
			super();
		}
		
		// the strand/host container is also an ILayoutChild because
		// can have its size dictated by the host's parent which is
		// important to know for layout optimization
		private var host:ILayoutChild;
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			host = value as ILayoutChild;
		}
		
		/**
		 * @copy org.apache.flex.core.IBeadLayout#layout
		 * @flexjsignorecoercion org.apache.flex.core.ILayoutHost
		 */
		override public function layout():Boolean
		{
			COMPILE::SWF {
				//return super.layout();
				// this is where the layout is calculated
				var layoutParent:ILayoutHost = (host as ILayoutParent).getLayoutHost(); 
				var contentView:IParentIUIBase = layoutParent.contentView;
				
				var n:Number = contentView.numElements;
				if (n == 0) return false;
				
				trace("HorizontalFlexLayout: contentView size: "+contentView.width+" x "+contentView.height+"; explicit: "+UIBase(contentView).explicitWidth+" x "+UIBase(contentView).explicitHeight);
				
				var spacing:String = "none";
				
				var maxWidth:Number = 0;
				var maxHeight:Number = 0;
				var childData:Array = [];
				
				var ilc:ILayoutChild;
				var data:Object;
				var canAdjust:Boolean = false;
				var marginLeft:Object;
				var marginRight:Object;
				var marginTop:Object;
				var marginBottom:Object;
				var margin:Object;
				
				// First pass determines the data about the child.
				for(var i:int=0; i < n; i++)
				{
					var child:IUIBase = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) {
						childData.push({width:0, height:0, mt:0, ml:0, mr:0, mb:0, canAdjust:false});
						continue;
					}
					
					ilc = child as ILayoutChild;
					
					var useWidth:Number = -1;
					if (ilc) {
						if (!isNaN(ilc.explicitWidth)) useWidth = ilc.explicitWidth;
						else if (!isNaN(ilc.percentWidth)) useWidth = contentView.width * (ilc.percentWidth/100.0);
						else canAdjust = true;
					}
					
					var useHeight:Number = -1;
					if (ilc) {
						if (!isNaN(ilc.explicitHeight)) useHeight = ilc.explicitHeight;
						else if (!isNaN(ilc.percentHeight)) useHeight = contentView.height * (ilc.percentHeight/100.0);
						else useHeight = contentView.height;
					}
					
					margin = ValuesManager.valuesImpl.getValue(child, "margin");
					marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
					marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
					marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
					marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
					var ml:Number = CSSUtils.getLeftValue(marginLeft, margin, contentView.width);
					var mr:Number = CSSUtils.getRightValue(marginRight, margin, contentView.width);
					var mt:Number = CSSUtils.getTopValue(marginTop, margin, contentView.height);
					var mb:Number = CSSUtils.getBottomValue(marginBottom, margin, contentView.height);
					if (marginLeft == "auto")
						ml = 0;
					if (marginRight == "auto")
						mr = 0;
					
					if (maxWidth < useWidth) maxWidth = useWidth;
					if (maxHeight < useHeight) maxHeight = useHeight;
					
					childData.push({width:useWidth, height:useHeight, mt:mt, ml:ml, mr:mr, mb:mb, canAdjust:canAdjust});
				}
				
				var xpos:Number = 0;
				var ypos:Number = 0;
				
				// Second pass sizes and positions the children based on the data gathered.
				for(i=0; i < n; i++)
				{
					child = contentView.getElementAt(i) as IUIBase;
					data = childData[i];
					if (data.width == 0 || data.height == 0) continue;
					
					useWidth = (data.width < 0 ? maxWidth : data.width);
					useHeight = (data.height < 0 ? maxHeight : data.height);
					
					ilc = child as ILayoutChild;
					if (ilc) {
						ilc.setX(xpos + data.ml);
						ilc.setY(ypos + data.mt);
						ilc.setHeight(useHeight - data.mt - data.mb);
						if (data.width > 0) {
							ilc.setWidth(useWidth - data.ml - data.mr);
						}
					} else {
						child.x = xpos + data.ml;
						child.y = ypos + data.mt;
						child.height = useHeight - data.mt - data.b;
						if (data.width > 0) {
							child.width = useWidth - data.mr - data.ml;
						}
					}
					
					xpos += child.width + data.ml + data.mr;
					
					trace("HorizontalFlexLayout: setting child "+i+" to "+child.width+" x "+child.height+" at "+child.x+", "+child.y);
				}
				
				IEventDispatcher(host).dispatchEvent( new Event("layoutComplete") );
				
				trace("HorizontalFlexLayout: complete");
				
				return true;
			}
				
			COMPILE::JS {
				var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
				
				// set the display on the contentView
				viewBead.contentView.width = host.width;
				viewBead.contentView.element.style["display"] = "flex";
				viewBead.contentView.element.style["flex-flow"] = "row";
				
				return true;
			}
		}
	}
}