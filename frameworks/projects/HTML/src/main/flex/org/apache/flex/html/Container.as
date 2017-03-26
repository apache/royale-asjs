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
	import org.apache.flex.core.IContainer;
	
	COMPILE::SWF {
		import org.apache.flex.core.IChild;
		import org.apache.flex.core.ILayoutHost;
		import org.apache.flex.core.IParent;
	}
	
    /**
     *  The Container class implements a basic container for
     *  other controls and containers.  The position and size
     *  of the children are determined by a layout while the size of
     *  a Container can either be determined by its children or by
     *  specifying an exact size in pixels or as a percentage of the
     *  parent element.
     *
     *  This Container does not have a built-in scroll bar or clipping of
     *  its content should the content exceed the Container's boundaries. To
     *  have scroll bars and clipping, add the ScrollingView bead.  
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
     *  @toplevel
     *  @see org.apache.flex.html.beads.layout
     *  @see org.apache.flex.html.supportClasses.ScrollingViewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class Container extends Group implements IContainer
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
		} 
		
		/**
		 * @private
		 * This is a hidden function used by ContainerView to insert the nested contentView
		 * into this outer shell.
		 */
		COMPILE::SWF
		public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			contentView.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			contentView.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function getElementIndex(c:IChild):int
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			return contentView.getElementIndex(c);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			contentView.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function get numElements():int
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			return contentView.numElements;
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function getElementAt(index:int):IChild
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			return contentView.getElementAt(index);
		}
	}
}
