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
    import org.apache.royale.core.IBeadView;
    
	/**
	 *  The IComboBoxView interface provides the protocol for any bead that
	 *  creates the visual parts for a org.apache.royale.jewel.ComboBox control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public interface IComboBoxView extends IBeadView
	{
		/**
		 *  The sub-component used for the input area of the ComboBox.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		function get textinput():Object;
		
		/**
		 *  The sub-component used for the button to activate the pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		function get button():Object;
		
		/**
		 *  The component housing the selection list. The main component must be a placeholder
		 *  that support responsiveness and holds a subcomponent that parents the list or other possible
		 *  components needed in other implementations.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		function get popup():Object;
		
		/**
		 *  Determines whether or not the pop-up with the selection list is visible or not.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		function get popUpVisible():Boolean;
		function set popUpVisible(value:Boolean):void;
	}
}
