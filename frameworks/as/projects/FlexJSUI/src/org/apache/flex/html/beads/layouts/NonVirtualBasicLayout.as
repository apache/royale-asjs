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
            IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
			IEventDispatcher(value).addEventListener("beadsAdded", changeHandler);
		}
	
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(_strand);
			
            var w:Number = contentView.width;
            var h:Number = contentView.height;
			var n:int = contentView.numElements;
			for (var i:int = 0; i < n; i++)
			{
				var child:ILayoutChild = contentView.getElementAt(i) as ILayoutChild;
                var left:Number = ValuesManager.valuesImpl.getValue(child, "left");
                var right:Number = ValuesManager.valuesImpl.getValue(child, "right");
                var top:Number = ValuesManager.valuesImpl.getValue(child, "top");
                var bottom:Number = ValuesManager.valuesImpl.getValue(child, "bottom");
                
                if (!isNaN(left))
                {
                    child.x = left;
                }
                if (!isNaN(top))
                {
                    child.y = top;
                }
                var ilc:ILayoutChild;
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(contentView.height * ilc.percentHeight / 100);
                }
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentWidth))
                        ilc.setWidth(contentView.width * ilc.percentWidth / 100);
                }
                if (!isNaN(right))
                {
                    if (!isNaN(left))
                        child.width = w - right - left;
                    else
                        child.x = w - right - child.width;
                }
                if (!isNaN(bottom))
                {
                    if (!isNaN(top))
                        child.height = h - bottom - top;
                    else
                        child.y = h - bottom - child.height;
                }
			}
		}
	}
}
