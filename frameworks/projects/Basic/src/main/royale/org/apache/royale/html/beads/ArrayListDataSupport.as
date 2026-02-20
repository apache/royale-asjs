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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.CompoundBead;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;

	/**
	 * Composes bead implementations that support item-renderer mapping for
	 * list-based data providers backed by collection views.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.13
	 */
	public class ArrayListDataSupport extends CompoundBead implements IDataProviderItemRendererMapper
	{
		/**
		 * Creates an <code>ArrayListDataSupport</code> bead and wires the default
		 * support beads used to update, clear, and create item renderers for
		 * collection-view-backed data providers.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.13
		 */
		public function ArrayListDataSupport()
		{
			addBead(new CollectionChangeUpdateForArrayListData());
			addBead(new DynamicRemoveAllItemRendererForArrayListData());
			factory = new DataItemRendererFactoryForCollectionView();
			addBead(factory);
			
		}
		private var factory:IDataProviderItemRendererMapper;
		
		/**
		 * The item renderer class factory in the internal mapper bead.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.13
		 */
		public function get itemRendererFactory():org.apache.royale.core.IItemRendererClassFactory
		{
			return factory.itemRendererFactory;
		}

		public function set itemRendererFactory(value:org.apache.royale.core.IItemRendererClassFactory):void
		{
			factory.itemRendererFactory = value;
		}
	}
}