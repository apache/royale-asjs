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
package org.apache.flex.html
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.ContainerBase;
	import org.apache.flex.core.IChrome;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	
	[DefaultProperty("mxmlContent")]
    
    /**
     *  The Container class implements a basic container of
     *  other controls and containers.  The position and size
     *  of the children are determined by a layout or by
     *  absolute positioning and sizing.  This Container does
     *  not have a built-in scrollbar or clipping of content
     *  exceeds its boundaries.
     * 
     *  While the container is relatively lightweight, it should
     *  generally not be used as the base class for other controls,
     *  even if those controls are composed of children.  That's
     *  because the fundamental API of Container is to support
     *  an arbitrary set of children, and most controls only
     *  support a specific set of children.
     * 
     *  And that's one of the advantages of beads: that functionality
     *  used in a Container can also be used in a Control as long
     *  as that bead doesn't assume that its strand is a Container.
     * 
     *  For example, even though you can use a Panel to create the
     *  equivalent of an Alert control, the Alert is a 
     *  control and not a Container because the Alert does not
     *  support an arbitrary set of children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class Container extends ContainerBase implements IContainer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Container()
		{
			super();
			actualParent = this;
		}
		
		private var actualParent:DisplayObjectContainer;
		
        /**
         *  Set a platform-specific object as the actual parent for 
         *  children.  This must be public so it can be accessed
         *  by beads.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function setActualParent(parent:DisplayObjectContainer):void
		{
			actualParent = parent;	
		}
		
        /**
         *  @private
         */
        override public function getElementIndex(c:Object):int
        {
            if (c is IUIBase)
                return actualParent.getChildIndex(IUIBase(c).element as DisplayObject);
            else
                return actualParent.getChildIndex(c as DisplayObject);
        }

        /**
         *  @private
         */
        override public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
            {
				if (c is IChrome ) {
					addChild(IUIBase(c).element as DisplayObject);
					IUIBase(c).addedToParent();
				}
				else {
                	actualParent.addChild(IUIBase(c).element as DisplayObject);
                	IUIBase(c).addedToParent();
				}
            }
            else {
				if (c is IChrome) {
					addChild(c as DisplayObject);
				}
				else {
					actualParent.addChild(c as DisplayObject);
				}
			}
            if (dispatchEvent)
                this.dispatchEvent(new Event("childrenAdded"));
        }
        
        /**
         *  @private
         */
        override public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
            {
				if (c is IChrome) {
					addChildAt(IUIBase(c).element as DisplayObject, index);
					IUIBase(c).addedToParent();
				}
				else {
                	actualParent.addChildAt(IUIBase(c).element as DisplayObject, index);
                	IUIBase(c).addedToParent();
				}
            }
            else {
				if (c is IChrome) {
					addChildAt(c as DisplayObject, index);
				} else {
                	actualParent.addChildAt(c as DisplayObject, index);
				}
			}
            if (dispatchEvent)
                this.dispatchEvent(new Event("childrenAdded"));
        }
        
        /**
         *  @private
         */
        override public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
                actualParent.removeChild(IUIBase(c).element as DisplayObject);
            else
                actualParent.removeChild(c as DisplayObject);
            if (dispatchEvent)
                this.dispatchEvent(new Event("childrenRemoved"));
        }
        
        /**
         *  Get the array of children.  To change the children use
         *  addElement, removeElement.
         */
        public function getChildren():Array
		{
			var children:Array = [];
			var n:int = actualParent.numChildren;
			for (var i:int = 0; i < n; i++)
				children.push(actualParent.getChildAt(i));
			return children;
		}

        /**
         *  @private
         */
		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
	}
}
