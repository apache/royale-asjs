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
package org.apache.royale.jewel.itemRenderers
{
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IOwnerViewItemRenderer;
	import org.apache.royale.core.SimpleCSSStylesWithFlex;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.jewel.Button;
COMPILE::JS{
	import org.apache.royale.html.util.addElementToWrapper;
	import org.apache.royale.core.WrappedHTMLElement;
}

	/**
	 *  The DatagridHeaderRenderer class extends ButtonBarItemRenderer and turns it into an itemRenderer
	 *  suitable for use in most DataContainer/List/DataGrid applications.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
	 */
	public class DatagridHeaderRenderer extends ButtonBarItemRenderer
	{
		public function DatagridHeaderRenderer()
		{
			super()
			COMPILE::JS{
				classSelectorList.setOverride(_button);
			}
		}

		COMPILE::JS
		override protected function setClassName(value:String):void
		{
			_button.className = value;
		}

		COMPILE::JS
		private var _button:WrappedHTMLElement



		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			_button = super.createElement();

			element = document.createElement('div') as WrappedHTMLElement;
			element.appendChild(_button)
			return element;
		}
	}
}
