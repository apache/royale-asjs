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
package org.apache.royale.jewel.beads.controls.combobox
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.ComboBox;
	import org.apache.royale.jewel.supportClasses.combobox.ComboBoxPopUp;
	import org.apache.royale.jewel.beads.views.ComboBoxView;
	import org.apache.royale.jewel.beads.views.ComboBoxPopUpView;
	
	/**
	 *  The ComboBoxListWidth class is a specialty bead that can be used with
	 *  a Jewel ComboBox control. The bead change the combobox list width
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.11
	 */
	public class ComboBoxListWidth implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		public function ComboBoxListWidth()
		{
		}
		
		private var _strand:ComboBox;

		private var _width:Number = 0;
		/*
		 * The list with
		 */
		public function get width():Number {
			return _width;
		}
		public function set width(value:Number):void {
			_width = value;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value as ComboBox;
			_strand.addEventListener("popUpOpened", popUpOpenedHandler);
		}
		
		/**
		 * @private
		 */
		private function popUpOpenedHandler(event:Event):void
		{
			if (width > 0)
	            (((_strand.view as ComboBoxView).popup as ComboBoxPopUp).view as ComboBoxPopUpView).list.width = width;
		}
	}
}