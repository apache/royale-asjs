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
package org.apache.royale.jewel.beads.controls.combobox
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.jewel.beads.controls.combobox.IComboBoxView;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.itemRenderers.ListItemRenderer;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;

	/**
	 *  The SearchFilter bead class is a specialty bead that can be used with
     *  a Jewel ComboBox to filter options as we type
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.5
	 */
	public class SearchFilter implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.5
		 */
		public function SearchFilter()
		{
		}

		private var _textInput:TextInputBase;


		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.5
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(_strand).addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            IEventDispatcher(_strand).addEventListener('beadsAdded', onBeadsAdded);
		}

		protected function onBeadsAdded(event:Event):void{
            COMPILE::JS{
                if ('view' in _strand && _strand['view'] is IComboBoxView) {
                    _textInput = IComboBoxView(_strand['view']).textinput as TextInputBase;
                    if (_textInput) {
                        _textInput.element.addEventListener( 'focus', onInputFocus);
                    }
                }
            }
		}

		/**
		 * the filter function to use to filter entries in the combobox popup list
		 */
		[Bindable]
		public var filterFunction:Function = defaultFilterFunction;

		/**
		 * default filter function just filters substrings
		 * you can use other advanced methods like levenshtein distance
		 */
		protected function defaultFilterFunction(text:String, filterText:String):Boolean
		{
			return text.toUpperCase().indexOf(filterText) > -1;
		}

		COMPILE::JS
		protected function onInputFocus(event:Event):void{
            var popUpVisible:Boolean =  IComboBoxView(_strand['view']).popUpVisible;
            if (!popUpVisible) {
                //force popup ?:
                IComboBoxView(_strand['view']).popUpVisible = true;

                //or avoid ?:
                //return;
            }
            applyFilter(_textInput);
		}

        protected function keyUpHandler(event:KeyboardEvent):void
		{
			const inputBase:TextInputBase = event.target as TextInputBase;
			//keyup can include other things like tab navigation
            IComboBoxView
			if (!inputBase) {
				//if (popUpVisible)  event.target.parent.view.popUpVisible = false;
				return;
			}
            var popUpVisible:Boolean =  event.target.parent.view.popUpVisible;
            if (!popUpVisible) {
                //force popup ?:
                event.target.parent.view.popUpVisible = true;

                //or avoid ?:
                //return;
            }
            applyFilter(inputBase);
        }

        protected function applyFilter(input:TextInputBase):void{
            var filterText:String = input.text.toUpperCase();

            // the internal list in the combobox popup
            var list:List =  Object(input).parent.view.popup.view.list;

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
            if (count == 1) {
                //select lastActive if there is only one that matches?

            }
		}

	}
}
