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
			applyFilter(input.text.toUpperCase());
		}

		protected function onBeadsAdded(event:Event):void{
			var input:TextInputBase = TextInputBase(_strand);
            COMPILE::JS{
                input.element.addEventListener('focus', onInputFocus);
            }
		}

		protected function onInputFocus(event:Event):void
		{
			applyFilter(TextInputBase(_strand).text.toUpperCase());
		}

		/**
		 * default filter function just filters substrings
		 * you can use other advanced methods like levenshtein distance
		 */
		protected function defaultFilterFunction(text:String, filterText:String):Boolean
		{
			return text.toUpperCase().indexOf(filterText) > -1;
		}

        protected function applyFilter(filterText:String):void
		{
            var ir:ListItemRenderer;
            var numElements:int = list.numElements;
            var count:uint = 0;
            var lastActive:ListItemRenderer;
            for (var i:int = 0; i < numElements; i++)
            {
                ir = list.getElementAt(i) as ListItemRenderer;
                if (filterFunction(ir.text, filterText))
                {
                    ir.visible = true;
                    lastActive = ir;
                    count++;
                } else {
                    ir.visible = false;
                }
            }
			/* if (count == 1) {
				//select lastActive if there is only one that matches?
			}*/
		}

	}
}
