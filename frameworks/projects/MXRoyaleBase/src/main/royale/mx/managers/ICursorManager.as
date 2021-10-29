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

import mx.core.IUIComponent;

[ExcludeClass]

/**
 *  @private
 */
public interface ICursorManager
{
	function get currentCursorID():int;
	function set currentCursorID(value:int):void;
    function get currentCursorXOffset():Number
	function set currentCursorXOffset(value:Number):void;
    function get currentCursorYOffset():Number
	function set currentCursorYOffset(value:Number):void;

	function showCursor():void;
	function hideCursor():void;
	function setCursor(cursorClass:Class, priority:int = 2,
			xOffset:Number = 0, yOffset:Number = 0):int;
	function removeCursor(cursorID:int):void;
	function removeAllCursors():void;
	function setBusyCursor():void;
	function removeBusyCursor():void; 

	function registerToUseBusyCursor(source:Object):void;
	function unRegisterToUseBusyCursor(source:Object):void;
}

}

