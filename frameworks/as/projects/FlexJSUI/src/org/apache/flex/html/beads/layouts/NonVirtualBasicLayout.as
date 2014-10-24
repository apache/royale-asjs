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
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.utils.dbg.DOMPathUtil;

    /**
     *  The NonVirtualBasicLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  as specified by CSS properties like left, right, top
     *  and bottom.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class NonVirtualBasicLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function NonVirtualBasicLayout()
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
            
            // if host is going to be sized by its parent, then don't
            // run layout when the children are added until after the
            // initial sizing by the parent.
            if (host.isWidthSizedToContent() && host.isHeightSizedToContent())
            {
                host.addEventListener("childrenAdded", changeHandler);
                host.addEventListener("layoutNeeded", changeHandler);
                host.addEventListener("itemsCreated", changeHandler);
            }
            else
            {
                host.addEventListener("heightChanged", changeHandler);
                host.addEventListener("widthChanged", changeHandler);
                host.addEventListener("sizeChanged", sizeChangeHandler);
                if (!isNaN(host.explicitWidth) && !isNaN(host.explicitHeight))
                    sizeChangeHandler(null);
            }
		}
	
        private function sizeChangeHandler(event:Event):void
        {
            host.addEventListener("childrenAdded", changeHandler);
            host.addEventListener("layoutNeeded", changeHandler);
            host.addEventListener("itemsCreated", changeHandler);
            changeHandler(event);
        }
        
		private function changeHandler(event:Event):void
		{
            //trace(DOMPathUtil.getPath(host), event ? event.type : "fixed size");
			var layoutParent:ILayoutParent = host.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
			
            var w:Number = contentView.width;
            var h:Number = contentView.height;
			var n:int = contentView.numElements;
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
                var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
                var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                var ww:Number = w;
                var hh:Number = h;
                
                if (!isNaN(left))
                {
                    child.x = left;
                    ww -= left;
                }
                if (!isNaN(top))
                {
                    child.y = top;
                    hh -= top;
                }
                var ilc:ILayoutChild = child as ILayoutChild;
                if (ilc)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentWidth))
                        ilc.setWidth((ww - (isNaN(right) ? 0 : right)) * ilc.percentWidth / 100, true);
                }
                if (!isNaN(right))
                {
                    if (!isNaN(left))
                    {
                        if (ilc)
                            ilc.setWidth(ww - right);
                        else
                            child.width = ww - right;
                    }
                    else
                        child.x = w - right - child.width;
                }
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight((hh - (isNaN(bottom) ? 0 : bottom)) * ilc.percentHeight / 100, true);
                }
                if (!isNaN(bottom))
                {
                    if (!isNaN(top))
                    {
                        if (ilc)
                            ilc.setHeight(hh - bottom);
                        else
                            child.height = hh - bottom;
                    }
                    else
                        child.y = h - bottom - child.height;
                }
                child.dispatchEvent(new Event("sizeChanged"));
			}
		}
	}
}
