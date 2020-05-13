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
package org.apache.royale.jewel
{
	import org.apache.royale.core.ITextModel;

	/**
	 * FormHeading is a label, and option required indicator (no validation is implied)
	 * and a content with one or more controls
	 */
	public class FormHeading extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FormHeading()
		{
			super();

			typeNames = "jewel formheading";
		}

		[Bindable(event="change")]
		/**
		 *  @copy org.apache.royale.html.Label#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get label():String
		{
			return ITextModel(model).text;
		}
		/**
		 *  @private
		 */
		public function set label(value:String):void
		{
			ITextModel(model).text = value;
		}

		[Bindable(event="change")]
		/**
		 *  @copy org.apache.royale.html.Label#html
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get html():String
		{
			return ITextModel(model).html;
		}
		/**
		 *  @private
		 */
		public function set html(value:String):void
		{
			ITextModel(model).html = value;
		}
	}
}