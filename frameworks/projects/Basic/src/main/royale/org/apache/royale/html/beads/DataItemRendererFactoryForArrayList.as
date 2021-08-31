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
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
    import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;

    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.utils.sendEvent;
    import org.apache.royale.utils.sendStrandEvent;
	
    /**
     *  The DataItemRendererFactoryForArrayList class uses an ArrayList
	 *  and creates an item renderer for every
     *  item in the collection.  Other implementations of
     *  IDataProviderItemRendererMapper map different data 
     *  structures or manage a virtual set of renderers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataItemRendererFactoryForArrayList extends DataItemRendererFactoryBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataItemRendererFactoryForArrayList(target:Object=null)
		{
			super(target);
		}
		
        private var dp:IArrayList;
        
		/**
		 *  @private
         *  @royaleignorecoercion org.apache.royale.collections.IArrayList
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			dp = dataProviderModel.dataProvider as IArrayList;
			if (!dp)
				return;
			
            super.dataProviderChangeHandler(event);
		}
        
        override protected function get dataProviderLength():int
        {
            return dp.length;
        }
        
        override protected function getItemAt(i:int):Object
        {
            return dp.getItemAt(i);
        }
	}
}
