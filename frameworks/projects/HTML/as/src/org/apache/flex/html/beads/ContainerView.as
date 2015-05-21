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
    import org.apache.flex.core.ContainerBase;
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IBeadLayout;
    import org.apache.flex.core.IBeadView;
    import org.apache.flex.core.ILayoutParent;
    import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.UIBase;
    import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.html.supportClasses.Border;
    import org.apache.flex.html.supportClasses.ContainerContentArea;
    import org.apache.flex.html.supportClasses.ScrollBar;
	
    /**
     *  The ContainerView class is the default view for
     *  the org.apache.flex.core.ContainerBase classes.
     *  It lets you use some CSS styles to manage the border, background
     *  and padding around the content area.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ContainerView extends BeadViewBase implements IBeadView, ILayoutParent
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ContainerView()
		{
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
            
            if (host.isWidthSizedToContent() || host.isHeightSizedToContent())
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
                // if we have fixed size in both dimensions, listen for children
				// being added, but also force an initial display to get the
				// background, border, etc.
                if (!isNaN(host.explicitWidth) && !isNaN(host.explicitHeight)) {
                    host.addEventListener("childrenAdded", changeHandler);
					displayBackgroundAndBorder(host);
				}
            }            
            checkActualParent();
        }
        
        private function checkActualParent():Boolean
        {
            var host:UIBase = UIBase(_strand);
            if (contentAreaNeeded())
            {
                if (actualParent == null || actualParent == host)
                {
                    actualParent = new ContainerContentArea();
					actualParent.className = "ActualParent";
                    host.addElement(actualParent, false);
                    ContainerBase(host).setActualParent(actualParent);
                }
                return true;
            }
            else
            {
                actualParent = host;
            }
            return false;
        }
        
        private function sizeChangeHandler(event:Event):void
        {
            var host:UIBase = UIBase(_strand);
            host.addEventListener("childrenAdded", changeHandler);
            host.addEventListener("layoutNeeded", changeHandler);
            host.addEventListener("itemsCreated", changeHandler);
            changeHandler(event);
        }
        
        private var inChangeHandler:Boolean;
        
        /**
         *  React if the size changed or content changed 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected function changeHandler(event:Event):void
        {
            if (inChangeHandler) return;
            
            inChangeHandler = true;
            
            var host:UIBase = UIBase(_strand);
			var originalHostWidth:Number = host.width;
			var originalHostHeight:Number = host.height;

            if (layout == null)
            {
                layout = _strand.getBeadByType(IBeadLayout) as IBeadLayout;
                if (layout == null)
                {
                    var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
                    if (c)
                    {
                        layout = new c() as IBeadLayout;
                        _strand.addBead(layout);
                    }
                }
            }
            
			var padding:Object = determinePadding();
			
			if (checkActualParent())
			{
				actualParent.x = padding.paddingLeft;
				actualParent.y = padding.paddingTop;
            }
            var pb:Number = padding.paddingBottom;
            if (isNaN(pb))
                pb = 0;
            var pr:Number = padding.paddingRight;
            if (isNaN(pr))
                pr = 0;
			
			var sizeChangedByLayout:Boolean;
			
            // if the width is dictated by the parent
            if (!host.isWidthSizedToContent())
            {
                if (actualParent != host)
                {
                    // force the width of the internal content area as desired.
                    actualParent.setWidth(host.width - padding.paddingLeft - pr);
                }
                // run the layout
                sizeChangedByLayout = layout.layout();
            }
            else 
            {
                // if the height is dictated by the parent
                if (!host.isHeightSizedToContent())
                {
                    if (actualParent != host)
                    {
                        // force the height
                        actualParent.setHeight(host.height - padding.paddingTop - pb);
                    }
                }
                sizeChangedByLayout = layout.layout();
                if (actualParent != host)
                {
                    // actualParent.width should be the new width after layout.
                    // set the host's width.  This should send a widthChanged event and
                    // have it blocked at the beginning of this method
                    host.setWidth(padding.paddingLeft + pr + actualParent.width);
                }
            }
            // and if the height is sized to content, set the height now as well.
            if (host != actualParent)
	        {
                if (host.isHeightSizedToContent()) {
                    host.setHeight(padding.paddingTop + pb + actualParent.height);
				}
                else
                    actualParent.setHeight(host.height - padding.paddingTop - pb);
		    }
			// if host and actualParent are the same, determine if the layout changed
			// the size and if, dispatch events based on what changed
			else if (sizeChangedByLayout) 
			{
				if (originalHostWidth != host.width) 
					host.dispatchEvent(new Event("widthChanged"));
				if (originalHostHeight != host.height)
					host.dispatchEvent(new Event("heightChanged"));
			}
			
			displayBackgroundAndBorder(host);
			            
            inChangeHandler = false;
		}
		
		protected function displayBackgroundAndBorder(host:UIBase) : void
		{
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
			var paddingBottom:Object;
			var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding");
			if (padding is Array)
			{
				if (padding.length == 1)
					paddingLeft = paddingTop = padding[0];
				else if (padding.length <= 3)
				{
					paddingLeft = padding[1];
					paddingTop = padding[0];
				}
				else if (padding.length == 4)
				{
					paddingLeft = padding[3];
					paddingTop = padding[0];					
				}
			}
			else if (padding == null)
			{
				paddingLeft = ValuesManager.valuesImpl.getValue(_strand, "padding-left");
				paddingTop = ValuesManager.valuesImpl.getValue(_strand, "padding-top");
				paddingRight = ValuesManager.valuesImpl.getValue(_strand, "padding-right");
				paddingBottom = ValuesManager.valuesImpl.getValue(_strand, "padding-bottom");
			}
			else
			{
				paddingLeft = paddingTop = padding;
				paddingRight = paddingBottom = padding;
			}
			var pl:Number = Number(paddingLeft);
			var pt:Number = Number(paddingTop);
			var pr:Number = Number(paddingRight);
			var pb:Number = Number(paddingBottom);
			
			return {paddingLeft:pl, paddingTop:pt, paddingRight:pr, paddingBottom:pb};
		}
		
		/**
		 *  Returns true if container to create a separate ContainerContentArea.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function contentAreaNeeded():Boolean
		{
			var padding:Object = determinePadding();
			
			return (!isNaN(padding.paddingLeft) && padding.paddingLeft > 0 ||
				    !isNaN(padding.paddingTop) && padding.paddingTop > 0);
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
		
        private var inGetViewHeight:Boolean;
        
		/**
		 *  @copy org.apache.flex.core.IBeadView#viewHeight
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get viewHeight():Number
		{
            if (inGetViewHeight)
            {
                //trace("ContainerView: no height set for " + host);
                return host["$height"];
            }
            inGetViewHeight = true;
			var vh:Number = contentView.height;
            inGetViewHeight = false;
            return vh;
		}
		
        private var inGetViewWidth:Boolean;
        
		/**
		 *  @copy org.apache.flex.core.IBeadView#viewWidth
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get viewWidth():Number
		{
            if (inGetViewWidth)
            {
                //trace("ContainerView: no width set for " + host);
                return host["$width"];
            }
            inGetViewWidth = true;
			var vw:Number = contentView.width;
            inGetViewWidth = false;
			return vw;
		}
		
	}
}
