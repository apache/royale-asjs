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
package org.apache.royale.jewel.beads.controllers
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.jewel.ToggleButtonBar;
	import org.apache.royale.jewel.beads.controllers.ListSingleSelectionMouseController;

    /**
     *  The Jewel ToggleButtonBarSelectionMouseController class is a controller for
     *  org.apache.royale.jewel.ToggleButtonBar.
     * 
     *  It works like ListSingleSelectionMouseController but will consider `toggleOnClick` 
     *  so when is active selectedIndex can be -1 when no button is selected
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
	public class ToggleButtonBarSelectionMouseController extends ListSingleSelectionMouseController
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		public function ToggleButtonBarSelectionMouseController()
		{
		}

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  
         *  @royaleignorecoercion org.apache.royale.jewel.ToggleButtonBar
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
            toggleButtonBar = value as ToggleButtonBar;
		}

        private var toggleButtonBar:ToggleButtonBar;

        /**
         * If `toggleOnClick` is active, unselecting the current button will make selectedIndex -1
         */
        override protected function selectedHandler(event:ItemClickedEvent):void
		{
            if(toggleButtonBar.toggleOnClick && (event.index == listModel.selectedIndex))
            {
                event.index = -1;
                event.data  = null;
            }
            super.selectedHandler(event);
		}
	}
}
