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
package mx.controls.beads.models
{
    import mx.controls.MenuBar;
    
    import org.apache.royale.core.IMenu;
    import org.apache.royale.core.IMenuBarModel;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.models.ArraySelectionModel;
	
    /**
     *  MenuBar Mouse Controller
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class MenuBarModel extends ArraySelectionModel implements IMenuBarModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function MenuBarModel()
		{
            labelField = "label";
            submenuField = "children";
		}
		
        private var _submenuField:String = "menu";
        
        /**
         * The field in the data object that identifies sub-menus. The default is "menu". This
         * value is transferred to the CascadingMenu opened for each menu item.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function get submenuField():String
        {
            return _submenuField;
        }
        public function set submenuField(value:String):void
        {
            _submenuField = value;
            dispatchEvent(new Event("submenuFieldChanged"));
        }

        private var _showRoot:Boolean = true;
		
        /**
         *  showRoot
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get showRoot():Boolean
		{
            return _showRoot;
		}
        public function set showRoot(value:Boolean):void
        {
            _showRoot = value;
        }
        
        override public function get dataProvider():Object
        {
            var dp:Object = super.dataProvider;
            
            if (!showRoot && dp != null)
            {
                return dp.getItemAt(0).children; // TODO: needs to use descriptor
            }
            
            return dp;
        }
	}
}
