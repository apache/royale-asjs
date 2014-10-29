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
package org.apache.flex.html.beads
{
	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IScrollingLayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.Event;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.ContainerContentArea;
	import org.apache.flex.html.supportClasses.ScrollBar;
	
    /**
     *  The ContainerView class is the default view for
     *  the org.apache.flex.html.Container class.
     *  It lets you use some CSS styles to manage the border, background
     *  and padding around the content area.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ScrollingContainerView extends BeadViewBase implements IBeadView, IScrollingLayoutParent
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ScrollingContainerView()
		{
            var vsbm:ScrollBarModel = new ScrollBarModel();
            vsbm.maximum = 0;
            vsbm.minimum = 0;
            vsbm.pageSize = 0;
            vsbm.pageStepSize = 1;
            vsbm.snapInterval = 1;
            vsbm.stepSize = 1;
            vsbm.value = 0;
            _vScrollBarModel = vsbm;
		}
		
        /**
         *  The actual parent that parents the children.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */        
		protected var actualParent:UIBase;
				
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
            var host:UIBase = value as UIBase;
            if (host.numChildren > 0)
                childHandler(null);  
            else
                host.addEventListener("childrenAdded", childHandler);
        }
        
        private function childHandler(event:Event):void
        {
            var host:UIBase = _strand as UIBase;
            if (host.numChildren > 0)
            {
                actualParent = host.getChildAt(0) as UIBase;   
            }
        
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(host, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(host, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				if (host.getBeadByType(IBackgroundBead) == null)
                    host.addBead(new (ValuesManager.valuesImpl.getValue(host, "iBackgroundBead")) as IBead);					
			}
			
			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(host, "border");
			if (borderStyles is Array)
			{
				borderStyle = borderStyles[1];
			}
			if (borderStyle == null)
			{
				borderStyle = ValuesManager.valuesImpl.getValue(host, "border-style") as String;
			}
			if (borderStyle != null && borderStyle != "none")
			{
				if (host.getBeadByType(IBorderBead) == null)
                    host.addBead(new (ValuesManager.valuesImpl.getValue(host, "iBorderBead")) as IBead);	
			}
		}
		
        /**
         *  The parent of the children.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get contentView():IParentIUIBase
		{
			return actualParent;
		}
		
        /**
         *  The border.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get border():Border
		{
			return null;
		}
		
        /**
         *  The host component, which can resize to different slots.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get resizableView():IUIBase
		{
			return _strand as IUIBase;
		}
		
        private var _vScrollBarModel:ScrollBarModel;
        private var _vScrollBar:ScrollBar;
        
        /**
         *  The vertical ScrollBar, if it exists.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get vScrollBar():ScrollBar
		{
            if (!_vScrollBar)
                _vScrollBar = createScrollBar();
            return _vScrollBar;
		}
		
        /**
         *  The horizontal ScrollBar, if it exists.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get hScrollBar():ScrollBar
		{
			return null;
		}

        /**
         * @private
         */
        private function createScrollBar():ScrollBar
        {
            var vsb:ScrollBar;
            vsb = new ScrollBar();
            vsb.model = _vScrollBarModel;
            vsb.width = 16;
            IParent(_strand).addElement(vsb);
            return vsb;
        }

        /**
         *  The position of the vertical scrollbar
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get verticalScrollPosition():Number
        {
            return _vScrollBarModel.value;
        }
        
        /**
         *  @private
         */
        public function set verticalScrollPosition(value:Number):void
        {
            _vScrollBarModel.value = value;
        }

        /**
         *  The maximum position of the vertical scrollbar
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get maxVerticalScrollPosition():Number
        {
            return _vScrollBarModel.maximum - 
                _vScrollBarModel.pageSize;
        }
        
    
    }
}
