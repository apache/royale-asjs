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

package mx.controls
{

/* import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.getTimer; */

import org.apache.royale.events.Event;
import mx.events.FocusEvent;
import mx.events.KeyboardEvent;
import mx.events.MouseEvent;

import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.IFlexDisplayObject;
import mx.core.ILayoutDirectionElement;
import mx.core.IRectangularBorder;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
//import mx.events.DropdownEvent;
//import mx.events.FlexMouseEvent;
//import mx.events.InterManagerRequest;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;



public class PopUpButton extends Button 
{
    //include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PopUpButton()
    {
        super();               
        //addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        //addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }
    
}

}
