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
package org.apache.royale.jewel.beads.controllers
{
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadKeyController;
	import org.apache.royale.core.IFocusable;
	import org.apache.royale.core.IRemovableBead;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.events.utils.NavigationKeys;
	import org.apache.royale.events.utils.WhitespaceKeys;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.jewel.beads.views.IScrollToIndexView;
	import org.apache.royale.jewel.supportClasses.textinput.ITextInput;
	import org.apache.royale.utils.sendEvent;

    /**
     *  The Jewel ListSingleSelectionMouseController class is a controller for
     *  org.apache.royale.jewel.List.
     * 
     *  Controllers watch for events from the interactive portions of a View and
     *  update the data model or dispatch a semantic event.
     *  This controller watches for events from the item renderers
     *  and updates an ISelectionModel (which only supports single
     *  selection).  Other controller/model pairs would support
     *  various kinds of multiple selection.
     * 
     *  Jewel controller takes into account if the component
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class ListKeyDownController extends Bead implements IBeadKeyController, IRemovableBead
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function ListKeyDownController()
		{
		}

		/**
		 *  The model.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		protected var listModel:ISelectionModel;

		/**
		 *  The view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		protected var listView:IListView;

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 *  @royaleignorecoercion org.apache.royale.jewel.beads.models.IJewelSelectionModel
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         *  @royaleignorecoercion org.apache.royale.core.IListView
         */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			listView = value.getBeadByType(IListView) as IListView;

            listenOnStrand(KeyboardEvent.KEY_DOWN, keyDownEventHandler);
		}

		/**
		 *  The actions needed before the removal
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function tearDown():void
		{
			IEventDispatcher(_strand).removeEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler);
		}

        /**
		 * @private
		 */
		protected function keyDownEventHandler(event:KeyboardEvent):void
		{
			// if the renderer has a input text we want to be able to type text on it
			if(event.target is ITextInput)
				return;
						
			// avoid Tab loose the normal behaviour, for navigation we don't want build int scrolling support in browsers
			if(event.key === WhitespaceKeys.TAB)
				return;
			
			event.preventDefault();

			var index:int = listModel.selectedIndex;

			if(event.key === NavigationKeys.UP || event.key === NavigationKeys.LEFT)
			{
				if(index > 0)
					listModel.selectedIndex--;
			} 
			else if(event.key === NavigationKeys.DOWN || event.key === NavigationKeys.RIGHT)
			{
				listModel.selectedIndex++;
			}

			if(index != listModel.selectedIndex)
			{
				listModel.selectedItem = listModel.dataProvider.getItemAt(listModel.selectedIndex);

				var ir:IFocusable = listView.dataGroup.getItemRendererForIndex(listModel.selectedIndex) as IFocusable;
				ir.setFocus();
				
                (listView as IScrollToIndexView).scrollToIndex(listModel.selectedIndex);
				
				sendEvent(listView.host, 'change');
			}
		}
	}
}
