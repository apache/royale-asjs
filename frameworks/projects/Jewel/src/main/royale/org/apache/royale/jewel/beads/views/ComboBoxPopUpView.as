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
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.List;

    /**
	 * The ComboBoxPopUpView class is a view bead for the ComboBoxPopUp.
     * 
     * This class creates a list that will be pop up when the combo box needs
     * to show the associated list
     * 
	 * @viewbead	 
	 */
	public class ComboBoxPopUpView extends BeadViewBase
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ComboBoxPopUpView()
		{
			super();
		}
        
        /**
         *  Get the strand for this bead
         * 
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        override public function set strand(value:IStrand):void
		{
            _strand = value;
            
            var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;

            _list = new List();
            _list.model = model;
            
            IParent(_strand).addElement(_list);
		}

        private var _list:List;

        public function get list():List
        {
        	return _list;
        }
        public function set list(value:List):void
        {
        	_list = value;
        }
    }
}