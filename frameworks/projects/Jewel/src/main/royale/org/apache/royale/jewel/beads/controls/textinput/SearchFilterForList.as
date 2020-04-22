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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.itemRenderers.ListItemRenderer;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;

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
	public class SearchFilterForList implements IBead
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
			_list = value;

			if(_list != null)
			{
				length = list.numElements;
			}
		}

		/**
		 * the filter function to use to filter entries in the list
		 */
		[Bindable]
		public var filterFunction:Function = defaultFilterFunction;
		
		/**
		 * enables label decoration when filter
		 */
		[Bindable]
		public var useDecoration:Boolean = true;

		private var _length:int;

		/**
		 * enables label decoration when filter
		 */
		[Bindable]
		public function get length():int
		{
			return _length;
		}

		public function set length(value:int):void
		{
			_length = value;
		}

		
		protected var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(_strand).addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            IEventDispatcher(_strand).addEventListener('beadsAdded', onBeadsAdded);
		}

		protected function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.key === KeyboardEvent.KEYCODE__TAB)
				return;
				
			const inputBase:TextInputBase = event.target as TextInputBase;
			//keyup can include other things like tab navigation

			if (!inputBase) {
				//if (popUpVisible)  event.target.parent.view.popUpVisible = false;
				return;
			}
            
			keyUpLogic(inputBase);
        }

		protected function keyUpLogic(input:Object):void
		{
			// first remove a previous selection
			if(list.selectedIndex != -1)
			{
				list.selectedItem = null;
			}

			applyFilter(input.text);
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

		/**
		 * default filter function just filters substrings
		 * you can use other advanced methods like levenshtein distance
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
			length = numElements;
            while (numElements--)
            {
                ir = list.getElementAt(numElements) as ListItemRenderer;
				var textData:String = getLabelFromData(ir, ir.data);
                if (filterFunction(textData, filterText))
                {
                    ir.visible = true;
					
					//stores the item if text is the same
					if(textData.toUpperCase() == filterText.toUpperCase())
					{
						item = ir.data;
					}

					//decorate text
					if(useDecoration)
					{
						ir.text = "<span>" + (filterText != "" ?  decorateText(textData, textData.toUpperCase().indexOf(filterText.toUpperCase()), filterText.length) : textData ) + "</span>";
					}
                } else {
                    ir.visible = false;
					length--;
                }
            }

			// Select the item in the list if text is the same 
			// we do at the end to avoid multiple selection (if there's more than one matches)
			// in that case, select the first one in the list
			if(item != null)
			{
				list.selectedItem = item;
			}
		}
	}
}
