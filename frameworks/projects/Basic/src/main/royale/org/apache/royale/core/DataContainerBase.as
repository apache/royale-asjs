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
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.sendEvent;
	
	/**
	 *  Indicates that the initialization of the list is complete.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  The DataContainerBase class is the base class for components that
	 *  that have generated content, like lists.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataContainerBase extends ContainerBase implements IItemRendererProvider
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataContainerBase()
		{
			super();
		}
		
		/*
		* UIBase
		*/
		
		private var _DCinitialized:Boolean;
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			if (!_DCinitialized)
			{
				ValuesManager.valuesImpl.init(this);
				_DCinitialized = true;
			}
			
			super.addedToParent();
						
			sendEvent(this,"initComplete");
		}
		
		/*
		 * IList
		 */
		
		/**
		 * Returns the sub-component that parents all of the item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 * 	@royaleignorecoercion org.apache.royale.html.beads.IListView
		public function get dataGroup():IItemRendererOwnerView
		{
			// The JS-side's view.dataGroup is actually this instance of DataContainerBase
			return (view as IListView).dataGroup;
		}
		 */
		
		/*
		* IItemRendererProvider
		*/
		
		private var _itemRenderer:IFactory = null;
		
		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}
				
    }
}
