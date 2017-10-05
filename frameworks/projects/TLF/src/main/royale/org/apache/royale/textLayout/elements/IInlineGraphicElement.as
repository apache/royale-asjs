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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IParentIUIBase;
	public interface IInlineGraphicElement extends IFlowLeafElement
	{
		function get effectiveFloat():*;
		function setEffectiveFloat(floatValue:String):void;
		function get computedFloat():*;
		function elementHeightWithMarginsAndPadding():Number;
		function elementWidthWithMarginsAndPadding():Number;
		function get elementWidth():Number;
		function get elementHeight():Number;
		function get placeholderGraphic():IParentIUIBase;
		function get graphic():IUIBase;
		function getTypographicAscent(textLine:ITextLine):Number;
		function get height():*;
		function get width():*;
		function get status():String;
		function set height(height:*):void;
		function set width(width:*):void;
		function set float(value:*):void;
		function set source(source:Object):void;
	}
}
