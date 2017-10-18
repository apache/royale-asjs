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
	import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  The IAlertModel interface describes the minimum set of properties
     *  available to an Alert control.  More sophisticated Alert controls
     *  could have models that extend IAlertModel.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IAlertModel extends IEventDispatcher, IBeadModel
	{
        /**
         *  The title of the Alert.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get title():String;
		function set title(value:String):void;
		
        /**
         *  The title of the Alert as HTML.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get htmlTitle():String;
		function set htmlTitle(value:String):void;
		
        /**
         *  The message to be displayed by the Alert.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get message():String;
		function set message(value:String):void;
		
        /**
         *  The message to be displayed by the Alert as HTML.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get htmlMessage():String;
		function set htmlMessage(value:String):void;
		
        /**
         *  A bitmask of Alert constants that describe
         *  which buttons to show in the Alert..
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get flags():uint;
		function set flags(value:uint):void;
		
        /**
         *  The label for the OK button in an Alert.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get okLabel():String;
		function set okLabel(value:String):void;
		
        /**
         *  The label for the Cancel button in an Alert.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get cancelLabel():String;
		function set cancelLabel(value:String):void;
		
        /**
         *  The label for the Yes button in an Alert.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get yesLabel():String;
		function set yesLabel(value:String):void;
		
        /**
         *  The label for the No button in an Alert.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get noLabel():String;
		function set noLabel(value:String):void;
	}
}
