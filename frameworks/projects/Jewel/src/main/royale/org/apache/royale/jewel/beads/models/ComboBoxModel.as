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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.jewel.beads.models.ArrayListSelectionModel;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.events.Event;

	/**
	 *  The ComboBoxModel class bead extends org.apache.royale.jewel.beads.models.ArrayListSelectionModel
	 *  and adds the text being displayed by the org.apache.royale.jewel.ComboBox's input field.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ComboBoxModel extends ArrayListSelectionModel implements IBead, IComboBoxModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ComboBoxModel()
		{
		}

		private var _text:String;

		/**
		 *  The string to display in the org.apache.royale.html.ComboBox input field.
		 *
		 *  @copy org.apache.royale.core.IComboBoxModel#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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
				dispatchChange("textChange");
			}
		}

		private var _html:String;

		/**
		 *  The HTML string to display in the org.apache.royale.html.ComboBox input field.
		 *
		 *  @copy org.apache.royale.core.IComboBoxModel#html
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get html():String
		{
			return _html;
		}

		public function set html(value:String):void
		{
			if (value != _html)
			{
				_html = value;
                dispatchChange("htmlChange");
			}
		}
	}
}
