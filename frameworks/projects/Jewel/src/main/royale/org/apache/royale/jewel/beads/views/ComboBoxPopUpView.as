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
    import org.apache.royale.core.ClassFactory;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IItemRendererClassFactory;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ItemRendererClassFactory;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.List;
    import org.apache.royale.jewel.supportClasses.combobox.ComboBoxPopUp;
    import org.apache.royale.jewel.supportClasses.combobox.IComboBoxPresentationModel;
    import org.apache.royale.jewel.beads.models.ListPresentationModel;
    
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

            // set model
            var model:IDataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
            list.model = model;

            // set rowHeight
            var _presentationModel:IComboBoxPresentationModel = (_strand as ComboBoxPopUp).presentationModel as IComboBoxPresentationModel;
            
            // set height based on rowCount
            var rowCount:int = _presentationModel.rowCount;
            var len:int;

            // if num records in dp is less than rowCount height should adapt the height
            if(list.dataProvider)
            {
                len = list.dataProvider.length;

                if(len < rowCount)
                    rowCount = len;
            }
            
            // trace("_presentationModel.rowHeight: ", _presentationModel.rowHeight);
            if(isNaN( _presentationModel.rowHeight))
                _presentationModel.rowHeight = ListPresentationModel.DEFAULT_ROW_HEIGHT;
            // trace("rowCount: ", rowCount);
            // trace("list.height: ", list.height);
            list.height = rowCount * _presentationModel.rowHeight;
            // trace(" list.height: ", list.height);

            IParent(_strand).addElement(list);
		}
        
        protected var _list:List;
        /**
         *  The list part
         * @return 
         */
        public function get list():List
        {
            if(!_list) {
                _list = new List();
                _list.addEventListener("beadsAdded", beadsAddedHandler);
            }
            return _list;
        }

        /**
         *  If  user defines item render in the combo, this must be pased to popup list
         *  Modify the item renderer class to instantiate renderers configured in the ComboBox instance
         * 
         *  @param event 
         */
        public function beadsAddedHandler(event:Event):void
		{
            _list.removeEventListener("beadsAdded", beadsAddedHandler);
            
            // ComboBoxView pass the itemRendererClass to the ComboBoxPopUp
            var itemRendererClass:Class = (_strand as ComboBoxPopUp).itemRendererClass;

            if(itemRendererClass)
            {
                var factory:ItemRendererClassFactory = list.getBeadByType(IItemRendererClassFactory) as ItemRendererClassFactory;
                factory.itemRendererFactory = new ClassFactory(itemRendererClass);
            }
        }
    }
}