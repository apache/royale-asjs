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
package org.apache.royale.jewel
{
	import org.apache.royale.core.ISelectionModel;

	/**
	 *  The Jewel ToggleButtonBar class is a component that displays a set of ToggleButtons. The ToggleButtonBar
	 *  is actually an IconButtonBar with an itemRenderer that produces Jewel ToggleButtons.
	 *  
	 *  By default buttons are equally sized, by setting `widthType` to NaN.
	 *  
	 *  The ToggleButtonBar uses the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model for the ButtonBar, including the dataProvider.
	 *  org.apache.royale.core.IBeadView: constructs the parts of the component.
	 *  org.apache.royale.core.IBeadController: handles input events.
	 *  org.apache.royale.core.IBeadLayout: sizes and positions the component parts.
	 *  org.apache.royale.core.IDataProviderItemRendererMapper: produces itemRenderers.
	 *  org.apache.royale.core.IItemRenderer: the class or class factory to use.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class ToggleButtonBar extends IconButtonBar
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function ToggleButtonBar()
		{
			super();

			//ToggleButtonBar is always selected, so selectedIndex can't be -1, at least it will default to 0
			ISelectionModel(model).selectedIndex = 0;
			toggleOnClick = false;
		}

		private var _toggleOnClick:Boolean;
		/**
		 * Specifies whether the currently selected button can be deselected by the user. 
		 * By default, the currently selected button gets deselected automatically only when 
		 * another button in the group is selected. 
		 * 
		 * Setting this property to true lets the user deselect it. 
		 * When the currently selected button is deselected, the selectedIndex property is set to -1.
		 */
		public function get toggleOnClick():Boolean
		{
			return _toggleOnClick;
		}
		public function set toggleOnClick(value:Boolean):void
		{
			if (_toggleOnClick != value)
            {
                _toggleOnClick = value;
				toggleClass("toggle-on-click", !_toggleOnClick);
            }
		}

		// private var _allowMultipleSelection:Boolean = false;
		/**
		 * if true, allow more than one button selected. If false, just one button can be selected at a time
		 * When true will make `toggleOnClick` true to allow deselect buttons in the bar.
		 */
		// public function get allowMultipleSelection():Boolean
		// {
		// 	return _allowMultipleSelection;
		// }
		// public function set allowMultipleSelection(value:Boolean):void
		// {
		// 	if (_allowMultipleSelection != value)
        //     {
		// 		_allowMultipleSelection = value;
		// 		if(_allowMultipleSelection)
		// 			toggleOnClick = _allowMultipleSelection;
		// 	}
		// }
	}
}
