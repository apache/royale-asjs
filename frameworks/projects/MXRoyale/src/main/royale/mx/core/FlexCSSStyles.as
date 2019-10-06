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

package mx.core
{
/*
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.controls.HScrollBar;
import mx.controls.VScrollBar;
import mx.controls.scrollClasses.ScrollBar;
import mx.core.IToolTip;
*/
import org.apache.royale.core.AllCSSStyles;
/*
import mx.events.ScrollEventDetail;
import mx.events.ScrollEventDirection;
import mx.managers.ToolTipManager;
import mx.styles.ISimpleStyleClient;

*/

/**
 *  The Flex styles holder.

 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class FlexCSSStyles extends AllCSSStyles
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    // add slots for Flex specific styles.
    public var horizontalGap:*;
    public var verticalGap:*;

}
}
