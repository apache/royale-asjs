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
package org.apache.flex.mdl
{
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IList;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IFactory;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.IChild;
	import org.apache.flex.events.ItemAddedEvent;
	import org.apache.flex.events.ItemRemovedEvent;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;        
    }

	/**
	 *  List in MDL are customizable scrollable lists. Lists present multiple line 
	 *  items vertically as a single continuous element.
	 *  
	 *  In FlexJS MDL relies on an itemRenderer factory to produce its children components
	 *  and on a layout to arrange them. This is the only UI element aside from the itemRenderers.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */  
	public class List extends UIBase implements IItemRendererParent, ILayoutParent, ILayoutHost, ILayoutView, IList
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function List()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

		/**
         *  @copy org.apache.flex.core.IDataProviderModel#dataProvider
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get dataProvider():Object
		{
			return ISelectionModel(model).dataProvider;
		}
		/**
         *  @private
         */
		public function set dataProvider(value:Object):void
		{
			ISelectionModel(model).dataProvider = value;
		}

		/**
         *  @copy org.apache.flex.core.IDataProviderModel#labelField
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get labelField():String
		{
			return ISelectionModel(model).labelField;
		}
		/**
         *  @private
         */
		public function set labelField(value:String):void
		{
			ISelectionModel(model).labelField = value;
		}

		/**
         *  get layout host
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function getLayoutHost():ILayoutHost
		{
			return this;
		}

		/**
         *  get content view
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get contentView():ILayoutView
		{
			return this;
		}

        /**
         *  @copy org.apache.flex.core.IList#dataGroup
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get dataGroup():IItemRendererParent
		{
			return this;
		}
		
		private var _itemRenderer:IFactory;
		
		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}
		
		/**
		 * Returns whether or not the itemRenderer property has been set.
		 *
		 *  @see org.apache.flex.core.IItemRendererProvider
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get hasItemRenderer():Boolean
		{
			var result:Boolean = false;
			
			COMPILE::SWF {
				result = _itemRenderer != null;
			}
				
				COMPILE::JS {
					var test:* = _itemRenderer;
					result = _itemRenderer !== null && test !== undefined;
				}
				
				return result;
		}
		
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
         *  get item renderer for index
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			var child:IItemRenderer = getElementAt(index) as IItemRenderer;
			return child;
		}

		/**
         *  remove all elements
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
         *  update all item renderers
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function updateAllItemRenderers():void
		{
			//todo: IItemRenderer does not define update function but DataItemRenderer does
			//for(var i:int = 0; i < numElements; i++) {
			//	var child:IItemRenderer = getElementAt(i) as IItemRenderer;
			//	child.update();
			//}
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-list";
            
            element = document.createElement('ul') as WrappedHTMLElement;
            
            positioner = element;
            element.flexjs_wrapper = this;
            
            return positioner;
        }  
	}
}
