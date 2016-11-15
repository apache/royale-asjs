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
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;

    /**
     *  The OneFlexibleChildVerticalLayout class is a simple layout
     *  bead.  It takes the set of children and lays them out
     *  vertically in one column, separating them according to
     *  CSS layout rules for margin and padding styles. But it
     *  will size the one child to take up as much or little
     *  room as possible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class OneFlexibleChildVerticalLayout implements IOneFlexibleChildLayout, IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function OneFlexibleChildVerticalLayout()
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
        
		// TODO get rid of this
		private function getActualChildById(contentView:IParentIUIBase, id:String):ILayoutChild
		{
			var result:ILayoutChild;
			for (var i:int = 0; i < contentView.numElements; i++)
			{
				var child:UIBase = contentView.getElementAt(i) as UIBase;
				if (child.id == id)
				{
					return child;
				}
			}
			return null;
		}
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{
            var layoutParent:ILayoutHost = (host as ILayoutParent).getLayoutHost();
            var contentView:IParentIUIBase = layoutParent ? layoutParent.contentView : IParentIUIBase(host);
            var padding:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
			if (document && document.hasOwnProperty(flexibleChild))
			{
				actualChild = document[flexibleChild];
			} else
			{
				actualChild = getActualChildById(contentView, flexibleChild);
			}
            
            var ilc:ILayoutChild;
			var n:int = contentView.numElements;
			var marginLeft:Object;
			var marginRight:Object;
			var marginTop:Object;
			var marginBottom:Object;
			var margin:Object;
			maxWidth = 0;
            
            var w:Number = contentView.width;			
            var hh:Number = contentView.height - padding.bottom;
            var yy:int = padding.top;
            var flexChildIndex:int;
            var ml:Number;
            var mr:Number;
            var mt:Number;
            var mb:Number;
            var lastmb:Number;
            var lastmt:Number;
            var halign:Object;
            var left:Number;
            var right:Number;
            
            for (var i:int = 0; i < n; i++)
            {
                var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
                ilc = child as ILayoutChild;
                left = ValuesManager.valuesImpl.getValue(child, "left");
                right = ValuesManager.valuesImpl.getValue(child, "right");
                if (child == actualChild)
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
                if (ilc)
                {
                    if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(contentView.height * ilc.percentHeight / 100, !isNaN(ilc.percentWidth));
                }
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
                if (child is ILayoutChild)
                {
                    ilc = child as ILayoutChild;
                    if (!isNaN(ilc.percentWidth))
                        ilc.setWidth(contentView.width * ilc.percentWidth / 100, !isNaN(ilc.percentHeight));
                }
                maxWidth = Math.max(maxWidth, ml + child.width + mr);
                setPositionAndWidth(child, left, ml, padding.left, right, mr, padding.right, w);
                child.y = yy + mt;
                yy += child.height + mt + mb;
                lastmb = mb;
            }

            if (n > 0 && n > flexChildIndex)
            {
                for (i = n - 1; i > flexChildIndex; i--)
    			{
    				child = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;
                    ilc = child as ILayoutChild;
                    left = ValuesManager.valuesImpl.getValue(child, "left");
                    right = ValuesManager.valuesImpl.getValue(child, "right");
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
                    if (ilc)
                    {
                        if (!isNaN(ilc.percentHeight))
                            ilc.setHeight(contentView.height * ilc.percentHeight / 100, !isNaN(ilc.percentWidth));
                    }
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
                    if (child is ILayoutChild)
                    {
                        ilc = child as ILayoutChild;
                        if (!isNaN(ilc.percentWidth))
                            ilc.setWidth(contentView.width * ilc.percentWidth / 100, !isNaN(ilc.percentHeight));
                    }
                    setPositionAndWidth(child, left, ml, padding.left, right, mr, padding.right, w);
                    maxWidth = Math.max(maxWidth, ml + child.width + mr);
                    child.y = hh - child.height - mb;
    				hh -= child.height + mt + mb;
    				lastmt = mt;
    			}
            } 
            
            child = contentView.getElementAt(flexChildIndex) as IUIBase;
            ilc = child as ILayoutChild;
            left = ValuesManager.valuesImpl.getValue(child, "left");
            right = ValuesManager.valuesImpl.getValue(child, "right");
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
            if (ilc)
            {
                if (!isNaN(ilc.percentHeight))
                    ilc.setHeight(contentView.height * ilc.percentHeight / 100, !isNaN(ilc.percentWidth));
            }
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
            if (child is ILayoutChild)
            {
                ilc = child as ILayoutChild;
                if (!isNaN(ilc.percentWidth))
                    ilc.setWidth(contentView.width * ilc.percentWidth / 100, !isNaN(ilc.percentHeight));
            }
            setPositionAndWidth(child, left, ml, padding.left, right, mr, padding.right, w);
            maxWidth = Math.max(maxWidth, ml + child.width + mr);
            child.y = yy + mt;
            child.height = hh - mb - child.y;
            
            return true;
		}

        private function setPositionAndWidth(child:IUIBase, left:Number, ml:Number, pl:Number,
                                             right:Number, mr:Number, pr:Number, w:Number):void
        {
            var widthSet:Boolean = false;
            
            var ww:Number = w;
            var ilc:ILayoutChild = child as ILayoutChild;
            if (!isNaN(left))
            {
                child.x = left + ml;
                ww -= left + ml;
            }
            else 
            {
                if (isNaN(right))
                    child.x = ml + pl;
                ww -= ml;
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
                    child.x = w - right - mr - child.width - 1; // some browsers don't like going all the way to the edge
            }
            if (ilc)
            {
                if (!isNaN(ilc.percentWidth))
                    ilc.setWidth(w * ilc.percentWidth / 100, true);
            }
            if (!widthSet)
                child.dispatchEvent(new Event("sizeChanged"));
        }
        
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;	
        }
        
    }
        
}
