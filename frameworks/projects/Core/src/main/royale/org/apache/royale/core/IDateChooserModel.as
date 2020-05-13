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
	 * The IDateChooserModel interface.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IDateChooserModel extends IEventDispatcher, IBeadModel
	{
		/**
		 *  An array of strings used to name the days of the week with Sunday being the
		 *  first element of the array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get dayNames():Array;
		function set dayNames(value:Array):void;
		
		/**
		 *  An array of strings used to name the months of the year with January being
		 *  the first element of the array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get monthNames():Array;
		function set monthNames(value:Array):void;
		
		/**
		 *  The year currently displayed by the DateChooser.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get displayedYear():Number;
		function set displayedYear(value:Number):void;
	
		/**
		 *  The month currently displayed by the DateChooser.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get displayedMonth():Number;
		function set displayedMonth(value:Number):void;
		
		/**
		 *  The index of the first day of the week, Sunday = 0.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get firstDayOfWeek():Number;
		function set firstDayOfWeek(value:Number):void;
		
		/**
		 *  The currently selected date or null if no date has been selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get selectedDate():Date;
		function set selectedDate(value:Date):void;
        
	}
}
