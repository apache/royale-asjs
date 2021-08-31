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
package mx.controls.beads
{
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
    import org.apache.royale.core.IDataProviderNotifier;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModel;

    /**
	 *  The DataProviderChangeNotifier notifies listeners when a selection model's
	 *  dataProvider has changed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class DataProviderChangeNotifier implements IDataProviderNotifier
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		private var _strand:IStrand;
		protected var dataProvider:IEventDispatcher;

		public function DataProviderChangeNotifier()
		{
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			model.addEventListener("dataProviderChanged", dataProviderChangedHandler);
			dataProviderChangedHandler(null);
		}

		protected function dataProviderChangedHandler(event:Event):void
		{
			if (dataProvider != model.dataProvider){
				if (dataProvider)
				{
					detachEventListeners();
				}
				dataProvider = model.dataProvider as IEventDispatcher;
				if (dataProvider) {
					attachEventListeners();
				}
			}
		}

		private function get model():ISelectionModel
		{
			return IStrandWithModel(_strand).model as ISelectionModel;
		}

		private function handleDataProviderChanges(event:Event):void
		{
            model.dispatchEvent(new Event("dataProviderChanged"));
		}
		
		protected function attachEventListeners():void
		{
			dataProvider.addEventListener("collectionChanged", handleDataProviderChanges);
			dataProvider.addEventListener("filterFunctionChanged", handleDataProviderChanges);
			dataProvider.addEventListener("sortChanged", handleDataProviderChanges);
			dataProvider.addEventListener("collectionChange", handleDataProviderChanges);
		}
		
		protected function detachEventListeners():void
		{
			dataProvider.removeEventListener("collectionChanged", handleDataProviderChanges);
			dataProvider.removeEventListener("filterFunctionChanged", handleDataProviderChanges);
			dataProvider.removeEventListener("sortChanged", handleDataProviderChanges);
			dataProvider.removeEventListener("collectionChange", handleDataProviderChanges);
		}
	}
}
