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
package org.apache.flex.core
{
	import org.apache.flex.core.IMXMLDocument;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.ItemAddedEvent;
	import org.apache.flex.events.ItemClickedEvent;
	import org.apache.flex.events.ItemRemovedEvent;
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.states.State;
	import org.apache.flex.utils.MXMLDataInterpreter;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	/**
	 *  Indicates that the initialization of the list is complete.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="initComplete", type="org.apache.flex.events.Event")]
    
    /**
     *  The DataContainerBase class is the base class for components that
	 *  that have generated content, like lists.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class DataContainerBase extends UIBase implements ILayoutParent, ILayoutView, IItemRendererParent, IContentViewHost, IContainer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DataContainerBase()
		{
			super();        
			
			addEventListener("beadsAdded", beadsAddedHandler);
		}
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElement('div') as WrappedHTMLElement;
			element.flexjs_wrapper = this;
			
			positioner = element;
			
			return element;
		}
		
		private var _strandChildren:ContainerBaseStrandChildren;
		
		/**
		 * @private
		 */
		public function get strandChildren():IParent
		{
			if (_strandChildren == null) {
				_strandChildren = new ContainerBaseStrandChildren(this);
			}
			return _strandChildren;
		}
		
		/**
		 *  @private
		 */
		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
		
		private var _initialized:Boolean;
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			if (!_initialized)
			{
				// each MXML file can also have styles in fx:Style block
				ValuesManager.valuesImpl.init(this);
			}
			
			super.addedToParent();
			
			dispatchEvent(new Event("initComplete"));
		}
		
		/**
		 * @private
		 */
		private function beadsAddedHandler(e:Event):void
		{
			if (getBeadByType(IDataProviderItemRendererMapper) == null)
			{
				var mapper:IDataProviderItemRendererMapper = new (ValuesManager.valuesImpl.getValue(this, "iDataProviderItemRendererMapper")) as IDataProviderItemRendererMapper;
				addBead(mapper);
			}
			var itemRendererFactory:IItemRendererClassFactory = getBeadByType(IItemRendererClassFactory) as IItemRendererClassFactory;
			if (!itemRendererFactory)
			{
				itemRendererFactory = new (ValuesManager.valuesImpl.getValue(this, "iItemRendererClassFactory")) as IItemRendererClassFactory;
				addBead(itemRendererFactory);
			}
		}
		
		/**
		 * Returns the ILayoutHost which is its view. From ILayoutParent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function getLayoutHost():ILayoutHost
		{
			return view as ILayoutHost; 
		}
		
		/*
		* The following functions are for the SWF-side only and re-direct element functions
		* to the content area, enabling scrolling and clipping which are provided automatically
		* in the JS-side.
		*/
		
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
		
		/*
		* IItemRendererParent
		*/
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#addItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function addItemRenderer(renderer:IItemRenderer):void
		{
			addElement(renderer, true);
			
			var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#removeItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function removeItemRenderer(renderer:IItemRenderer):void
		{
			removeElement(renderer, true);
			
			var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#removeAllItemRenderers()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function removeAllItemRenderers():void
		{
			while (numElements > 0) {
				var child:IChild = getElementAt(0);
				removeElement(child);
			}
		}
		
		/**
		 *  @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			if (index < 0 || index >= numElements) return null;
			return getElementAt(index) as IItemRenderer;
		}
		
		/**
		 *  Refreshes the itemRenderers. Useful after a size change by the data group.
		 *
		 *  @copy org.apache.flex.core.IItemRendererParent#updateAllItemRenderers()
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function updateAllItemRenderers():void
		{
			var n:Number = numElements;
			for (var i:Number = 0; i < n; i++)
			{
				var renderer:DataItemRenderer = getItemRendererForIndex(i) as DataItemRenderer;
				if (renderer) {
					renderer.setWidth(this.width,true);
					renderer.adjustSize();
				}
			}
		}
		
		/*
		* These "internal" function provide a backdoor way for proxy classes to
		* operate directly at strand level. While these function are available on
		* both SWF and JS platforms, they really only have meaning on the SWF-side. 
		* Other subclasses may provide use on the JS-side.
		*/
		
		/**
		 * @private
		 * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $numElements():int
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
