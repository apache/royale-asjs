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
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.itemRenderers.ListItemRenderer;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;
	import org.apache.royale.jewel.supportClasses.util.getLabelFromData;

	/**
	 *  The SearchFilterForList bead class is a specialty bead that can be used with
     *  a Jewel TextInput to filter options in other List component
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

		/**
		 * the list to filter
		 */
		[Bindable]
		public var list:List;

		/**
		 * the filter function to use to filter entries in the list
		 */
		[Bindable]
		public var filterFunction:Function = defaultFilterFunction;
		
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
		protected function decorateText(originalString:String, location:int, len:int, decorationPrefix:String = "<strong><u>", decorationSufix:String = "</u></strong>"):String
		{
			var str:String = originalString.substr(location, len);
			return originalString.replace(str , decorationPrefix + str + decorationSufix);
		}

        protected function applyFilter(filterText:String):void
		{
            var ir:ListItemRenderer;
            var numElements:int = list.numElements;
			var item:Object = null;
            while (numElements--)
            {
                ir = list.getElementAt(numElements) as ListItemRenderer;
				ir.addClass("preserveWhiteSpaces");
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
					ir.text = filterText != "" ? decorateText(textData, textData.toUpperCase().indexOf(filterText.toUpperCase()), filterText.length) : textData;
                } else {
                    ir.visible = false;
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
