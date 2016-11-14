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
    import org.apache.flex.core.ISelectionModel;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;            
        import org.apache.flex.html.beads.models.ArraySelectionModel;
    }
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user selects an item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="change", type="org.apache.flex.events.Event")]
    
    /**
     *  The DropDownList class implements the basic equivalent of
     *  the <code>&lt;select&gt;</code> tag in HTML.
     *  The default implementation only lets the user see and
     *  choose from an array of strings.  More complex controls
     *  would display icons as well as strings, or colors instead
     *  of strings or just about anything.
     * 
     *  The default behavior only lets the user choose one and 
     *  only one item.  More complex controls would allow
     *  mutiple selection by not dismissing the dropdown as soon
     *  as a selection is made.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class DropDownList extends Button
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DropDownList()
		{
            COMPILE::JS
            {
                model = new ArraySelectionModel();
            }
		}
		
        /**
         *  The data set to be displayed.  Usually a simple
         *  array of strings.  A more complex component
         *  would allow more complex data and data sets.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get dataProvider():Object
        {
            return ISelectionModel(model).dataProvider;
        }

        /**
         *  @private
         *  @flexjsignorecoercion HTMLOptionElement
         *  @flexjsignorecoercion HTMLSelectElement
         */
        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
            COMPILE::JS
            {
                var dp:HTMLOptionsCollection;
                var i:int;
                var n:int;
                var opt:HTMLOptionElement;
                var dd:HTMLSelectElement = element as HTMLSelectElement;
                
                model.dataProvider = value;
                dp = dd.options;
                n = dp.length;
                for (i = 0; i < n; i++) {
                    dd.remove(0);
                }
                
                var lf:String = labelField;
                n = value.length;
                for (i = 0; i < n; i++) {
                    opt = document.createElement('option') as HTMLOptionElement;
                    if (lf)
                        opt.text = value[i][lf];
                    else
                        opt.text = value[i];
                    dd.add(opt, null);
                }

            }
        }
        
        [Bindable("change")]
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedIndex
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get selectedIndex():int
        {
            return ISelectionModel(model).selectedIndex;
        }

        /**
         *  @private
         *  @flexjsignorecoercion HTMLSelectElement
         */
        public function set selectedIndex(value:int):void
        {
            ISelectionModel(model).selectedIndex = value;
            COMPILE::JS
            {
                (element as HTMLSelectElement).selectedIndex = ISelectionModel(model).selectedIndex;
            }
        }
        

        [Bindable("change")]
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedItem
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get selectedItem():Object
        {
            return ISelectionModel(model).selectedItem;
        }

        /**
         *  @private
         *  @flexjsignorecoercion HTMLSelectElement
         */
        public function set selectedItem(value:Object):void
        {
            ISelectionModel(model).selectedItem = value;
            COMPILE::JS
            {
                (element as HTMLSelectElement).selectedIndex = ISelectionModel(model).selectedIndex;
            }
        }
                        
        /**
         *  The name of field within the data used for display. Each item of the
         *  data should have a property with this name.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get labelField():String
        {
            return ISelectionModel(model).labelField;
        }
        public function set labelField(value:String):void
        {
            ISelectionModel(model).labelField = value;
        }
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLSelectElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            element = document.createElement('select') as WrappedHTMLElement;
            (element as HTMLSelectElement).size = 1;
            goog.events.listen(element, 'change',
                changeHandler);
            
            positioner = element;
            
            
            element.flexjs_wrapper = this;
            
            return element;
        } 
        
        /**
         * @flexjsignorecoercion HTMLSelectElement
         */
        COMPILE::JS
        protected function changeHandler(event:Event):void
        {
            model.selectedIndex = (element as HTMLSelectElement).selectedIndex;
        }
    }
}
