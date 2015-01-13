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
	import org.apache.flex.core.ILayoutParent;
    import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
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
                host.addEventListener("childrenAdded", changeHandler);
                checkActualParent();
            }
            else
            {
                host.addEventListener("widthChanged", changeHandler);
                host.addEventListener("heightChanged", changeHandler);
                host.addEventListener("sizeChanged", sizeChangeHandler);
                if (!isNaN(host.explicitWidth) && !isNaN(host.explicitHeight))
                    sizeChangeHandler(null);
                else
                    checkActualParent();
            }
            
            if (_strand.getBeadByType(IBeadLayout) == null)
            {
                var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
                if (c)
                {
                    var layout:IBeadLayout = new c() as IBeadLayout;
                    _strand.addBead(layout);
                }
            }            
        }
        
        private function checkActualParent():Boolean
        {
            var host:UIBase = UIBase(_strand);
            if (contentAreaNeeded())
            {
                if (actualParent == null || actualParent == host)
                {
                    actualParent = new ContainerContentArea();
                    host.addElement(actualParent);
                    Container(host).setActualParent(actualParent);
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
			
			var padding:Object = determinePadding();
			
			if (checkActualParent())
			{
				actualParent.x = padding.paddingLeft;
				actualParent.y = padding.paddingTop;
                var pb:Number = padding.paddingBottom;
                if (isNaN(pb))
                    pb = 0;
                var pr:Number = padding.paddingRight;
                if (isNaN(pr))
                    pr = 0;
                if (!isNaN(host.explicitWidth) || !isNaN(host.percentWidth))
                    actualParent.setWidth(host.width - padding.paddingLeft - pr);
                else
                    host.dispatchEvent(new Event("widthChanged"));
                
                if (!isNaN(host.explicitHeight) || !isNaN(host.percentHeight))
                    actualParent.setHeight(host.height - padding.paddingTop - pb);
                else
                    host.dispatchEvent(new Event("heightChanged"));
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
            
            inChangeHandler = false;
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
			}
			else
			{
				paddingLeft = paddingTop = padding;
			}
			var pl:Number = Number(paddingLeft);
			var pt:Number = Number(paddingTop);
			
			return {paddingLeft:pl, paddingTop:pt};
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
				
	}
}
