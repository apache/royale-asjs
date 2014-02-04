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
package org.apache.flex.html.staticControls
{
    import org.apache.flex.core.ISelectionModel;
    
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
         */
        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
        }
        
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
         */
        public function set selectedIndex(value:int):void
        {
            ISelectionModel(model).selectedIndex = value;
        }
        

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
         */
        public function set selectedItem(value:Object):void
        {
            ISelectionModel(model).selectedItem = value;
        }
                        
    }
}