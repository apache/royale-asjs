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
	import org.apache.flex.core.IBeadLayout;
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
         *  The layout.  The layout may actually layout
         *  the children of the internal content area
         *  and not the pieces of the "chrome" like titlebars
         *  and borders.  The ContainerView or its subclass will have some
         *  baked-in logic for handling the chrome.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */        
        protected var layout:IBeadLayout;
        
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
            
            if (host.isWidthSizedToContent() && host.isHeightSizedToContent())
            {
                // if both dimensions are sized to content, then only draw the
                // borders, etc, after a child is added.  The children in an MXML
                // document don't send this event until the last child is added.
                host.addEventListener("childrenAdded", changeHandler);
                host.addEventListener("layoutNeeded", changeHandler);
                // listen for width and height changes as well in case the app
                // switches away from content sizing via binding or other code
                host.addEventListener("widthChanged", changeHandler);
                host.addEventListener("heightChanged", changeHandler);
            }
            else
            {
                // otherwise, listen for size changes before drawing
                // borders and laying out children.
                host.addEventListener("widthChanged", changeHandler);
                host.addEventListener("heightChanged", changeHandler);
                host.addEventListener("sizeChanged", sizeChangeHandler);
                // if we have fixed size in both dimensions, wait for children
                // to be added then run a layout pass right then as the
                // parent won't kick off any other event in the child
                if (!isNaN(host.explicitWidth) && !isNaN(host.explicitHeight))
                {
                    if (host.numChildren > 0)
                        changeHandler(null);
                    else
                        host.addEventListener("childrenAdded", changeHandler);
                }
            }
        }
        
        private function sizeChangeHandler(event:Event):void
        {
            var host:UIBase = UIBase(_strand);
            host.addEventListener("childrenAdded", changeHandler);
            host.addEventListener("layoutNeeded", changeHandler);
            host.addEventListener("itemsCreated", changeHandler);
            changeHandler(event);
        }

        private function changeHandler(event:Event):void
        {
            var host:UIBase = _strand as UIBase;
            if (layout == null)
            {
                layout = host.getBeadByType(IBeadLayout) as IBeadLayout;
                if (layout == null)
                {
                    var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
                    if (c)
                    {
                        layout = new c() as IBeadLayout;
                        host.addBead(layout);
                    }
                }
            }
            
            if (host.numChildren > 0)
            {
                actualParent = host.getChildAt(0) as UIBase;   
            }
        
            layout.layout();
            
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
            IParent(_strand).addElement(vsb, false);
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
