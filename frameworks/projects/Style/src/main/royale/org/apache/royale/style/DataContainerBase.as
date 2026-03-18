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
package org.apache.royale.style
{
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.utils.sendEvent;

	/**
	 *  The DataContainerBase class is the base class for components that
	 *  that have generated content, like lists.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	public class DataContainerBase extends GroupBase implements IItemRendererProvider
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function DataContainerBase()
		{
			super();
		}

		private var _initialized:Boolean;

		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			if (!_initialized)
			{
				ValuesManager.valuesImpl.init(this);
				_initialized = true;
			}
			super.addedToParent();
			sendEvent(this, "initComplete");
		}

		/*
		* IItemRendererProvider
		*/

		private var _itemRenderer:IFactory = null;

		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
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
