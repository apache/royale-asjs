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
package org.apache.royale.text.engine
{
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.text.engine.ITextLine;

	public interface ITextLine extends IParentIUIBase
	{
		function get ascent():Number;
		function get atomCount():int;
		function get blendMode():String;
		function get cacheAsBitmap():Boolean;
		function get descent():Number;
		function get doubleClickEnabled():Boolean;
		function get hasGraphicElement():Boolean;
		function get hasTabs():Boolean;
		function get nextLine():ITextLine;
		function get previousLine():ITextLine;
		function get rawTextLength():int;
		function get specifiedWidth():Number;
		function get textBlock():ITextBlock;
		function get textBlockBeginIndex():int;
		function get textHeight():Number;
		function get textWidth():Number;
		function get totalAscent():Number;
		function get totalDescent():Number;
		function get totalHeight():Number;
		function get unjustifiedTextWidth():Number;
		function get userData():*;
		function get validity():String;
		function get numberLine():ITextLine;

//setters
		function set userData(value:*):void;
		function set doubleClickEnabled(value:Boolean):void;
		function set validity(value:String):void;
		function set numberLine(value:ITextLine):void;

		function dump():String;
		function getAtomBidiLevel(atomIndex:int):int;
		function getAtomBounds(atomIndex:int):Rectangle;
		function getAtomCenter(atomIndex:int):Number;
		function getAtomGraphic(atomIndex:int):IUIBase;
		function getAtomIndexAtCharIndex(charIndex:int):int;
		function getAtomIndexAtPoint(stageX:Number, stageY:Number):int;
		function getAtomTextBlockBeginIndex(atomIndex:int):int;
		function getAtomTextBlockEndIndex(atomIndex:int):int;
		function getAtomTextRotation(atomIndex:int):String;
		function getAtomWordBoundaryOnLeft(atomIndex:int):Boolean;
		function getBaselinePosition(baseline:String):Number;
		function getAdornmentOffsetBase():Number;

		[SWFOverride(returns="flash.geom.Rectangle",params="flash.display.DisplayObject",altparams="Object")]
		function getBounds(ref:Object):Rectangle;
		

	}
}
