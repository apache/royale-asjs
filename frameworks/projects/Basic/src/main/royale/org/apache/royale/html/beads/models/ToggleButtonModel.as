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
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.DispatcherBead;
	
	/**
	 *  The ToggleButtonModel class bead holds values for org.apache.royale.html.Buttons 
	 *  that have a state.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ToggleButtonModel extends DispatcherBead implements IToggleButtonModel, ITextModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ToggleButtonModel()
		{
			super();
		}

		private var _text:String;
		
		/**
		 *  The text string for the org.apache.royale.html.Button's label.
		 * 
		 *  @copy org.apache.royale.core.IToggleButtonModel#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if (value != _text)
			{
				_text = value;
				dispatchEvent(new Event("textChange"));
			}
		}
		
		private var _html:String;
		
		/**
		 *  The HTML string for the Button's label.
		 * 
		 *  @copy org.apache.royale.core.IToggleButtonModel#html
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get html():String
		{
			return _html;
		}
		
		public function set html(value:String):void
		{
			if( value != html )
			{
				_html = value;
				dispatchEvent(new Event("htmlChange"));
			}
		}
		
		private var _selected:Boolean;
		
		/**
		 *  Whether or not the org.apache.royale.html.Button is selected.
		 * 
		 *  @copy org.apache.royale.core.IToggleButtonModel#selected
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if( value != _selected )
			{
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}
	}
}
