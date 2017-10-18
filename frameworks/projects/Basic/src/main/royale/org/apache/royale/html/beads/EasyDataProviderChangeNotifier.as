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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;

    /**
	 *  The EasyDataProviderChangeNotifier is similar to DataProviderChangeNotifier
	 *  but allows the user to populate the data provider after it's been added.
	 *  Also, no attributes are required. Just add <EasyDataProviderChangeNotifier/>.
	 *  The dataProvider is assumed to be an ArrayList.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class EasyDataProviderChangeNotifier extends DataProviderChangeNotifier
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function EasyDataProviderChangeNotifier()
		{
			super();
			changeEventName = "dataProviderChanged";
		}
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			if(changeEventName)
				selectionModel.addEventListener(changeEventName, destinationChangedHandler);
			
			destinationChangedHandler(null);
		}
		
		override protected function destinationChangedHandler(event:Event):void
		{
			if (!dataProvider)
			{
				setDataProvider();
				if (!dataProvider && !changeEventName)
					selectionModel.addEventListener("dataProviderChanged", setFirstDataProvider);
				
			} else
			{
				if(dataProvider == selectionModel.dataProvider)
					return;
				detachEventListeners();
				setDataProvider();
				attachEventListeners();
			}
		}
		
		private function setFirstDataProvider(e:Event):void
		{
			setDataProvider();
			selectionModel.removeEventListener("dataProviderChanged", setFirstDataProvider);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.collections.ArrayList
		 */
		private function setDataProvider():void
		{
			dataProvider = selectionModel.dataProvider as ArrayList;
			if(dataProvider)
				attachEventListeners();
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		private function get selectionModel():ISelectionModel
		{
			return (_strand as UIBase).model as ISelectionModel;
		}
		
	}
}
