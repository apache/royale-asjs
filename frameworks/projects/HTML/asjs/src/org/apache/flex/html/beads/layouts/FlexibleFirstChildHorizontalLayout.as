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
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

    /**
     *  The FlexibleFirstChildHorizontalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  horizontally in one row, separating them according to
     *  CSS layout rules for margin and padding styles. But it
     *  will size the first child to take up as much or little
     *  room as possible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class FlexibleFirstChildHorizontalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function FlexibleFirstChildHorizontalLayout()
		{
		}
		
		private var _strand:IStrand;
		
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
			_strand = value;
            IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
			IEventDispatcher(value).addEventListener("sizeChanged", changeHandler);
		}
	
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParent = layoutParent.contentView;
			
			var n:int = contentView.numElements;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			var maxHeight:Number = 0;
			var verticalMargins:Array = [];
			
            var xx:Number = layoutParent.resizableView.width;
            if (isNaN(xx) || xx <= 0)
                return;
            var padding:Object = determinePadding();
            // some browsers don't like it when you go all the way to the right edge.
            xx -= padding.paddingLeft + padding.paddingRight + 1;
            
            for (var i:int = n - 1; i >= 0; i--)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
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
				var lastmr:Number;
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
				maxHeight = Math.max(maxHeight, mt + child.clientHeight + mb);
				if (i == 0)
                {
                    child.x = ml;
                    child.width = xx - mr;
                }
				else
                    child.x = xx - child.clientWidth - mr;
				xx -= child.clientWidth + mr + ml;
				lastmr = mr;
				var valign:Object = ValuesManager.valuesImpl.getValue(child, "vertical-align");
				verticalMargins.push({ marginTop: mt, marginBottom: mb, valign: valign });
			}
			for (i = 0; i < n; i++)
			{
				var obj:Object = verticalMargins[0]
				child = contentView.getElementAt(i) as IUIBase;
				if (obj.valign == "middle")
					child.y = (maxHeight - child.clientHeight) / 2;
				else if (valign == "bottom")
					child.y = maxHeight - child.clientHeight - obj.marginBottom;
				else
					child.y = obj.marginTop;
			}
            layoutParent.resizableView.height = maxHeight;
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
            var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding");
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
                paddingLeft = ValuesManager.valuesImpl.getValue(_strand, "padding-left");
                paddingTop = ValuesManager.valuesImpl.getValue(_strand, "padding-top");
                paddingRight = ValuesManager.valuesImpl.getValue(_strand, "padding-right");
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
            if (isNaN(pt))
                pt = 0;
            if (isNaN(pr))
                pr = 0;
            return {paddingLeft:pl, paddingTop:pt, paddingRight:pr};
        }

    }
        
}
