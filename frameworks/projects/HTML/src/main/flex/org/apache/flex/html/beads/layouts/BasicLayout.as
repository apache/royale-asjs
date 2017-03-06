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
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.utils.CSSUtils;

    /**
     *  The BasicLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  as specified by CSS properties like left, right, top
     *  and bottom.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class BasicLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function BasicLayout()
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
         * @copy org.apache.flex.core.IBeadLayout#layout
		 * @flexjsignorecoercion org.apache.flex.core.ILayoutHost
		 * @flexjsignorecoercion org.apache.flex.core.UIBase
         */
		public function layout():Boolean
		{
            COMPILE::SWF
            {
				var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
				var contentView:IParentIUIBase = viewBead.contentView;
				
				var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
				var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
				
				var w:Number = hostWidthSizedToContent ? 0 : contentView.width;
				var h:Number = hostHeightSizedToContent ? 0 : contentView.height;
				
				var n:int = contentView.numElements;
                
                var gotMargin:Boolean;
                var marginLeft:Object;
                var marginRight:Object;
                var marginTop:Object;
                var marginBottom:Object;
                var margin:Object;
				
                for (var i:int = 0; i < n; i++)
                {
                    var child:IUIBase = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
					
                    var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
                    var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
                    var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                    var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                    var ww:Number = w;
                    var hh:Number = h;
					
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
                    
                    var ilc:ILayoutChild = child as ILayoutChild;
					
					// set the top edge of the child
                    if (!isNaN(left))
                    {
                        if (ilc)
                            ilc.setX(left+ml);
                        else
                            child.x = left+ml;
                        ww -= left + ml;
                    }
					
					// set the left edge of the child
                    if (!isNaN(top))
                    {
                        if (ilc)
                            ilc.setY(top+mt);
                        else
                            child.y = top+mt;
                        hh -= top + mt;
                    }
					
					// set the right edge of the child
					if (!isNaN(right))
					{
						if (!hostWidthSizedToContent)
						{
							if (!isNaN(left))
							{
								if (ilc)
									ilc.setWidth(ww - right - mr, false);
								else
									child.width = ww - right - mr;
							}
							else
							{
								if (ilc)
									ilc.setX( w - right - mr - child.width - mr);
								else
									child.x = w - right - mr - child.width - mr;
							}
						}
					}
					else if (ilc != null && !isNaN(ilc.percentWidth) && !hostWidthSizedToContent)
					{
						ilc.setWidth((ww - mr - ml) * ilc.percentWidth/100, false);
					}
					
					// set the bottm edge of the child
					if (!isNaN(bottom))
					{
						if (!hostHeightSizedToContent)
						{
							if (!isNaN(top))
							{
								if (ilc)
									ilc.setHeight(hh - bottom - mb, false);
								else
									child.height = hh - bottom - mb;
							}
							else
							{
								if (ilc)
									ilc.setY( h - bottom - child.height - mb);
								else
									child.y = h - bottom - child.height - mb;
							}
						}
					} 
					else if (ilc != null && !isNaN(ilc.percentHeight) && !hostHeightSizedToContent)
					{
						ilc.setHeight((hh - mt - mb) * ilc.percentHeight/100, false);
					}
                }
                
                host.dispatchEvent( new Event("layoutComplete") );
                
                return true;
                
            }
			
            COMPILE::JS
            {
                var i:int
                var n:int;
                
                var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
                var contentView:IParentIUIBase = viewBead.contentView;

                n = contentView.numElements;
				
				// host must have either have position:absolute or position:relative
				if (host.element.style.position != "absolute" && host.element.style.position != "relative") {
					host.element.style.position = "relative";
				}
				
				// each child must have position:absolute for BasicLayout to work
				for (i=0; i < n; i++) {
					var child:UIBase = contentView.getElementAt(i) as UIBase;
					child.positioner.style.position = "absolute";
				}
				
				host.dispatchEvent( new Event("layoutComplete") );
                return true;
            }
		}
	}
}
