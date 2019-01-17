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
package org.apache.royale.html.accessories
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.Strand;
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.core.IFormatter;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 * The DateFormatter class wraps an IFormatter and adds an hour.
	 *  
	 *  @royaleignoreimport org.apache.royale.core.IStrandWithModel
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class DateAndTimeFormatter extends Strand implements IFormatter
	{

		private var _originalFormatter:IFormatter;
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModel
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			if (_originalFormatter)
			{
				addBead(_originalFormatter);
			} else
			{
				_originalFormatter = getBeadByType(IFormatter) as IFormatter;
			}
		}
		

		override public function addBead(bead:IBead):void
		{
			_originalFormatter = bead as IFormatter;
		}
		public function format(value:Object):String
		{
			return getFormattedResult(value as Date);
		}

		protected function getFormattedResult(date:Date):String
		{
			var formattedHour:String = getFormattedHour(date);
			return _originalFormatter.format(date) + " " + formattedHour;
		}
		
		private function getNumberAsPaddedString(value:Number):String
		{
			return (value < 10 ? "0" : "") + value;
		}

		protected function getFormattedHour(date:Date):String
		{
			var hours:String = getNumberAsPaddedString(date.getHours());
			var minutes:String = getNumberAsPaddedString(date.getMinutes());
			var seconds:String = getNumberAsPaddedString(date.getSeconds());
			return hours + ":" + minutes + ":" + seconds;
		}
	}
}
