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
    import org.apache.royale.jewel.supportClasses.combobox.ComboBoxPopUp;
    import org.apache.royale.jewel.supportClasses.combobox.IComboBoxPresentationModel;

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
         * 
         *  @royaleignorecoercion org.apache.royale.jewel.List
         */
        override public function set strand(value:IStrand):void
		{
            _strand = value;
            
            var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
            list.model = model;

            var _presentationModel:IComboBoxPresentationModel = (_strand as ComboBoxPopUp).presentationModel as IComboBoxPresentationModel;
            list.rowHeight = _presentationModel.rowHeight;

            // use rowCount to configure height
            var rowCount:int = _presentationModel.rowCount;

            // var view:IListView = list.view as IListView;
            // var dataGroup:IItemRendererParent = view.dataGroup;

            // var factory:IItemRendererClassFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", list) as IItemRendererClassFactory;
            // var ir:ISelectableItemRenderer = factory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
            list.height = rowCount * list.rowHeight; //(ir as IUIBase).height;

            IParent(_strand).addElement(list);
		}

        protected var _list:List;
        public function get list():List
        {
            if(!_list) {
                _list = new List();
            }
            return _list;
        }

    }
}