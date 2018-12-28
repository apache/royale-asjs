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
package mx.controls.beads.controllers
{
    import mx.collections.XMLListCollection;
    import mx.controls.MenuBar;
    
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.IMenu;
    import org.apache.royale.core.IStrandWithPresentationModel;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.html.beads.controllers.MenuBarMouseController;
	
    /**
     *  MenuBar Mouse Controller
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class MenuBarMouseController extends org.apache.royale.html.beads.controllers.MenuBarMouseController
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function MenuBarMouseController()
		{
		}
		
        override protected function getMenuDataProvider(obj:Object, fieldName:String):Object
        {
            if (obj is XML)
                return new XMLListCollection((obj as XML).children());
            return obj[fieldName];
        }

        /**
         *  track menus for testing
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override protected function showMenu(menu:IMenu, component:IUIBase):void
		{
            super.showMenu(menu, component);
            var swpm:IStrandWithPresentationModel = menu as IStrandWithPresentationModel;
            if (swpm)
            {
                var lpm:IListPresentationModel = swpm.presentationModel as IListPresentationModel;
                if (lpm)
                    lpm.rowHeight = 20;
            }
            (_strand as MenuBar).menus = [ menu ];
		}
	}
}
