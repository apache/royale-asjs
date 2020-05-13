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
package org.apache.royale.core
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.utils.sendEvent;

    /**
     *  Indicates that the state change has completed.  All properties
     *  that need to change have been changed, and all transitinos
     *  that need to run have completed.  However, any deferred work
     *  may not be completed, and the screen may not be updated until
     *  code stops executing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="stateChangeComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  Indicates that the initialization of the container is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="initComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  Indicates that the children of the container is have been added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="childrenAdded", type="org.apache.royale.events.Event")]
    
    /**
     *  The ContainerBase class is the base class for most containers
     *  in Royale.  It is usable as the root tag of MXML
     *  documents and UI controls and containers are added to it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ContainerBase extends GroupBase implements IContainerBaseStrandChildrenHost
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ContainerBase()
		{
			super();
		}
		
		private var _strandChildren:ContainerBaseStrandChildren;
		
		/**
		 * @private
		 */
		override public function get strandChildren():IParent
		{
			if (_strandChildren == null) {
				_strandChildren = new ContainerBaseStrandChildren(this);
			}
			return _strandChildren;
		}
		
		/*
		 * The following functions are for the SWF-side only and re-direct element functions
		 * to the content area, enabling scrolling and clipping which are provided automatically
		 * in the JS-side. GroupBase handles event dispatching if necessary.
		 */
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var contentView:IParent = getLayoutHost().contentView as IParent;
			contentView.addElement(c, dispatchEvent);
            if (dispatchEvent)
                sendEvent(this,new ValueEvent("childrenAdded", c));
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			var contentView:IParent = getLayoutHost().contentView as IParent;
			contentView.addElementAt(c, index, dispatchEvent);
            if (dispatchEvent)
                sendEvent(this,new ValueEvent("childrenAdded", c));
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
			//TODO This should possibly be ultimately refactored to be more PAYG
			if(dispatchEvent)
				sendEvent(this,new ValueEvent("childrenRemoved", c));
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

		/*
		 * IStrandPrivate
		 *
		 * These "internal" function provide a backdoor way for proxy classes to
		 * operate directly at strand level. While these function are available on
		 * both SWF and JS platforms, they really only have meaning on the SWF-side. 
		 * Other subclasses may provide use on the JS-side.
		 *
		 * @see org.apache.royale.core.IContainer#strandChildren
		 */
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function get $numElements():int
		{
			return super.numElements;
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			super.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $getElementIndex(c:IChild):int
		{
			return super.getElementIndex(c);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $getElementAt(index:int):IChild
		{
			return super.getElementAt(index);
		}

    }
}
