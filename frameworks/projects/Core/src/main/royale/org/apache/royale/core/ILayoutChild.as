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
package org.apache.royale.core
{
    COMPILE::SWF
    {
        import flash.display.DisplayObjectContainer;
    }
    
    /**
     *  The IChild interface is the basic interface for a 
     *  component that is parented by another component.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public interface ILayoutChild extends IChild, IUIBase
	{
        /**
         *  The requested percentage width of
         *  this component in its container.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get percentWidth():Number;
        function set percentWidth(value:Number):void;
        
        /**
         *  The requested percentage height of
         *  this component in its container.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get percentHeight():Number;
        function set percentHeight(value:Number):void;
        
        /**
         *  The width of this component 
         *  if set by the width property
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get explicitWidth():Number;
        function set explicitWidth(value:Number):void;
        
        /**
         *  The height of this component 
         *  if set by the height property
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get explicitHeight():Number;
        function set explicitHeight(value:Number):void;

        /**
         * Sets the height of the component without
         * setting explicitHeight.
         * 
         *  @param value The new height.
         *  @param noEvent True if no change event should be sent.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function setHeight(value:Number, noEvent:Boolean = false):void;
        
        /**
         * Sets the width of the component without
         * setting explicitWidth.
         *  
         *  @param value The new width.
         *  @param noEvent True if no change event should be sent.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function setWidth(value:Number, noEvent:Boolean = false):void;
        
        /**
         * Sets the X value of the component without setting the 'left' style
         * 
         *  @param value The new x value.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function setX(value:Number):void;
        
        /**
         * Sets the Y value of the component without setting the 'top' style
         * 
         *  @param value The new y value.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function setY(value:Number):void;
        
        /**
         * Sets the width and height of the component 
         * without setting explicitWidth or explicitHeight.
         * It also sends one change event.  If both
         * values change it only sends heightCHange event.
         *  
         *  @param newWidth The new width.
         *  @param newHeight The new height.
         *  @param noEvent True if no change event should be sent.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function setWidthAndHeight(newWidth:Number, newHeight:Number, noEvent:Boolean = false):void;
        
        /**
         * True if no percentWidth or explicitWidth has been
         * assigned
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function isWidthSizedToContent():Boolean;
        
        /**
         * True if no percentHeight or explicitHeight has been
         * assigned
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function isHeightSizedToContent():Boolean;

    }
}
