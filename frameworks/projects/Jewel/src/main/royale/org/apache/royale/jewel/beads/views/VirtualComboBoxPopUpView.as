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
package org.apache.royale.jewel.beads.views
{
    import org.apache.royale.jewel.List;
    import org.apache.royale.jewel.VirtualList;

    /**
	 *  The VirtualComboBoxPopUpView class is a view bead for the VirtualComboBoxPopUp.
     * 
     *  This class creates a VirtualList that will be pop up when the combo box needs
     *  to show the associated list
     * 
	 *  @viewbead	 
	 */
	public class VirtualComboBoxPopUpView extends ComboBoxPopUpView
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function VirtualComboBoxPopUpView()
		{
			super();
		}
        
        override public function get list():List
        {
            if(!_list) {
                _list = new VirtualList();
				_list.addEventListener("beadsAdded", beadsAddedHandler);
            }
            return _list;
        }
    }
}