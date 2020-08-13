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
package org.apache.royale.jewel.supportClasses.container
{
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	
    /**
     *  The DataContainerBase class is the base class for components that
	 *  that have generated content, like lists.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class DataContainerBase extends ContainerBase implements IItemRendererProvider
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
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
						
			dispatchEvent(new Event("initComplete"));
		}
		
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
		 *  @productversion Royale 0.9.7
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
