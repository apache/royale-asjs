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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.html.beads.models.ArraySelectionModel;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
			
    /**
     *  The ArraySelectionModel class is a selection model for
     *  a dataProvider that is an array. It assumes that items
     *  can be fetched from the dataProvider
     *  dataProvider[index].  Other selection models
     *  would support other kinds of data providers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ButtonBarModel extends ArraySelectionModel
	{
		public static const PIXEL_WIDTHS:Number = 0;
		public static const PROPORTIONAL_WIDTHS:Number = 1;
		public static const PERCENT_WIDTHS:Number = 2;
        public static const NATURAL_WIDTHS:Number = 3;
		
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ButtonBarModel()
		{
		}
		
		private var _buttonWidths:Array = null;
		
		/**
		 *  The widths of each button. This property may be null (the default) in which
		 *  case the buttons are equally sized. Or this array may contain values, one per
		 *  button, which either indicate each button's width in pixels (set .widthType
		 *  to ButtonBarModel.PIXEL_WIDTHS) or proportional to other buttons (set
		 *  .widthType to ButtonBarModel.PROPORTIONAL_WIDTHS). The array can also contain
		 *  specific percentages (set .widthType to ButtonBarModel.PERCENT_WIDTHS). If 
		 *  this array is set, the number of entries must match the number of buttons. 
		 *  However, any entry may be null to indicate the button's default size is to be used.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get buttonWidths():Array
		{
			return _buttonWidths;
		}
		public function set buttonWidths(value:Array):void
		{
			_buttonWidths = value;
			dispatchEvent(new Event("buttonWidthsChanged"));
		}
		
		private var _widthType:Number = ButtonBarModel.PIXEL_WIDTHS;
		
		/**
		 * Indicates how to interpret the values of the buttonWidths array.
		 * 
		 * PIXEL_WIDTHS: all of the values are exact pixel widths (unless a value is null).
		 * PROPORTIONAL_WIDTHS: all of the values are proportions. Use 1 to indicate normal, 2 to be 2x, etc. Use 0 (or null) to mean fixed default size.
		 */
		public function get widthType():Number
		{
			return _widthType;
		}
		public function set widthType(value:Number):void
		{
			_widthType = value;
			dispatchEvent(new Event("widthTypeChanged"));
		}
	}
}
