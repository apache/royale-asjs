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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.Event;
	import org.apache.flex.collections.ArrayList;
    import org.apache.flex.html.supportClasses.DataProviderNotifierBase;

    /**
	 *  The DataProviderChangeNotifier notifies listeners when a selection model's
	 *  ArrayList dataProvider has changed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataProviderChangeNotifier extends DataProviderNotifierBase
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataProviderChangeNotifier()
		{
		}
		
		override protected function destinationChangedHandler(event:Event):void
		{
			if (dataProvider == null)
			{
				var object:Object = document[sourceID];
				dataProvider = object[propertyName] as ArrayList;
			}
			else
			{
				if(object[propertyName] == dataProvider)
					return;
                dataProvider.removeEventListener("itemAdded", handleDataProviderChanges);
                dataProvider.removeEventListener("itemRemoved", handleDataProviderChanges);
                dataProvider.removeEventListener("itemUpdated", handleDataProviderChanges);
                dataProvider.removeEventListener("collectionChanged", handleDataProviderChanges);
				dataProvider = object[propertyName] as ArrayList;
			}

            dataProvider.addEventListener("itemAdded", handleDataProviderChanges);
            dataProvider.addEventListener("itemRemoved", handleDataProviderChanges);
            dataProvider.addEventListener("itemUpdated", handleDataProviderChanges);
            dataProvider.addEventListener("collectionChanged", handleDataProviderChanges);
		}

		private function handleDataProviderChanges(event:Event):void
		{
            var selectionModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            selectionModel.dispatchEvent(new Event("dataProviderChanged"));
		}
	}
}
