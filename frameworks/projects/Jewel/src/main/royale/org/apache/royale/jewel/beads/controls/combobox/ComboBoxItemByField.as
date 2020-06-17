package com.iest.winplusweb.beads
{
  import org.apache.royale.core.IBead;
  import org.apache.royale.jewel.ComboBox;
  import org.apache.royale.core.IStrand;
  import org.apache.royale.collections.CollectionUtils;
  import org.apache.royale.collections.ArrayList;
  import org.apache.royale.events.Event;

  public class ComboBoxItemByField implements IBead{

      protected var comboBox:ComboBox;


      public function ComboBoxItemByField()
		{
		}

        public function set strand(value:IStrand):void
		{
			comboBox = value as ComboBox;
			comboBox.addEventListener("selectionChanged", selectionChangedHandler);
			updateHost();
		}

        private var _valueField:String;
        
        public function get valueField():String
        {
            return _valueField;
        }
        public function set valueField(value:String):void
        {
            _valueField = value;
			updateHost();
        }

        private var _selectedValue:*;

        public function get selectedValue():*{
            return _selectedValue;
        }

        public function set selectedValue(value:*):void{
            _selectedValue = value;
            updateHost();
        }

        protected function updateHost():void
		{
			if(comboBox && valueField != "" && selectedValue != null){
			    var aux:* = CollectionUtils.getItemByField(comboBox.dataProvider as ArrayList,valueField,selectedValue);
                if(aux == null){
                    comboBox.selectedItem = null;
                    comboBox.selectedIndex = -1;
                } else if (aux!==comboBox.selectedItem){
                    comboBox.selectedItem = aux;
                }
            }
		}

        protected function selectionChangedHandler(event:Event):void{
            if(valueField != "" && comboBox){
                var selectedItem:Object = comboBox.selectedItem;
                if(selectedItem != null && selectedValue !== selectedItem[valueField])
                    selectedValue = selectedItem[valueField];
            }
        }

  }   
}