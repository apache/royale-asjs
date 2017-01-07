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
package org.apache.flex.mdl.beads.views
{
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.html.beads.IListView;

	import org.apache.flex.events.Event;

	/**
	 *  ListView makes sure the itemRendererFactory and the layout beads are installed.
	 * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ListView extends BeadViewBase implements IListView
	{
		public function ListView()
		{
			super();
		}

		public function get dataGroup():IItemRendererParent
		{
			return _strand as IItemRendererParent;
		}

		protected var listModel:ISelectionModel;


		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			var mapper:IDataProviderItemRendererMapper = _strand.getBeadByType(IDataProviderItemRendererMapper) as IDataProviderItemRendererMapper;
			if (mapper == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(host, "iDataProviderItemRendererMapper");
				if (c) {
					mapper = new c() as IDataProviderItemRendererMapper;
					_strand.addBead(mapper);
				}
			}

			host.addEventListener("itemsCreated", itemsCreatedHandler);

			listModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			performLayout(null);
		}

		/**
		 * @private
		 */
		protected function itemsCreatedHandler(event:Event):void
		{
			performLayout(event);
		}

		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			performLayout(event);
		}

		/**
		 * @private
		 */
		protected function performLayout(event:Event):void
		{
			var layout:IBeadLayout = _strand.getBeadByType(IBeadLayout) as IBeadLayout;
			if (layout == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
				if (c) {
					layout = new c() as IBeadLayout;
					_strand.addBead(layout);
				}
			}

			if (layout) {
				layout.layout();
			}
		}
	}
}
