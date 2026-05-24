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
package org.apache.royale.style.renderers
{

	import org.apache.royale.style.DataItemRenderer;
	/**
	 *  The ListItemRendererBase class is the base class for itemRenderers used in List controls.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	public class ListItemRendererBase extends DataItemRenderer implements IListItemRenderer
	{
		public function ListItemRendererBase()
		{
			super();
		}

		override protected function getTag():String
		{
			return "li";
		}

		public function get selected():Boolean
		{
			return getAttribute("data-selected") != null;
		}

		public function set selected(value:Boolean):void
		{
			toggleAttribute("data-selected", value);
		}

		public function get hovered():Boolean
		{
			return getAttribute("data-hovered") != null;
		}

		public function set hovered(value:Boolean):void
		{
			toggleAttribute("data-hovered", value);
		}

		public function get down():Boolean
		{
			return getAttribute("data-down") != null;
		}

		public function set down(value:Boolean):void
		{
			toggleAttribute("data-down", value);
		}

		public function get disabled():Boolean
		{
			return getAttribute("data-disabled") != null;
		}

		public function set disabled(value:Boolean):void
		{
			toggleAttribute("data-disabled", value);
		}
	}
}