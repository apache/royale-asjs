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
	import org.apache.flex.core.ILayoutHost;
    import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	COMPILE::JS
	{
		import org.apache.flex.core.WrappedHTMLElement;			
	}
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;
	
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
		
		/**
		 *  Layout children vertically
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion org.apache.flex.core.ILayoutHost
		 */
		public function layout():Boolean
		{
			COMPILE::SWF
			{
                var layoutParent:ILayoutHost = (host as ILayoutParent).getLayoutHost();
				var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
				var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
				
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
				var cssValue:*;
				// asking for contentView.width can result in infinite loop if host isn't sized already
				var w:Number = hostSizedToContent ? 0 : contentView.width;
				var h:Number = contentView.height;
				
				for (var i:int = 0; i < n; i++)
				{
					var child:IUIBase = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					ilc = child as ILayoutChild;
					var left:Number = NaN;
					cssValue = ValuesManager.valuesImpl.getValue(child, "left");
					if (cssValue !== undefined)
						left = CSSUtils.toNumber(cssValue);
					var right:Number = NaN;
					cssValue = ValuesManager.valuesImpl.getValue(child, "right");
					if (cssValue !== undefined)
						right = CSSUtils.toNumber(cssValue);
					margin = ValuesManager.valuesImpl.getValue(child, "margin");
					marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
					marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
					marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
					marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
					var ml:Number = CSSUtils.getLeftValue(marginLeft, margin, w);
					var mr:Number = CSSUtils.getRightValue(marginRight, margin, w);
					var mt:Number = CSSUtils.getTopValue(marginTop, margin, h);
					var mb:Number = CSSUtils.getBottomValue(marginBottom, margin, h);
					var lastmb:Number;
					var yy:Number;
					if (i == 0)
					{
						if (ilc)
							ilc.setY(mt + padding.top);
						else
							child.y = mt + padding.top;
					}
					else
					{
						if (ilc)
							ilc.setY(yy + Math.max(mt, lastmb));
						else
							child.y = yy + Math.max(mt, lastmb);
					}
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
						setPositionAndWidth(child, left, ml, padding.left, 
							right, mr, padding.right, w);
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
						setPositionAndWidth(child, obj.left, obj.marginLeft, padding.left,
							obj.right, obj.marginRight, padding.right, maxWidth);
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
							if (ilc)
							{
								if (obj.marginLeft == "auto" && obj.marginRight == "auto")
									ilc.setX(maxWidth - child.width / 2);
								else if (obj.marginLeft == "auto")
									ilc.setX(maxWidth - child.width - obj.marginRight - padding.right);                            
							}
							else
							{
								if (obj.marginLeft == "auto" && obj.marginRight == "auto")
									child.x = maxWidth - child.width / 2;
								else if (obj.marginLeft == "auto")
									child.x = maxWidth - child.width - obj.marginRight - padding.right;
							}
						}
					}
				}
				
				// Only return true if the contentView needs to be larger; that new
				// size is stored in the model.
				var sizeChanged:Boolean = true;
				
				host.dispatchEvent( new Event("layoutComplete") );
				
				return sizeChanged;
				
			}
			COMPILE::JS
			{
				var children:Array;
				var i:int;
				var n:int;
				
                var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost()
				var contentView:IParentIUIBase = viewBead.contentView;
				children = contentView.internalChildren();
				var scv:Object = getComputedStyle(host.positioner);
				var hasWidth:Boolean = !host.isWidthSizedToContent();
				var maxWidth:Number = 0;
				n = children.length;
				for (i = 0; i < n; i++)
				{
					var child:WrappedHTMLElement = children[i];
					child.flexjs_wrapper.setDisplayStyleForLayout('block');
					if (child.style.display === 'none') 
					{
						child.flexjs_wrapper.setDisplayStyleForLayout('block');
					} 
					else 
					{
						// block elements don't measure width correctly so set to inline for a second
						child.style.display = 'inline-block';
						maxWidth = Math.max(maxWidth, child.offsetLeft + child.offsetWidth);
						child.style.display = 'block';
					}
					child.flexjs_wrapper.dispatchEvent('sizeChanged');
				}
				if (!hasWidth && n > 0 && !isNaN(maxWidth)) {
					var pl:String = scv['padding-left'];
					var pr:String = scv['padding-right'];
					var npl:int = parseInt(pl.substring(0, pl.length - 2), 10);
					var npr:int = parseInt(pr.substring(0, pr.length - 2), 10);
					maxWidth += npl + npr;
					contentView.width = maxWidth;
				}
				return true;
			}
		}
		
		COMPILE::SWF
		private function setPositionAndWidth(child:IUIBase, left:Number, ml:Number, pl:Number,
											 right:Number, mr:Number, pr:Number, w:Number):void
		{
			var widthSet:Boolean = false;
			
			var ww:Number = w;
			var ilc:ILayoutChild = child as ILayoutChild;
			if (!isNaN(left))
			{
                if (ilc)
                    ilc.setX(left + ml);
                else
    				child.x = left + ml;
				ww -= left + ml;
			}
			else 
			{
                if (ilc)
                    ilc.setX(ml + pl);
                else
    				child.x = ml + pl;
				ww -= ml + pl;
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
                {
                    if (ilc)
                        ilc.setX(w - right - mr - child.width);
                    else
    					child.x = w - right - mr - child.width;
                }
			}
			if (ilc)
			{
				if (!isNaN(ilc.percentWidth))
					ilc.setWidth(w * ilc.percentWidth / 100, true);
			}
			if (!widthSet)
				child.dispatchEvent(new Event("sizeChanged"));
		}
		
	}
}
