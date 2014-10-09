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
package org.apache.flex.core
{
    import flash.display.DisplayObjectContainer;
    
    /**
     *  The IChild interface is the basic interface for a 
     *  component that is parented by another component.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
         */
        function get percentHeight():Number;
        function set percentHeight(value:Number):void;
        
        /**
         * Sets the height of the component without
         * setting explicitHeight.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        function setHeight(value:Number):void;
        
        /**
         * Sets the width of the component without
         * setting explicitWidth.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        function setWidth(value:Number):void;
        
        /**
         * Sets the width and height of the component 
         * without setting explicitWidth or explicitHeight.
         * It also sends one change event.  If both
         * values change it only sends heightCHange event.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        function setWidthAndHeight(newWidth:Number, newHeight:Number):void;
        
   	}
}