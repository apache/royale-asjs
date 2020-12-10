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
    import org.apache.royale.jewel.beads.views.ComboBoxView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.ComboBox;
    import org.apache.royale.jewel.List;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.ValuesManager;


    /**
	 *  The ComboBoxListCloseOnClick bead class is a specialty bead that can be used with
     *  a Jewel ComboBox to allow closing ComBox popup in combobox with custom item renderer
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
    public class ComboBoxListCloseOnClick implements IBead{

        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
        public function ComboBoxListCloseOnClick(){
        }

        private var _list:List;
        private var comboView:ComboBoxView;


        public function set strand(value:IStrand):void
		{   
            var comboBox:ComboBox = (value as ComboBox);
            comboView = (comboBox.view as ComboBoxView);
            var itemRendererClass:Class = ValuesManager.valuesImpl.getValue(comboView.host, "iItemRenderer") as Class;
            // Apart from checking that the bead is applied to a Jewel ComboBox,
            // it is checked that the combobox has a custom item renderer assigned and that it does not have the SearchFilter bead
             if (comboView && (comboBox.itemRenderer || itemRendererClass != null)){
                (value as IEventDispatcher).addEventListener('popUpOpened', popUpOpenedHandler, false);
                (value as IEventDispatcher).addEventListener('popUpClosed', popUpClosedHandler, false);
             }
		}

        protected function popUpOpenedHandler():void {
			list = comboView.popup.view.list;
		}

		protected function popUpClosedHandler():void {
			list = null;
		}

        [Bindable]
		public function get list():List
		{
			return _list;
		}
        public function set list(value:List):void
        {
            _list = value;
            COMPILE::JS
			{
			if (list != null)
	            list.addEventListener(MouseEvent.CLICK, onListClick);
            }
        }

        private function onListClick(event:MouseEvent):void
        {
			list.removeEventListener(MouseEvent.CLICK, onListClick);
            comboView.popUpVisible = false;
        }
        
    }
}