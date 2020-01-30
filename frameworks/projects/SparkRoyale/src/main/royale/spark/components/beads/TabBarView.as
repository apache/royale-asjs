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

package spark.components.beads
{

	import org.apache.royale.events.Event;
	import org.apache.royale.core.IStrand;
	import spark.core.IGapLayout;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import spark.components.supportClasses.ListBase;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IParent;

	/**
	 *  @private
	 *  The SkinnableContainerView for emulation.
	 */
	public class TabBarView extends SkinnableContainerView
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function TabBarView()
		{
			super();
		}


		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		override protected function handleInitComplete(event:Event):void
		{
            var eventDispatcher:IEventDispatcher = (_strand.getBeadByType(IViewport) as IViewport).contentView as IEventDispatcher;
            eventDispatcher.addEventListener("itemsCreated", handleDataProviderChanged);
			var gapLayout:IGapLayout = (contentView as IStrand).getBeadByType(IGapLayout) as IGapLayout;
			if (gapLayout)
			{
				gapLayout.gap = 0;
			}
			super.handleInitComplete(event);
		}

		private function handleDataProviderChanged(event:Event):void
		{
			var eventDispatcher:IEventDispatcher = (_strand as ListBase).dataProvider;
			eventDispatcher.addEventListener("valueChange", valueChangeHandler);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 */
		protected function valueChangeHandler(event:ValueChangeEvent):void
		{
			if (event.propertyName != "selectedIndex")
			{
				return;
			}
			var ir:IItemRenderer = (contentView as IParent).getElementAt(int(event.oldValue)) as IItemRenderer;
            var sir:ISelectableItemRenderer;
			if(ir)
            {
                sir = ir.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                if (sir)
    				sir.selected = false;
            }
			ir = (contentView as IParent).getElementAt(int(event.newValue)) as IItemRenderer;
			if(ir)
            {
                sir = ir.getBeadByType(ISelectableItemRenderer) as ISelectableItemRenderer;
                if (sir)
                    sir.selected = true;
            }
		}

	}

}
