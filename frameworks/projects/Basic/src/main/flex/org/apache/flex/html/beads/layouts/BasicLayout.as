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
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.utils.CSSUtils;
	//import org.apache.flex.utils.dbg.DOMPathUtil;

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
                //trace(DOMPathUtil.getPath(host), event ? event.type : "fixed size");
                var layoutParent:ILayoutHost = host.getBeadByType(ILayoutHost) as ILayoutHost;
                var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
                
                var gotMargin:Boolean;
                var marginLeft:Object;
                var marginRight:Object;
                var marginTop:Object;
                var marginBottom:Object;
                var margin:Object;
                var ml:Number;
                var mr:Number;
                var mt:Number;
                var mb:Number;
                var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
                var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
                var w:Number = hostWidthSizedToContent ? 0 : contentView.width;
                var h:Number = hostHeightSizedToContent ? 0 : contentView.height;
                var n:int = contentView.numElements;
                var maxWidth:Number = 0;
                var maxHeight:Number = 0;
                var childData:Array = [];
                for (var i:int = 0; i < n; i++)
                {
                    var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                    var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
                    var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
                    var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                    var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                    var ww:Number = w;
                    var hh:Number = h;
                    
                    var ilc:ILayoutChild = child as ILayoutChild;
                    if (!isNaN(left))
                    {
                        if (ilc)
                            ilc.setX(left);
                        else
                            child.x = left;
                        ww -= left;
                    }
                    if (!isNaN(top))
                    {
                        if (ilc)
                            ilc.setY(top);
                        else
                            child.y = top;
                        hh -= top;
                    }
                    if (ilc)
                    {
                        if (!hostWidthSizedToContent)
                        {
                            if (!isNaN(ilc.percentWidth))
                                ilc.setWidth((ww - (isNaN(right) ? 0 : right)) * ilc.percentWidth / 100, true);
                        }
                        else
                            childData[i] = { bottom: bottom, right: right, ww: ww, ilc: ilc, child: child };
                    }
                    if (!isNaN(right))
                    {
                        if (!hostWidthSizedToContent)
                        {
                            if (!isNaN(left))
                            {
                                if (ilc)
                                    ilc.setWidth(ww - right, true);
                                else
                                    child.width = ww - right;
                            }
                            else
                            {
                                if (ilc)
                                    ilc.setX( w - right - child.width);
                                else
                                    child.x = w - right - child.width;
                            }
                        }
                        else
                            childData[i] = { ww: ww, left: left, right: right, ilc: ilc, child: child };
                    }
                    
                    if (isNaN(right) && isNaN(left))
                    {
                        margin = ValuesManager.valuesImpl.getValue(child, "margin");
                        gotMargin = true;
                        marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
                        marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
                        var horizontalCenter:Boolean = 
                            (marginLeft == "auto" && marginRight == "auto") ||
                            (margin is String && margin == "auto") ||
                            (margin is Array && 
                                ((margin.length < 4 && margin[1] == "auto") ||
                                    (margin.length == 4 && margin[1] == "auto" && margin[3] == "auto")));
                        if (!hostWidthSizedToContent)
                        {
                            if (!horizontalCenter)
                            {
                                mr = CSSUtils.getRightValue(marginRight, margin, ww);
                                ml = CSSUtils.getLeftValue(marginLeft, margin, ww);
                                if (ilc)
                                    ilc.setX(ml);
                                else
                                    child.x = ml;
                                if (ilc && isNaN(ilc.percentWidth) && isNaN(ilc.explicitWidth))
                                    child.width = ww - child.x - mr;
                            }
                            else
                            {
                                if (ilc)
                                    ilc.setX((ww - child.width) / 2);
                                else
                                    child.x = (ww - child.width) / 2;    
                            }
                        }
                        else 
                        {
                            if (!horizontalCenter)
                            {
                                mr = CSSUtils.getRightValue(marginRight, margin, ww);
                                ml = CSSUtils.getLeftValue(marginLeft, margin, ww);
                                if (ilc)
                                    ilc.setX(ml);
                                else
                                    child.x = ml;
                                if (ilc && isNaN(ilc.percentWidth) && isNaN(ilc.explicitWidth))
                                    childData[i] = { ww: ww, left: ml, right: mr, ilc: ilc, child: child };
                            }
                            else
                            {
                                childData[i] = { ww: ww, center: true, ilc: ilc, child: child };                            
                            }
                        }
                        
                    }
                    if (isNaN(top) && isNaN(bottom))
                    {
                        if (!gotMargin)
                            margin = ValuesManager.valuesImpl.getValue(child, "margin");
                        marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
                        marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
                        mt = CSSUtils.getTopValue(marginTop, margin, hh);
                        mb = CSSUtils.getBottomValue(marginBottom, margin, hh);
                        if (ilc)
                            ilc.setY(mt);
                        else
                            child.y = mt;
                        /* browsers don't use margin-bottom to stretch things vertically
                        if (!hostHeightSizedToContent)
                        {
                        if (ilc && isNaN(ilc.percentHeight) && isNaN(ilc.explicitHeight))
                        child.height = hh - child.y - mb;
                        }
                        else
                        {
                        if (!childData[i])
                        childData[i] = { hh: hh, bottom: mb, ilc: ilc, child: child };
                        else
                        {
                        childData[i].hh = hh;
                        childData[i].bottom = mb;
                        }
                        }
                        */
                    }
                    
                    if (ilc)
                    {
                        if (!hostHeightSizedToContent)
                        {
                            if (!isNaN(ilc.percentHeight))
                                ilc.setHeight((hh - (isNaN(bottom) ? 0 : bottom)) * ilc.percentHeight / 100, true);
                        }
                        else
                        {
                            if (!childData[i])
                                childData[i] = { hh: hh, bottom: bottom, ilc: ilc, child: child };
                            else
                            {
                                childData[i].hh = hh;
                                childData[i].bottom = bottom;
                            }
                        }
                    }
                    if (!isNaN(bottom))
                    {
                        if (!hostHeightSizedToContent)
                        {
                            if (!isNaN(top))
                            {
                                if (ilc)
                                    ilc.setHeight(hh - bottom, true);
                                else
                                    child.height = hh - bottom;
                            }
                            else
                            {
                                if (ilc)
                                    ilc.setY(h - bottom - child.height);
                                else
                                    child.y = h - bottom - child.height;
                            }
                        }
                        else
                        {
                            if (!childData[i])
                                childData[i] = { top: top, bottom: bottom, hh:hh, ilc: ilc, child: child };
                            else
                            {
                                childData[i].top = top;
                                childData[i].bottom = bottom;
                                childData[i].hh = hh;
                            }
                        }
                    }
                    if (!childData[i])
                        child.dispatchEvent(new Event("sizeChanged"));
                    maxWidth = Math.max(maxWidth, child.x + child.width);
                    maxHeight = Math.max(maxHeight, child.y + child.height);
                }
                if (hostHeightSizedToContent || hostWidthSizedToContent)
                {
                    for (i = 0; i < n; i++)
                    {
                        var data:Object = childData[i];
                        if (data)
                        {
                            if (hostWidthSizedToContent)
                            {
                                if (data.ilc && !isNaN(data.ilc.percentWidth))
                                    data.ilc.setWidth((data.ww - (isNaN(data.right) ? 0 : data.right)) * data.ilc.percentWidth / 100, true);
                                if (data.center)
                                {
                                    if (data.ilc)
                                        data.ilc.setX((data.ww - data.child.width) / 2);
                                    else
                                        data.child.x = (data.ww - data.child.width) / 2; 
                                }
                                else if (!isNaN(data.right))
                                {
                                    if (!isNaN(data.left))
                                    {
                                        if (data.ilc)
                                            data.ilc.setWidth(data.ww - data.right, true);
                                        else
                                            data.child.width = data.ww - data.right;
                                    }
                                    else
                                    {
                                        if (data.ilc)
                                            data.ilc.setX(maxWidth - data.right - data.child.width);
                                        else
                                            data.child.x = maxWidth - data.right - data.child.width;
                                    }
                                }
                            }
                            if (hostHeightSizedToContent)
                            {
                                if (data.ilc && !isNaN(data.ilc.percentHeight))
                                    data.ilc.setHeight((data.hh - (isNaN(data.bottom) ? 0 : data.bottom)) * data.ilc.percentHeight / 100, true);
                                if (!isNaN(data.bottom))
                                {
                                    if (!isNaN(data.top))
                                    {
                                        if (data.ilc)
                                            data.ilc.setHeight(data.hh - data.bottom, true);
                                        else
                                            data.child.height = data.hh - data.bottom;
                                    }
                                    else
                                    {
                                        if (data.ilc)
                                            data.ilc.setY(maxHeight - data.bottom - data.child.height);
                                        else
                                            data.child.y = maxHeight - data.bottom - data.child.height;
                                    }
                                }
                            }
                            child.dispatchEvent(new Event("sizeChanged"));
                        }
                    }
                }
                
                host.dispatchEvent( new Event("layoutComplete") );
                
                return true;
                
            }
            COMPILE::JS
            {
                var i:int
                var n:int;
                var h:Number;
                var w:Number;
                
                var viewBead:ILayoutHost = host.getBeadByType(ILayoutHost) as ILayoutHost;
                var contentView:IParentIUIBase = viewBead.contentView;
                w = contentView.width;
                var hasWidth:Boolean = !host.isWidthSizedToContent();
                h = contentView.height;
                var hasHeight:Boolean = !host.isHeightSizedToContent();
                var maxHeight:Number = 0;
                var maxWidth:Number = 0;
                n = contentView.numElements;
                for (i = 0; i < n; i++) {
                    var child:UIBase = contentView.getElementAt(i) as UIBase;
                    child.setDisplayStyleForLayout('block');
                    var left:Number = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'left');
                    var right:Number = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'right');
                    var top:Number = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'top');
                    var bottom:Number = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'bottom');
                    var margin:String = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'margin');
                    var marginLeft:String = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'margin-left');
                    var marginRight:String = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'margin-right');
                    var horizontalCenter:Boolean =
                        (marginLeft == 'auto' && marginRight == 'auto') ||
                        (typeof(margin) === 'string' && margin == 'auto') ||
                        (margin && margin.hasOwnProperty('length') &&
                            ((margin.length < 4 && margin[1] == 'auto') ||
                                (margin.length == 4 && margin[1] == 'auto' && margin[3] == 'auto')));
                    
                    if (!isNaN(left)) {
                        child.positioner.style.position = 'absolute';
                        child.positioner.style.left = left.toString() + 'px';
                    }
                    if (!isNaN(top)) {
                        child.positioner.style.position = 'absolute';
                        child.positioner.style.top = top.toString() + 'px';
                    }
                    if (!isNaN(right)) {
                        child.positioner.style.position = 'absolute';
                        child.positioner.style.right = right.toString() + 'px';
                    }
                    if (!isNaN(bottom)) {
                        child.positioner.style.position = 'absolute';
                        child.positioner.style.bottom = bottom.toString() + 'px';
                    }
                    if (horizontalCenter)
                    {
                        child.positioner.style.position = 'absolute';
                        child.positioner.style.left = ((w - child.width) / 2).toString() + 'px';
                    }
                    child.dispatchEvent('sizeChanged');
                    maxWidth = Math.max(maxWidth, child.positioner.offsetLeft + child.positioner.offsetWidth);
                    maxHeight = Math.max(maxHeight, child.positioner.offsetTop + child.positioner.offsetHeight);
                }
                // if there are children and maxHeight is ok, use it.
                // maxHeight can be NaN if the child hasn't been rendered yet.
                if (!hasWidth && n > 0 && !isNaN(maxWidth)) {
                    contentView.width = maxWidth;
                }
                if (!hasHeight && n > 0 && !isNaN(maxHeight)) {
                    contentView.height = maxHeight;
                }
                return true;
            }
		}
	}
}
