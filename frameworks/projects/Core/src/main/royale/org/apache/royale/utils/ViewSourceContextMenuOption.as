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
package org.apache.royale.utils
{

COMPILE::SWF
{
    import flash.display.InteractiveObject;
    import flash.events.ContextMenuEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
}

import org.apache.royale.core.IInitialViewApplication;
import org.apache.royale.core.IBead;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.Bead;

/**
 *  The ViewSourceContextMenuOption class is a class that 
 *  implements the "View Source" option in Flash for a
 *  Royale application.  There is no JS equivalent as
 *  browsers always display source.    
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class ViewSourceContextMenuOption extends Bead
{
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function ViewSourceContextMenuOption()
    {
    }

	
    /**
     *  @copy org.apache.royale.core.UIBase#strand
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	override public function set strand(value:IStrand):void
	{
		_strand = value;
		
        {
    		var menuHost:InteractiveObject = InteractiveObject(IInitialViewApplication(value).$displayObject);
    		var cm:ContextMenu = ContextMenu(menuHost.contextMenu);
    		if (!cm)
    		{
    			cm = new ContextMenu();
    			menuHost.contextMenu = cm;
    		}
    		var cmi:ContextMenuItem = new ContextMenuItem("View Source...");
    		cm.hideBuiltInItems();
    		cm.customItems.push(cmi);
    		cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, viewSource);
        }
	}
	
    COMPILE::SWF
	private function viewSource(e:ContextMenuEvent):void
	{
		var urlRequest:URLRequest = new URLRequest("srcview/index.html");
		navigateToURL(urlRequest, "_blank");	
	}
}
}
