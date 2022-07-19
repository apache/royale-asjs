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
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.ComboBoxView;
    import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.html.util.getModelByType;
    import org.apache.royale.html.util.getLabelFromXMLData;
    import org.apache.royale.html.TextInput;
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
	public class ComboBoxView extends org.apache.royale.html.beads.ComboBoxView
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
            var sendClose:Boolean = !value && list.visible;
            super.popUpVisible = value;
            if (sendClose)
                IEventDispatcher(_strand).dispatchEvent(new Event("close"));
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

        override protected function itemChangeAction():void
        {
            var model:IComboBoxModel = getModelByType(_strand,IComboBoxModel) as IComboBoxModel;
            var selectedItem:Object = model.selectedItem;
            if (selectedItem is XML)
            {
                (textInputField as TextInput).text = getLabelFromXMLData(model, selectedItem as XML);
            } else
            {
                super.itemChangeAction();
            }
        }
	}
}
