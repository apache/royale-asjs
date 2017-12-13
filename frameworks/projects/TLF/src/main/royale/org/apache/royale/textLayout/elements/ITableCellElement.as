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
package org.apache.royale.textLayout.elements {
	public interface ITableCellElement extends ITableFormattedElement
	{
		function get rowIndex():int;
		function getRow():ITableRowElement;
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get container():CellContainer;
		function get colIndex():int;
		function getPreviousCell():ITableCellElement;
		function getNextCell():ITableCellElement;
		function get textFlow():ITextFlow;
		function set y(y:Number):void;
		function set x(x:Number):void;
		function get columnSpan():uint;
		function damage():void;
		function get rowSpan():uint;
		function compose():Boolean;
		function getComposedHeight():Number;
		function set rowIndex(rowIndex:int):void;
		function set colIndex(colIndex:int):void;
		function updateCompositionShapes():void;
	}
}
