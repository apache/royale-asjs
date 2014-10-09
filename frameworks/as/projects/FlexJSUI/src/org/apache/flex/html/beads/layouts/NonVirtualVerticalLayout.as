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

    /**
     *  The NonVirtualVerticalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  vertically in one column, separating them according to
     *  CSS layout rules for margin and horizontal-align styles.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class NonVirtualVerticalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function NonVirtualVerticalLayout()
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
			IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
			IEventDispatcher(value).addEventListener("beadsAdded", changeHandler);
		}
	
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(_strand);
			
			var n:int = contentView.numElements;
			var hasHorizontalFlex:Boolean;
			var flexibleHorizontalMargins:Array = [];
            var ilc:ILayoutChild;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			var maxWidth:Number = 0;
			for (var i:int = 0; i < n; i++)
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
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(contentView.height * ilc.percentHeight / 100);
                }
				yy = child.y + child.height;
				lastmb = mb;
				flexibleHorizontalMargins[i] = {};
				if (marginLeft == "auto")
				{
					ml = 0;
					flexibleHorizontalMargins[i].marginLeft = marginLeft;
					hasHorizontalFlex = true;
				}
				else
				{
					ml = Number(marginLeft);
					if (isNaN(ml))
					{
						ml = 0;
						flexibleHorizontalMargins[i].marginLeft = marginLeft;
					}
					else
						flexibleHorizontalMargins[i].marginLeft = ml;
				}
				if (marginRight == "auto")
				{
					mr = 0;
					flexibleHorizontalMargins[i].marginRight = marginRight;
					hasHorizontalFlex = true;
				}
				else
				{
					mr = Number(marginRight);
					if (isNaN(mr))
					{
						mr = 0;
						flexibleHorizontalMargins[i].marginRight = marginRight;
					}
					else
						flexibleHorizontalMargins[i].marginRight = mr;
				}
				child.x = ml;
				maxWidth = Math.max(maxWidth, ml + child.width + mr);
			}
			if (hasHorizontalFlex)
			{
				for (i = 0; i < n; i++)
				{
					child = contentView.getElementAt(i) as IUIBase;
                    if (child is ILayoutChild)
                    {
                        ilc = child as ILayoutChild;
                        if (!isNaN(ilc.percentWidth))
                            ilc.setWidth(contentView.width * ilc.percentWidth / 100);
                    }
					var obj:Object = flexibleHorizontalMargins[i];
					if (obj.marginLeft == "auto" && obj.marginRight == "auto")
						child.x = maxWidth - child.width / 2;
					else if (obj.marginLeft == "auto")
						child.x = maxWidth - child.width - obj.marginRight;
				}
			}
		}
	}
}
