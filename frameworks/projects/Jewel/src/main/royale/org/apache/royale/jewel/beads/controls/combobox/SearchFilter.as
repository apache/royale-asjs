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
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.KeyboardEvent;
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

        protected function keyUpHandler(event:KeyboardEvent):void
		{
			var filterText:String = (event.target as TextInputBase).text.toUpperCase();
			
			// the internal list in the combobox popup
			var list:List = event.target.parent.view.popup.view.list;

			var ir:ListItemRenderer;
			var numElements:int = list.numElements;
			for (var i:int = 0; i < numElements; i++)
			{
				ir = list.getElementAt(i) as ListItemRenderer;
				if(filterFunction(ir.text, filterText))
				{
					ir.visible = true;
				} else {
					ir.visible = false;
				}
			}
        }
	}
}
