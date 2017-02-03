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
package org.apache.flex.html
{
	import org.apache.flex.core.IComboBoxModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;            
    }
	
	[Event(name="change", type="org.apache.flex.events.Event")]
	
	/**
	 *  The ComboBox class is a component that displays an input field and
	 *  pop-up List with selections. Selecting an item from the pop-up List
	 *  places that item into the input field of the ComboBox. The ComboBox
	 *  uses the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the component.
	 *  org.apache.flex.core.IBeadController: the bead that handles input and output.
	 *  org.apache.flex.core.IPopUp: the bead responsible for displaying the selection list.
	 *  org.apache.flex.core.IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  org.apache.flex.core.IItemRenderer: the class or factory used to display an item in the component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ComboBox extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ComboBox()
		{
			super();
		}
		
		/**
		 *  The data for display by the ComboBox.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataProvider():Object
		{
			return IComboBoxModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			IComboBoxModel(model).dataProvider = value;
		}
		
		/**
		 *  The index of the currently selected item. Changing this item changes
		 *  the selectedItem value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedIndex():int
		{
			return IComboBoxModel(model).selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			IComboBoxModel(model).selectedIndex = value;
		}
		
		/**
		 *  The item that is currently selected. Changing this item changes
		 *  the selectedIndex.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedItem():Object
		{
			return IComboBoxModel(model).selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			IComboBoxModel(model).selectedItem = value;
		}
		
        COMPILE::JS
        {
            private var button:WrappedHTMLElement;
            private var input:WrappedHTMLElement;
        }
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {            
            element = document.createElement('div') as WrappedHTMLElement;
            
            input = document.createElement('input') as WrappedHTMLElement;
            input.style.position = 'absolute';
            input.style.width = '80px';
            element.appendChild(input);
            
            button = document.createElement('div') as WrappedHTMLElement;
            button.style.position = 'absolute';
            button.style.top = '0px';
            button.style.right = '0px';
            button.style.background = '#bbb';
            button.style.width = '16px';
            button.style.height = '20px';
            button.style.margin = '0';
            button.style.border = 'solid #609 1px';
            goog.events.listen(button, 'click', buttonClicked);
            element.appendChild(button);
            
            positioner = element;
            positioner.style.position = 'relative';
            
            // add a click handler so that a click outside of the combo box can
            // dismiss the pop-up should it be visible.
            goog.events.listen(document, 'click',
                dismissPopup);
            
            input.flexjs_wrapper = this;
            
            return element;
        }        

        COMPILE::JS
        private var popup:HTMLElement;
        
        /**
         * @param event The event.
         * @flexjsignorecoercion HTMLSelectElement
         * @flexjsignorecoercion HTMLInputElement
         */
        COMPILE::JS
        private function selectChanged(event:Event):void
        {
            var select:HTMLSelectElement;
            
            select = event.currentTarget as HTMLSelectElement;
            
            selectedItem = select.options[select.selectedIndex].value;
            
            popup.parentNode.removeChild(popup);
            popup = null;
            
            dispatchEvent(event);
        }
        
        
        /**
         * @param event The event.
         */
        COMPILE::JS
        private function dismissPopup(event:Event):void
        {
            // remove the popup if it already exists
            if (popup) {
                popup.parentNode.removeChild(popup);
                popup = null;
            }
        }
        
        
        /**
         * @export
         * @param {Object} event The event.
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLElement
         * @flexjsignorecoercion HTMLSelectElement
         * @flexjsignorecoercion HTMLOptionElement
         * @flexjsignorecoercion Array
         */
        COMPILE::JS
        private function buttonClicked(event:Event):void
        {
            var dp:Array;
            var i:int;
            var input:HTMLInputElement;
            var left:Number;
            var n:int;
            var opt:HTMLOptionElement;
            var pn:HTMLElement;
            var popup:HTMLElement;
            var select:HTMLSelectElement;
            var si:int;
            var top:Number;
            var width:Number;
            
            event.stopPropagation();
            
            if (popup) {
                dismissPopup(null);
                
                return;
            }
            
            input = element.childNodes.item(0) as HTMLInputElement;
            
            pn = element;
            top = pn.offsetTop + input.offsetHeight;
            left = pn.offsetLeft;
            width = pn.offsetWidth;
            
            popup = document.createElement('div') as HTMLElement;
            popup.className = 'popup';
            popup.id = 'test';
            popup.style.position = 'absolute';
            popup.style.top = top.toString() + 'px';
            popup.style.left = left.toString() + 'px';
            popup.style.width = width.toString() + 'px';
            popup.style.margin = '0px auto';
            popup.style.padding = '0px';
            popup.style.zIndex = '10000';
            
            select = document.createElement('select') as HTMLSelectElement;
            select.style.width = width.toString() + 'px';
            goog.events.listen(select, 'change', selectChanged);
            
            dp = dataProvider as Array;
            n = dp.length;
            for (i = 0; i < n; i++) {
                opt = document.createElement('option') as HTMLOptionElement;
                opt.text = dp[i];
                select.add(opt, null);
            }
            
            select.size = n;
            
            si = selectedIndex;
            if (si < 0) {
                select.value = null;
            } else {
                select.value = dp[si];
            }
            
            this.popup = popup;
            
            popup.appendChild(select);
            document.body.appendChild(popup);
        }

	}
}
