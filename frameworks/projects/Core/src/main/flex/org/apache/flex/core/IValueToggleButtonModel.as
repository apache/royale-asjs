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
    /**
     *  The IValueToggleButtonModel interface describes the minimum set of properties
     *  available each ToggleButton in a group of ToggleButtons of which only one 
     *  can be selected at a time.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IValueToggleButtonModel extends IToggleButtonModel
	{
        /**
         *  A value associated with this instance of the ToggleButton.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get value():Object;
		function set value(newValue:Object):void;
		
        /**
         *  The name of the group that this ToggleButton belongs to.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get groupName():String;
		function set groupName(value:String):void;
		
        /**
         *  A value associated with the instance of the ToggleButton
         *  that is currently selected.  It may not be this ToggleButton.
         *  This means that you can get the selected value from any
         *  instance of a ToggleButton in the group.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get selectedValue():Object;
		function set selectedValue(newValue:Object):void;
	}
}
