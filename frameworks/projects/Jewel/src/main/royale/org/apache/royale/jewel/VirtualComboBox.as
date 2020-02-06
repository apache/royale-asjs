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
	/**
	 *  The VirtualComboBox class is a component that displays an input field and
	 *  pop-up VirtualList with selections. Selecting an item from the pop-up List
	 *  places that item into the input field of the ComboBox.
	 *  
	 *  This component should be used when data provider has several items for performance
	 *  improvements
	 * 
	 *  The ComboBox uses the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the component.
	 *  org.apache.royale.core.IBeadController: the bead that handles input and output.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class VirtualComboBox extends ComboBox
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function VirtualComboBox()
		{
			super();
		}
   	}
}
