
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

package mx.managers
{

import flash.events.MouseEvent;

import mx.core.DragSource;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;

// [ExcludeClass]

/**
 *  @private
 */
public interface IDragManager
{
	function get isDragging():Boolean;
	function doDrag(
			dragInitiator:IUIComponent, 
			dragSource:DragSource,
			mouseEvent:MouseEvent,
			dragImage:IFlexDisplayObject = null, // instance of dragged item(s)
			xOffset:Number = 0,
			yOffset:Number = 0,
			imageAlpha:Number = 0.5,
			allowMove:Boolean = true):void;
	function acceptDragDrop(target:IUIComponent):void;
	function showFeedback(feedback:String):void;
	function getFeedback():String;
	function endDrag():void;
}

}

