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
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.ContainerBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IList;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.LayoutBase;
	import org.apache.flex.core.Strand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.html.beads.models.SingleLineBorderModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.DataGroup;
	import org.apache.flex.html.supportClasses.ScrollBar;

	/**
	 *  The DataContainerView provides the visual elements for the DataContainer.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	COMPILE::JS
	public class DataContainerView extends ContainerView implements IListView
	{
		public function DataContainerView()
		{
			super();
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			host.addEventListener("beadsAdded", beadsAddedHandler);
		}
		
		protected var dataModel:IDataProviderModel;
		
		/**
		 * @royaleignorecoercion org.apache.flex.core.IItemRendererParent
		 */
		public function get dataGroup():IItemRendererParent
		{
			return super.contentView as IItemRendererParent;
		}
		
		protected function beadsAddedHandler(event:Event):void
		{
			dataModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			host.addEventListener("itemsCreated", itemsCreatedHandler);
			dataModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
		}
		
		/**
		 * @private
		 */
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);
		}
		
		/**
		 * @private
		 */
		protected function itemsCreatedHandler(event:Event):void
		{
			trace("DataContainerView: itemsCreatedHandler");
			host.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			trace("DataContainerView: dataProviderChangeHandler");
			performLayout(event);
		}
	}
	
	COMPILE::SWF
	public class DataContainerView extends ContainerView implements IListView
	{
		public function DataContainerView()
		{
			super();
		}
						
		protected var dataModel:IDataProviderModel;
		
		/**
		 * @private
		 */
		override public function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			host.addEventListener("beadsAdded", beadsAddedHandler);
			host.addEventListener("itemsCreated", itemsCreatedHandler);
		}
		
		override protected function completeSetup():void
		{
			super.completeSetup();
			
			// list is not interested in UI children, it wants to know when new items
			// have been added or the dataProvider has changed.
//			host.removeEventListener("childrenAdded", childrenChangedHandler);
//			host.removeEventListener("childrenAdded", performLayout);
		}
		
		protected function beadsAddedHandler(event:Event):void
		{
			dataModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			dataModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
		}
		
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);
		}
		
		/**
		 *  The area holding the itemRenderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get dataGroup():IItemRendererParent
		{
			return super.contentView as IItemRendererParent;
		}
				
		/**
		 * @private
		 */
		override public function get resizableView():IUIBase
		{
			return _strand as IUIBase;
		}
		
		/**
		 * @private
		 */
		protected function itemsCreatedHandler(event:Event):void
		{
			host.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			host.dispatchEvent(new Event("layoutNeeded"));
		}
		        
        /**
         *  respond to a change in size or request to re-layout everything
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override protected function resizeHandler(event:Event):void
		{
			// might need to do something here, not sure yet.
			super.resizeHandler(event);
		}
	}
}
