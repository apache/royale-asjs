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
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.collections.ArrayList;
    import org.apache.royale.html.supportClasses.DataProviderNotifierBase;

    /**
	 *  The DataProviderCollectionChangeNotifier notifies listeners when a selection model's
	 *  ArrayList dataProvider disptached collectionChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataProviderCollectionChangeNotifier extends DataProviderNotifierBase
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataProviderCollectionChangeNotifier()
		{
		}
		
		override protected function destinationChangedHandler(event:Event):void
		{
			var object:Object = document[sourceID];
			if (dataProvider)
			{
				if(object[propertyName] == dataProvider)
					return;
				dataProvider.removeEventListener(changeEventName == null ? "collectionChanged":changeEventName, handleCollectionChanged);
			}
			dataProvider = object[propertyName] as ArrayList;
			dataProvider.addEventListener(changeEventName == null ? "collectionChanged":changeEventName, handleCollectionChanged);
		}

		private function handleCollectionChanged(event:Event):void
		{
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            selectionModel.dispatchEvent(new Event("dataProviderChanged"));
		}
	}
}
