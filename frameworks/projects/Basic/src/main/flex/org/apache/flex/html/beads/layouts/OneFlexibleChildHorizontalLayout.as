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
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
    import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSUtils;
    import org.apache.flex.utils.CSSContainerUtils;

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
	public class OneFlexibleChildHorizontalLayout implements IOneFlexibleChildLayout, IDocument
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
		
        
        private var _flexibleChild:String;
        
        private var actualChild:ILayoutChild;
        
        // the strand/host container is also an ILayoutChild because
        // can have its size dictated by the host's parent which is
        // important to know for layout optimization
        private var host:ILayoutChild;
		
        /**
         *  @private
         *  The document.
         */
        private var document:Object;
        
        /**
         *  The id of the flexible child
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get flexibleChild():String
        {
            return _flexibleChild;
        }
        
        /**
         * @private
         */
        public function set flexibleChild(value:String):void
        {
            _flexibleChild = value;
        }
        
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
	
        private var _maxWidth:Number;
        
        /**
         *  @copy org.apache.flex.core.IBead#maxWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get maxWidth():Number
        {
            return _maxWidth;
        }
        
        /**
         *  @private 
         */
        public function set maxWidth(value:Number):void
        {
            _maxWidth = value;
        }
        
        private var _maxHeight:Number;
        
        /**
         *  @copy org.apache.flex.core.IBead#maxHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get maxHeight():Number
        {
            return _maxHeight;
        }
        
        /**
         *  @private 
         */
        public function set maxHeight(value:Number):void
        {
            _maxHeight = value;
        }
        
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{
            var layoutParent:ILayoutHost = (host as ILayoutParent).getLayoutHost();
            var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
            var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
            actualChild = document[flexibleChild];

            var ilc:ILayoutChild;
			var n:int = contentView.numElements;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			maxHeight = 0;
			var verticalMargins:Array = new Array(n);
			
            var ww:Number = contentView.width - padding.right;
            var hh:Number = contentView.height;
            var xx:int = padding.left;
            var flexChildIndex:int;
            var ml:Number;
            var mr:Number;
            var mt:Number;
            var mb:Number;
            var lastmr:Number;
            var lastml:Number;
            var valign:Object;
            var hostSizedToContent:Boolean = host.isHeightSizedToContent();
            
            for (var i:int = 0; i < n; i++)
            {
                var child:IUIBase = contentView.getElementAt(i) as IUIBase;
                if (child == null || !child.visible) continue;
                if (child == actualChild)
                {
                    flexChildIndex = i;
                    break;
                }
                margin = ValuesManager.valuesImpl.getValue(child, "margin");
                marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
                marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
                marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
                marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
                mt = CSSUtils.getTopValue(marginTop, margin, hh);
                mb = CSSUtils.getBottomValue(marginBottom, margin, hh);
                mr = CSSUtils.getRightValue(marginRight, margin, ww);
                ml = CSSUtils.getLeftValue(marginLeft, margin, ww);
                child.y = mt + padding.top;
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
                    if (child == null || !child.visible) continue;
    				margin = ValuesManager.valuesImpl.getValue(child, "margin");
					marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
					marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
					marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
					marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
    				mt = CSSUtils.getTopValue(marginTop, margin, hh);
    				mb = CSSUtils.getTopValue(marginBottom, margin, hh);
                    mr = CSSUtils.getRightValue(marginRight, margin, ww);
                    ml = CSSUtils.getLeftValue(marginLeft, margin, ww);
                    child.y = mt + padding.top;
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
                marginLeft = ValuesManager.valuesImpl.getValue(child, "margin-left");
                marginTop = ValuesManager.valuesImpl.getValue(child, "margin-top");
                marginRight = ValuesManager.valuesImpl.getValue(child, "margin-right");
                marginBottom = ValuesManager.valuesImpl.getValue(child, "margin-bottom");
                mt = CSSUtils.getTopValue(marginTop, margin, hh);
                mb = CSSUtils.getTopValue(marginBottom, margin, hh);
                mr = CSSUtils.getRightValue(marginRight, margin, ww);
                ml = CSSUtils.getLeftValue(marginLeft, margin, ww);
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(contentView.height * ilc.percentHeight / 100, true);
                }
                child.x = xx + ml;
                child.width = ww - child.x;
                maxHeight = Math.max(maxHeight, mt + child.height + mb);
                valign = ValuesManager.valuesImpl.getValue(child, "vertical-align");
                verticalMargins[flexChildIndex] = { marginTop: mt, marginBottom: mb, valign: valign };
            }
            if (hostSizedToContent)
                ILayoutChild(contentView).setHeight(maxHeight + padding.top + padding.bottom, true);
            
            for (i = 0; i < n; i++)
			{
				var obj:Object = verticalMargins[i]
				child = contentView.getElementAt(i) as IUIBase;
                setPositionAndHeight(child, obj.top, obj.marginTop, padding.top,
                    obj.bottom, obj.marginBottom, padding.bottom, maxHeight, obj.valign);
			}
            return true;
		}

        private function setPositionAndHeight(child:IUIBase, top:Number, mt:Number, pt:Number,
                                              bottom:Number, mb:Number, pb:Number, h:Number, valign:String):void
        {
            var heightSet:Boolean = false; // if we've set the height in a way that gens a change event
            var ySet:Boolean = false; // if we've set the y yet.
            
            var hh:Number = h;
            var ilc:ILayoutChild = child as ILayoutChild;
            if (!isNaN(top))
            {
                child.y = top + mt;
                ySet = true;
                hh -= top + mt;
            }
            else 
            {
                hh -= mt;
            }
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
                else
                {
                    child.y = h - bottom - mb - child.height - 1; // some browsers don't like going to the edge
                    ySet = true;
                }
            }
            if (ilc)
            {
                if (!isNaN(ilc.percentHeight))
                    ilc.setHeight(h * ilc.percentHeight / 100, true);
            }
            if (valign == "middle")
                child.y = (h - child.height) / 2;
            else if (valign == "bottom")
                child.y = h - child.height - mb;
            else
                child.y = mt + pt;
            if (!heightSet)
                child.dispatchEvent(new Event("sizeChanged"));
        }
        
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;	
        }
    }
        
}
