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
package org.apache.royale.jewel.beads.controls.textinput
{
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadKeyController;
	import org.apache.royale.core.IFocusable;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IRemovableBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.events.utils.NavigationKeys;
	import org.apache.royale.events.utils.WhitespaceKeys;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.beads.models.ListPresentationModel;
	import org.apache.royale.jewel.itemRenderers.ListItemRenderer;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;
	import org.apache.royale.utils.sendEvent;

	/**
	 *  The SearchFilterForList bead class is a specialty bead that can be used with
     *  a Jewel TextInput to filter options in other List component
	 *  
	 *  Notice that the filtering is only visual, and the underlaying dataProvider is not
	 *  filtered itself. To get a filtered view of the dataProvider you should use ArrayListView
	 *  API.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class SearchFilterForList extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function SearchFilterForList()
		{
		}

		private var _list:List;
		/**
		 * the list to filter
		 */
		[Bindable]
		public function get list():List
		{
			return _list;
		}
		public function set list(value:List):void
		{
			removeListListeners();
			
			_list = value;

			if(_list)
			{
				// remove the ListKeyDownController since we need cutom handling of keys based on visible items
				var keyBead:IRemovableBead = _list.getBeadByType(IBeadKeyController) as IRemovableBead;
				if(keyBead)
				{
					keyBead.tearDown();
					_list.removeBead(keyBead);
				}
				
				addListListeners();
			}
		}

		protected function addListListeners():void {
			if(_list)
				_list.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler, true);
		}

		protected function removeListListeners():void {
			if(_list)
				_list.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler, true);
		}

		/**
		 * 
		 * 
		 * @param event 
		 */
		protected function keyDownEventHandler(event:KeyboardEvent):void
		{
			// avoid Tab loose the normal behaviour, for navigation we don't want build int scrolling support in browsers
			if(event.key === WhitespaceKeys.TAB)
				return;
			
			event.preventDefault();

			var index:int = visibleIndexes.indexOf(list.selectedIndex);
			
			if(event.key === NavigationKeys.UP || event.key === NavigationKeys.LEFT)
			{
				if(index > 0)
					list.selectedIndex = visibleIndexes[index - 1];
			} 
			else if(event.key === NavigationKeys.DOWN || event.key === NavigationKeys.RIGHT)
			{
				if(index < visibleIndexes.length - 1)
					list.selectedIndex = visibleIndexes[index + 1];
			}

			if(visibleIndexes[index] != list.selectedIndex)
			{
				list.selectedItem = list.dataProvider.getItemAt(list.selectedIndex);

				var ir:IFocusable = (list.view as IListView).dataGroup.getItemRendererForIndex(list.selectedIndex) as IFocusable;
				ir.setFocus();
				
				COMPILE::JS
				{
                scrollToIndex(list.selectedIndex);
				}
				
				sendEvent(list, 'change');
			}
		}
		
		/**
		 *  Ensures that the data provider item at the given index is visible.
		 *  
		 *  This implementation consider only visible items 
		 *
		 *  @param index The index of the item in the data provider.
		 *
		 *  @return <code>true</code> if <code>verticalScrollPosition</code> changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.7
		 */
		COMPILE::JS
		public function scrollToIndex(index:int):Boolean
		{
			var scrollArea:HTMLElement = list.element;
			var oldScroll:Number = scrollArea.scrollTop;

			var totalHeight:Number = 0;
			var pm:IListPresentationModel = list.getBeadByType(IListPresentationModel) as IListPresentationModel;
			
			if(pm.variableRowHeight)
			{
				//each item render can have its own height
				var n:int = _visibleIndexes.length;
				for (var i:int = 0; i <= index; i++)
				{
					var ir:IItemRenderer = (list.view as IListView).dataGroup.getItemRendererForIndex(_visibleIndexes[i]) as IItemRenderer;
					totalHeight += ir.element.clientHeight;
				}
				scrollArea.scrollTop = Math.min(totalHeight + ir.element.clientHeight - scrollArea.clientHeight, totalHeight);
			} else 
			{
				var rowHeight:Number;
				// all items renderers with same height
				rowHeight = isNaN(pm.rowHeight) ? ListPresentationModel.DEFAULT_ROW_HEIGHT : pm.rowHeight;
				totalHeight = _visibleIndexes.length * rowHeight - scrollArea.clientHeight;
				
				scrollArea.scrollTop = Math.min(index * rowHeight, totalHeight);
			}

			return oldScroll != scrollArea.scrollTop;
		}

		/**
		 * the filter function to use to filter entries in the list
		 * 
		 * Notice that defaultFilterFunction receive a text string, while a custom filter 
		 * function can receive the whole data object from the renderer so the user can make
		 * an kind of process over the data object and its subfields
		 */
		[Bindable]
		public var filterFunction:Function = defaultFilterFunction;
		
		/**
		 * enables label decoration when filter
		 */
		[Bindable]
		public var useDecoration:Boolean = true;

		/**
		 * enables label decoration when filter
		 */
		[Bindable]
		public function get length():int
		{
			return _visibleIndexes.length;
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher;
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand(KeyboardEvent.KEY_UP, textInputKeyUpHandler);
            listenOnStrand('beadsAdded', onBeadsAdded);
		}

		protected function onBeadsAdded(event:Event):void
		{
			var input:TextInputBase = TextInputBase(_strand);
            COMPILE::JS
			{
            input.element.addEventListener('focus', onInputFocus);
            }
		}

		protected function onInputFocus(event:Event):void
		{
			applyFilter(TextInputBase(_strand).text);
		}

		protected function textInputKeyUpHandler(event:KeyboardEvent):void
		{
			if(event.key === WhitespaceKeys.TAB)
				return;
				
			const inputBase:TextInputBase = event.target as TextInputBase;
			//keyup can include other things like tab navigation

			if (!inputBase)
				return;
            
			textInputKeyUpLogic(inputBase);
        }

		protected function textInputKeyUpLogic(input:Object):void
		{
			if(!list) return;
			
			// first remove a previous selection
			if(list.selectedIndex != -1)
				list.selectedItem = null;
			
			applyFilter(input.text);
		}

		/**
		 * default filter function just filters substrings
		 * you can use other advanced methods like levenshtein distance
		 * 
		 * notice that defaultFilterFunction receive a text string, while a custom filter 
		 * function can receive the whole data object from the renderer.
		 *
		 * @param text, the text where perform the seach
		 * @param filterText, the text to use as Filter
		 * @return true if filterText was found in text, false otherwise
		 */
		protected function defaultFilterFunction(text:String, filterText:String):Boolean
		{
			return text.toUpperCase().indexOf(filterText.toUpperCase()) > -1;
		}

		/**
		 * Used to decorated the filtered text
		 * 
		 * @param originalString, the original String
		 * @param toReplace, the string to replace
		 * @param decoration, the decoration to use, defaults to "strong"
		 * @return the originalString with the replacement performed
		 */
		protected function decorateText(originalString:String, location:int, len:int, decorationPrefix:String = "<span style='font-weight:bold; text-decoration: underline'>", decorationSufix:String = "</span>"):String
		{
			var str:String = originalString.substr(location, len);
			return originalString.replace(str , decorationPrefix + str + decorationSufix);
		}

        protected function applyFilter(filterText:String):void
		{
			var ir:ListItemRenderer;
            var numElements:int = list.numElements;
			var item:Object = null;
			_visibleIndexes = [];
            while (numElements--)
            {
                ir = list.getElementAt(numElements) as ListItemRenderer;
				var textData:String = getLabelFromData(ir, ir.data);
				if (filterFunction(filterFunction === defaultFilterFunction ? textData : ir.data, filterText))
				{
					ir.visible = true;
					visibleIndexes.push(ir.index);
					
					//stores the item if text is the same
					if(textData.toUpperCase() == filterText.toUpperCase())
						item = ir.data;

					//decorate text
					if(useDecoration)
					{
						ir.text = "<span>" + (filterText != "" ?  decorateText(textData, textData.toUpperCase().indexOf(filterText.toUpperCase()), filterText.length) : textData ) + "</span>";
					}
				} else {
					ir.visible = false;
				}
            }

			_visibleIndexes = _visibleIndexes.sort(numberSort);

			selectItem(item);
		}

		protected function selectItem(item:Object):void
		{
			// Select the item in the list if text is the same 
			// we do at the end to avoid multiple selection (if there's more than one matches)
			// in that case, select the first one in the list
			if(item != null)
				list.selectedItem = item;
		}

		private var _visibleIndexes: Array;
        /**
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function get visibleIndexes():Array
		{
			if(!_visibleIndexes)
			{
				_visibleIndexes = [];
				var len:int = list.numElements;
				var ir:ListItemRenderer;
				for(var i:int = 0; i < len; i++)
				{
					ir = (list.view as IListView).dataGroup.getItemRendererForIndex(i) as ListItemRenderer;
					if(ir.visible)
						_visibleIndexes.push(ir.index);
				}
			}
			return _visibleIndexes;
		}

		// order the indexes asc in array
		protected function numberSort(a:int, b:int):int
        {
            return a - b;
        }
	}
}
