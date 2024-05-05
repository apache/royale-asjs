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
package mx.controls.beads
{
    import mx.controls.ComboBox;
    import mx.controls.listClasses.ListBase;
    import mx.events.DropdownEvent;

    import org.apache.royale.core.IComboBoxModel;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.html.util.getModelByType;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.ComboBoxView;

    import org.apache.royale.html.TextInput;
    import org.apache.royale.html.TextButton;

    import mx.core.UIComponent;

    import org.apache.royale.core.IStrand;
    import mx.controls.ComboBase;
    import org.apache.royale.core.IRenderedObject;
    /**
     *  The ComboBoxView class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ComboBoxView extends org.apache.royale.html.beads.ComboBoxView implements IComboBoxView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ComboBoxView()
		{
        }

        override protected function sizeChangeAction():void
        {
            var host:UIBase = UIBase(_strand);

            var input:TextInput = textInputField as TextInput;
            var button:TextButton = popupButton as TextButton;

            input.x = 0;
            input.y = 0;
            if (host.isWidthSizedToContent()) {
                input.width = UIComponent.DEFAULT_MEASURED_WIDTH - 20;
            } else {
                input.width = host.width - 20;
            }

            button.x = input.width;
            button.y = 0;
            button.width = 20;


            COMPILE::JS {
                input.element.style.position = "absolute";
                button.element.style.position = "absolute";
            }

            if (host.isHeightSizedToContent()) {
                host.height = input.height = UIComponent.DEFAULT_MEASURED_HEIGHT;
            } else {
                input.height = host.height;
            }
            button.height = input.height;

            if (host.isWidthSizedToContent()) {
                host.width = input.width + button.width;
            }
        }

        /**
         * The content area of the panel.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         */
        override public function set popUpVisible(value:Boolean):void
        {
           // var sendClose:Boolean = !value && list.visible;
            if (popUpVisible == value) return;
            setPopupVisible(value)
            /*if (sendClose)
                IEventDispatcher(_strand).dispatchEvent(new Event("close"));*/

            var cbdEvent:DropdownEvent =
                    new DropdownEvent(value ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
            cbdEvent.triggerEvent = null;
            IEventDispatcher(_strand).dispatchEvent(cbdEvent);
        }


        public function setPopupVisible(value:Boolean):void{
            super.popUpVisible = value;
        }

        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            (value as IEventDispatcher).addEventListener("editableChanged", syncEditable);
            syncEditable();
        }

        protected function syncEditable(event:Event=null):void
        {
            COMPILE::JS
            {
                if ((_strand as ComboBase).editable)
                {
                    (textInputField as IRenderedObject).element.removeAttribute("readonly");
                } else
                {
                    (textInputField as IRenderedObject).element.setAttribute("readonly", true);
                }
            }
        }

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
         * @royaleignorecoercion mx.controls.ComboBox
         */
        override protected function itemChangeAction():void
        {
            var model:IComboBoxModel = getModelByType(_strand,IComboBoxModel) as IComboBoxModel;
            textInputField.text = ComboBox(_strand).itemToLabel(model.selectedItem);
        }

        public function get editable():Boolean {
            return ComboBox(_strand).editable;
        }
		
	}
}
