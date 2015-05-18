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
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

    /**
     *  The OneFlexibleChildHorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and padding styles. But it
     *  will size the one child to take up as much or little
     *  room as possible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class OneFlexibleChildHorizontalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function OneFlexibleChildHorizontalLayout()
		{
		}
		
        
        /**
         *  The flexible child
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var flexibleChild:IUIBase;
        
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
         */
		public function layout():Boolean
		{
            var layoutParent:ILayoutParent = host.getBeadByType(ILayoutParent) as ILayoutParent;
            var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
			
            var ilc:ILayoutChild;
			var n:int = contentView.numElements;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			var maxHeight:Number = 0;
			var verticalMargins:Array = new Array(n);
			
            var ww:Number = layoutParent.resizableView.width;
            var padding:Object = determinePadding();
            if (isNaN(padding.paddingRight))
                padding.paddingRight = 0;
            ww -= padding.paddingLeft + padding.paddingRight;
            var xx:int = padding.paddingLeft;
            var flexChildIndex:int;
            var ml:Number;
            var mr:Number;
            var mt:Number;
            var mb:Number;
            var lastmr:Number;
            var lastml:Number;
            var valign:Object;
            
            for (var i:int = 0; i < n; i++)
            {
                var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                if (child == flexibleChild)
                {
                    flexChildIndex = i;
                    break;
                }
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
                mt = Number(marginTop);
                if (isNaN(mt))
                    mt = 0;
                mb = Number(marginBottom);
                if (isNaN(mb))
                    mb = 0;
                if (marginLeft == "auto")
                    ml = 0;
                else
                {
                    ml = Number(marginLeft);
                    if (isNaN(ml))
                        ml = 0;
                }
                if (marginRight == "auto")
                    mr = 0;
                else
                {
                    mr = Number(marginRight);
                    if (isNaN(mr))
                        mr = 0;
                }
                child.y = mt;
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(contentView.height * ilc.percentHeight / 100, true);
                }
                maxHeight = Math.max(maxHeight, mt + child.height + mb);
                child.x = xx + ml;
                xx += child.width + ml + mr;
                lastmr = mr;
                valign = ValuesManager.valuesImpl.getValue(child, "vertical-align");
                verticalMargins[i] = { marginTop: mt, marginBottom: mb, valign: valign };
            }

            if (n > 0 && n > flexChildIndex)
            {
                for (i = n - 1; i > flexChildIndex; i--)
    			{
    				child = contentView.getElementAt(i) as IUIBase;
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
    				mt = Number(marginTop);
    				if (isNaN(mt))
    					mt = 0;
    				mb = Number(marginBottom);
    				if (isNaN(mb))
    					mb = 0;
    				if (marginLeft == "auto")
    					ml = 0;
    				else
    				{
    					ml = Number(marginLeft);
    					if (isNaN(ml))
    						ml = 0;
    				}
    				if (marginRight == "auto")
    					mr = 0;
    				else
    				{
    					mr = Number(marginRight);
    					if (isNaN(mr))
    						mr = 0;
    				}
                    child.y = mt;
                    if (child is ILayoutChild)
                    {
                        ilc = child as ILayoutChild;
                        if (!isNaN(ilc.percentHeight))
                            ilc.setHeight(contentView.height * ilc.percentHeight / 100, true);
                    }
                    maxHeight = Math.max(maxHeight, mt + child.height + mb);
                    child.x = ww - child.width - mr;
    				ww -= child.width + ml + mr;
    				lastml = ml;
                    valign = ValuesManager.valuesImpl.getValue(child, "vertical-align");
                    verticalMargins[i] = { marginTop: mt, marginBottom: mb, valign: valign };
    			}
            
                child = contentView.getElementAt(flexChildIndex) as IUIBase;
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
                mt = Number(marginTop);
                if (isNaN(mt))
                    mt = 0;
                mb = Number(marginBottom);
                if (isNaN(mb))
                    mb = 0;
                if (marginLeft == "auto")
                    ml = 0;
                else
                {
                    ml = Number(marginLeft);
                    if (isNaN(ml))
                        ml = 0;
                }
                if (marginRight == "auto")
                    mr = 0;
                else
                {
                    mr = Number(marginRight);
                    if (isNaN(mr))
                        mr = 0;
                }
                child.y = mt;
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(contentView.height * ilc.percentHeight / 100, true);
                }
                maxHeight = Math.max(maxHeight, mt + child.height + mb);
                child.x = xx + ml;
                child.width = ww - xx - mr;
                valign = ValuesManager.valuesImpl.getValue(child, "vertical-align");
                verticalMargins[flexChildIndex] = { marginTop: mt, marginBottom: mb, valign: valign };
            }
            
            for (i = 0; i < n; i++)
			{
				var obj:Object = verticalMargins[0]
				child = contentView.getElementAt(i) as IUIBase;
				if (obj.valign == "center")
					child.y = (maxHeight - child.height) / 2;
				else if (obj.valign == "right")
					child.y = maxHeight - child.height - obj.marginBottom;
				else
					child.y = obj.marginTop;
			}
            return true;
		}

        // TODO (aharui): utility class or base class
        /**
         *  Determines the top and left padding values, if any, as set by
         *  padding style values. This includes "padding" for all padding values
         *  as well as "padding-left" and "padding-top".
         * 
         *  Returns an object with paddingLeft and paddingTop properties.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected function determinePadding():Object
        {
            var paddingLeft:Object;
            var paddingTop:Object;
            var paddingRight:Object;
            var padding:Object = ValuesManager.valuesImpl.getValue(host, "padding");
            if (typeof(padding) == "Array")
            {
                if (padding.length == 1)
                    paddingLeft = paddingTop = paddingRight = padding[0];
                else if (padding.length <= 3)
                {
                    paddingLeft = padding[1];
                    paddingTop = padding[0];
                    paddingRight = padding[1];
                }
                else if (padding.length == 4)
                {
                    paddingLeft = padding[3];
                    paddingTop = padding[0];					
                    paddingRight = padding[1];
                }
            }
            else if (padding == null)
            {
                paddingLeft = ValuesManager.valuesImpl.getValue(host, "padding-left");
                paddingTop = ValuesManager.valuesImpl.getValue(host, "padding-top");
                paddingRight = ValuesManager.valuesImpl.getValue(host, "padding-right");
            }
            else
            {
                paddingLeft = paddingTop = paddingRight = padding;
            }
            var pl:Number = Number(paddingLeft);
            var pt:Number = Number(paddingTop);
            var pr:Number = Number(paddingRight);
            if (isNaN(pl))
                pl = 0;
            if (isNaN(pr))
                pr = 0;
            if (isNaN(pt))
                pt = 0;
            return {paddingLeft:pl, paddingTop:pt, paddingRight:pr};
        }

    }
        
}
