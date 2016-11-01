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
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

    /**
     *  The HorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and vertical-align styles.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HorizontalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HorizontalLayout()
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
            COMPILE::JS
            {
                (value as IUIBase).element.style.display = 'block';
            }
		}
	
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         * @flexjsignorecoercion org.apache.flex.core.ILayoutHost
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
		public function layout():Boolean
		{
            COMPILE::SWF
            {
                //trace(DOMPathUtil.getPath(host), event ? event.type : "fixed size");
                var layoutParent:ILayoutHost = (host as ILayoutParent).getLayoutHost(); //host.getBeadByType(ILayoutHost) as ILayoutHost;
                var contentView:IParentIUIBase = layoutParent.contentView;
                var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
                
                var n:int = contentView.numElements;
                var hostSizedToContent:Boolean = host.isHeightSizedToContent();
                var ilc:ILayoutChild;
                var marginLeft:Object;
                var marginRight:Object;
                var marginTop:Object;
                var marginBottom:Object;
                var margin:Object;
                var maxHeight:Number = 0;
                // asking for contentView.height can result in infinite loop if host isn't sized already
                var h:Number = hostSizedToContent ? 0 : contentView.height;
                var w:Number = contentView.width;
                var verticalMargins:Array = [];
                
                for (var i:int = 0; i < n; i++)
                {
                    var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                    if (child == null || !child.visible) continue;
                    var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                    var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                    margin = ValuesManager.valuesImpl.getValue(child, "margin");
                    marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
                    marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
                    marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
                    marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
                    var ml:Number = CSSUtils.getLeftValue(marginLeft, margin, w);
                    var mr:Number = CSSUtils.getRightValue(marginRight, margin, w);
                    var mt:Number = CSSUtils.getTopValue(marginTop, margin, h);
                    var mb:Number = CSSUtils.getBottomValue(marginBottom, margin, h);
                    
                    ilc = child as ILayoutChild;
                    var lastmr:Number;
                    if (marginLeft == "auto")
                        ml = 0;
                    if (marginRight == "auto")
                        mr = 0;
                    var xx:Number;
                    if (i == 0)
                    {
                        if (ilc)
                            ilc.setX(ml + padding.left);
                        else
                            child.x = ml + padding.left;
                    }
                    else
                    {
                        if (ilc)
                            ilc.setX(xx + ml + lastmr);
                        else
                            child.x = xx + ml + lastmr;
                    }
                    if (ilc)
                    {
                        if (!isNaN(ilc.percentWidth))
                            ilc.setWidth(contentView.width * ilc.percentWidth / 100, !isNaN(ilc.percentHeight));
                    }
                    lastmr = mr;
                    var marginObject:Object = {};
                    verticalMargins[i] = marginObject;
                    var valign:* = ValuesManager.valuesImpl.getValue(child, "vertical-align");
                    marginObject.valign = valign;
                    if (!hostSizedToContent)
                    {
                        // if host is sized by parent,
                        // we can position and size children horizontally now
                        setPositionAndHeight(child, top, mt, padding.top, bottom, mb, padding.bottom, h, valign);
                        maxHeight = Math.max(maxHeight, mt + child.height + mb);
                    }
                    else
                    {
                        if (!isNaN(top))
                        {
                            mt = top;
                            marginObject.top = mt;
                        }
                        if (!isNaN(bottom))
                        {
                            mb = bottom;
                            marginObject.bottom = mb;
                        }
                        maxHeight = Math.max(maxHeight, mt + child.height + mb);
                    }
                    xx = child.x + child.width;
                }
                if (hostSizedToContent)
                {
                    ILayoutChild(contentView).setHeight(maxHeight, true);
                    if (host.isWidthSizedToContent())
                        ILayoutChild(contentView).setWidth(xx, true);
                    for (i = 0; i < n; i++)
                    {
                        child = contentView.getElementAt(i) as IUIBase;
                        if (child == null || !child.visible) continue;
                        var obj:Object = verticalMargins[i];
                        setPositionAndHeight(child, obj.top, obj.marginTop, padding.top,
                            obj.bottom, obj.marginBottom, padding.bottom, maxHeight, obj.valign);
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
                
                var viewBead:ILayoutHost = (host as ILayoutParent).getLayoutHost();
                var contentView:IParentIUIBase = viewBead.contentView;
                children = contentView.internalChildren();
                var hasHeight:Boolean = !host.isHeightSizedToContent();
                var hasWidth:Boolean = !host.isWidthSizedToContent();
                var maxHeight:Number = 0;
                var computedWidth:Number = 0;
                n = children.length;
                for (i = 0; i < n; i++)
                {
                    var child:WrappedHTMLElement = children[i] as WrappedHTMLElement;
					if (child == null) continue;
                    child.flexjs_wrapper.internalDisplay = 'inline-block';
                    if (child.style.display == 'none')
                        child.flexjs_wrapper.setDisplayStyleForLayout('inline-block');
                    else
                        child.style.display = 'inline-block';
                    maxHeight = Math.max(maxHeight, child.offsetHeight);
                    if (!hasWidth) {
                        var cv:Object = getComputedStyle(child);
                        var mls:String = cv['margin-left'];
                        var ml:Number = Number(mls.substring(0, mls.length - 2));
                        var mrs:String = cv['margin-right'];
                        var mr:Number = Number(mrs.substring(0, mrs.length - 2));
                        computedWidth += ml + child.offsetWidth + mr;
                    }
                    child.flexjs_wrapper.dispatchEvent('sizeChanged');
                }
                // if there are children and maxHeight is ok, use it.
                // maxHeight can be NaN if the child hasn't been rendered yet.
                if (!hasHeight && n > 0 && !isNaN(maxHeight)) {
                    contentView.height = maxHeight;
                }
                if (!hasWidth && n > 0 && !isNaN(computedWidth)) {
                    contentView.width = computedWidth + 1; // some browser need one more pixel
                }
                return true;
            }
		}
        
        COMPILE::SWF
        private function setPositionAndHeight(child:IUIBase, top:Number, mt:Number, pt:Number,
                                             bottom:Number, mb:Number, pb:Number, h:Number,
                                             valign:*):void
        {
            var heightSet:Boolean = false;
            
            var hh:Number = h;
            var ilc:ILayoutChild = child as ILayoutChild;
            if (ilc)
            {
                if (!isNaN(ilc.percentHeight))
                    ilc.setHeight(h * ilc.percentHeight / 100, true);
            }
            if (valign == "top")
            {
                if (!isNaN(top))
                {
                    if (ilc)
                        ilc.setY(top + mt);
                    else
                        child.y = top + mt;
                    hh -= top + mt;
                }
                else 
                {
                    if (ilc)
                        ilc.setY(mt + pt);
                    else
                        child.y = mt + pt;
                    hh -= mt + pt;
                }
                if (ilc.isHeightSizedToContent())
                {
                    if (!isNaN(bottom))
                    {
                        if (!isNaN(top))
                        {
                            if (ilc)
                                ilc.setHeight(hh - bottom - mb, true);
                            else 
                            {
                                child.height = hh - bottom - mb;
                                heightSet = true;
                            }
                        }
                    }
                }
            }
            else if (valign == "bottom")
            {
                if (!isNaN(bottom))
                {
                    if (ilc)
                        ilc.setY(h - bottom - mb - child.height);
                    else
                        child.y = h - bottom - mb - child.height;
                }
                else
                {
                    if (ilc)
                        ilc.setY(h - mb - child.height);
                    else
                        child.y = h - mb - child.height;
                }
            }
            else
                child.y = (h - child.height) / 2;                    
            if (!heightSet)
                child.dispatchEvent(new Event("sizeChanged"));
        }
	}
}
