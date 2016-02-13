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

import mx.managers.IFocusManager;

/**
 *  IContainer is a interface that indicates a component
 *  extends or mimics mx.core.Container
 *
 *  @see mx.core.Container
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IContainer extends IUIComponent
{

COMPILE::AS3
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;		
	import flash.geom.Rectangle;
}
COMPILE::JS
{
	import flex.display.DisplayObject;
	import flex.display.Sprite;		
	import org.apache.flex.geom.Rectangle;
}
COMPILE::LATER
{
	import flash.display.Graphics;
	import flash.media.SoundTransform;
}

include "ISpriteInterface.as"
include "IDisplayObjectContainerInterface.as"
include "IInteractiveObjectInterface.as"

    /**
     *  @copy mx.core.Container#defaultButton
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get defaultButton():IFlexDisplayObject;
    function set defaultButton(value:IFlexDisplayObject):void;

    /**
     *  @copy mx.core.Container#creatingContentPane
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get creatingContentPane():Boolean;
    function set creatingContentPane(value:Boolean):void;

    /**
     *  @copy mx.core.Container#viewMetrics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get viewMetrics():EdgeMetrics;

    /**
     *  @copy mx.core.Container#horizontalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get horizontalScrollPosition():Number;
    function set horizontalScrollPosition(value:Number):void;

    /**
     *  @copy mx.core.Container#verticalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get verticalScrollPosition():Number;
    function set verticalScrollPosition(value:Number):void;

    /**
     *  @copy mx.core.UIComponent#focusManager
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get focusManager():IFocusManager;
}

}
