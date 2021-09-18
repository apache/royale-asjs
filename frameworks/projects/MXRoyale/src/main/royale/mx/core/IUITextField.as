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
//    import mx.managers.IToolTipManagerClient;
//    import mx.styles.ISimpleStyleClient;
	import org.apache.royale.geom.Rectangle;


    /**
     *  The IUITextField interface defines the basic set of APIs
     *  for UITextField instances.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public interface IUITextField extends /*IIMESupport,
        IFlexModule,
        IInvalidating, ISimpleStyleClient,
        IToolTipManagerClient,*/ IUIComponent
    {
        
//        include "ITextFieldInterface.as"
//        include "IInteractiveObjectInterface.as"

        function get htmlText():String;
        function set htmlText(value:String):void;

        function get text():String;
        function set text(value:String):void;
        
        function get textWidth():Number;
        //function set textWidth(value:Number):void;
        
        function get textHeight():Number;
        //function set textHeight(value:Number):void;

        function get wordWrap():Boolean;
        function set wordWrap(value:Boolean):void;
        

        /**
         *  @copy mx.core.UITextField#ignorePadding
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        //function get ignorePadding():Boolean;
        //function set ignorePadding(value:Boolean):void;
        
        /**
         *  @copy mx.core.UITextField#inheritingStyles
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        //function get inheritingStyles():Object;
        //function set inheritingStyles(value:Object):void;
        
        /**
         *  @copy mx.core.UITextField#nestLevel
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        //function get nestLevel():int;
        //function set nestLevel(value:int):void;
        
        /**
         *  @copy mx.core.UITextField#nonInheritingStyles
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        //function get nonInheritingStyles():Object;
        //function set nonInheritingStyles(value:Object):void;
        
        /**
         *  @copy mx.core.UITextField#nonZeroTextHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        //function get nonZeroTextHeight():Number;
        
        /**
         *  @copy mx.core.UITextField#getStyle()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function getStyle(styleProp:String):*;
        
        /**
         *  @copy mx.core.UITextField#getUITextFormat()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function getUITextFormat():UITextFormat
        
        /**
         *  @copy mx.core.UITextField#setColor()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function setColor(color:uint):void;
        
        /**
         *  @copy mx.core.UITextField#setFocus()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function setFocus():void;
        
        /**
         *  @copy mx.core.UITextField#truncateToFit()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function truncateToFit(truncationIndicator:String = null):Boolean;
        
        function setTextFormat(format:UITextFormat,
                               beginIndex:int = -1,
                               endIndex:int = -1):void;
							   
		function getCharBoundaries(charIndex:int):Rectangle;
        
    }
    
}

