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

/**
 *  The ITextField interface defines the basic set of APIs
 *  for flash.display.TextField
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

    /**
     *  @copy flash.text.TextField#alwaysShowSelection
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get alwaysShowSelection():Boolean;
    function set alwaysShowSelection(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#antiAliasType
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get antiAliasType():String;
    function set antiAliasType(antiAliasType:String):void;

    /**
     *  @copy flash.text.TextField#autoSize
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get autoSize():String;
    function set autoSize(value:String):void;

    /**
     *  @copy flash.text.TextField#background
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get background():Boolean;
    function set background(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#backgroundColor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get backgroundColor():uint;
    function set backgroundColor(value:uint):void;

    /**
     *  @copy flash.text.TextField#border
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get border():Boolean;
    function set border(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#borderColor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get borderColor():uint;
    function set borderColor(value:uint):void;

    /**
     *  @copy flash.text.TextField#bottomScrollV
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get bottomScrollV():int;

    /**
     *  @copy flash.text.TextField#caretIndex
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get caretIndex():int;

    /**
     *  @copy flash.text.TextField#condenseWhite
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get condenseWhite():Boolean;
    function set condenseWhite(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#defaultTextFormat
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get defaultTextFormat():TextFormat;
    function set defaultTextFormat(format:TextFormat):void;

    /**
     *  @copy flash.text.TextField#embedFonts
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get embedFonts():Boolean;
    function set embedFonts(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#gridFitType
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get gridFitType():String;
    function set gridFitType(gridFitType:String):void;

    /**
     *  @copy flash.text.TextField#htmlText
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get htmlText():String;
    function set htmlText(value:String):void;

    /**
     *  @copy flash.text.TextField#length
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get length():int;

    /**
     *  @copy flash.text.TextField#maxChars
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get maxChars():int;
    function set maxChars(value:int):void;

    /**
     *  @copy flash.text.TextField#maxScrollH
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get maxScrollH():int;

    /**
     *  @copy flash.text.TextField#maxScrollV
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get maxScrollV():int;

    /**
     *  @copy flash.text.TextField#mouseWheelEnabled
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get mouseWheelEnabled():Boolean;
    function set mouseWheelEnabled(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#multiline
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get multiline():Boolean;
    function set multiline(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#numLines
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get numLines():int;

    /**
     *  @copy flash.text.TextField#displayAsPassword
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get displayAsPassword():Boolean;
    function set displayAsPassword(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#restrict
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get restrict():String;
    function set restrict(value:String):void;

    /**
     *  @copy flash.text.TextField#scrollH
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get scrollH():int;
    function set scrollH(value:int):void;

    /**
     *  @copy flash.text.TextField#scrollV
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get scrollV():int;
    function set scrollV(value:int):void;

    /**
     *  @copy flash.text.TextField#selectable
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get selectable():Boolean;
    function set selectable(value:Boolean):void;

    /**
     *  @copy flash.text.TextField#selectionBeginIndex
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get selectionBeginIndex():int;

    /**
     *  @copy flash.text.TextField#selectionEndIndex
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get selectionEndIndex():int;

    /**
     *  @copy flash.text.TextField#sharpness
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get sharpness():Number;
    function set sharpness(value:Number):void;

    /**
     *  @copy flash.text.TextField#styleSheet
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get styleSheet():StyleSheet;
    function set styleSheet(value:StyleSheet):void;

    /**
     *  @copy flash.text.TextField#text
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get text():String;
    function set text(value:String):void;

    /**
     *  @copy flash.text.TextField#textColor
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get textColor():uint;
    function set textColor(value:uint):void;

    /**
     *  @copy flash.text.TextField#textHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get textHeight():Number;

    /**
     *  @copy flash.text.TextField#textWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get textWidth():Number;

    /**
     *  @copy flash.text.TextField#thickness
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get thickness():Number;
    function set thickness(value:Number):void;

    /**
     *  @copy flash.text.TextField#type
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get type():String;
    function set type(value:String):void;

    /**
     *  @copy flash.text.TextField#wordWrap
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get wordWrap():Boolean;
    function set wordWrap(value:Boolean):void;  
    

    /**
     *  @copy flash.text.TextField#appendText()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function appendText(newText:String):void;

    /**
     *  @copy flash.text.TextField#getCharBoundaries()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getCharBoundaries(charIndex:int):Rectangle;

    /**
     *  @copy flash.text.TextField#getCharIndexAtPoint()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getCharIndexAtPoint(x:Number, y:Number):int;

    /**
     *  @copy flash.text.TextField#getFirstCharInParagraph()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getFirstCharInParagraph(charIndex:int):int;

    /**
     *  @copy flash.text.TextField#getLineIndexAtPoint()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLineIndexAtPoint(x:Number, y:Number):int;

    /**
     *  @copy flash.text.TextField#getLineIndexOfChar()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLineIndexOfChar(charIndex:int):int;

    /**
     *  @copy flash.text.TextField#getLineLength()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLineLength(lineIndex:int):int;

    /**
     *  @copy flash.text.TextField#getLineMetrics()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLineMetrics(lineIndex:int):TextLineMetrics;

    /**
     *  @copy flash.text.TextField#getLineOffset()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLineOffset(lineIndex:int):int;

    /**
     *  @copy flash.text.TextField#getLineText()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getLineText(lineIndex:int):String;

    /**
     *  @copy flash.text.TextField#getParagraphLength()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getParagraphLength(charIndex:int):int;

    /**
     *  @copy flash.text.TextField#getTextFormat()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getTextFormat(beginIndex:int=-1, endIndex:int=-1):TextFormat;

    /**
     *  @copy flash.text.TextField#replaceSelectedText()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function replaceSelectedText(value:String):void;

    /**
     *  @copy flash.text.TextField#replaceText()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function replaceText(beginIndex:int, endIndex:int, newText:String):void;

    /**
     *  @copy flash.text.TextField#setSelection()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function setSelection(beginIndex:int, endIndex:int):void;

    /**
     *  @copy flash.text.TextField#setTextFormat()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function setTextFormat(format:TextFormat,
                        beginIndex:int=-1,
                        endIndex:int=-1):void;

    /**
     *  @copy flash.text.TextField#getImageReference()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getImageReference(id:String):DisplayObject;
    
    /**
     *  @copy flash.text.TextField#useRichTextClipboard
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get useRichTextClipboard():Boolean;
    function set useRichTextClipboard(value:Boolean):void;

