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
	import org.apache.royale.utils.observeElementSize;

	/**
	 *  The TabBarButtonInidicatorRestrictedToContentItemRenderer
     *  is a TabBarButtonItemRenderer that restrict indicator to content
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class TabBarButtonInidicatorRestrictedToContentItemRenderer extends TabBarButtonItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TabBarButtonInidicatorRestrictedToContentItemRenderer()
		{
			super();

			COMPILE::JS
			{
			// since span content and _internal must by synced on size, 
			// but are in different DOM branches
            observeElementSize(content, contentSizeChanged);
            }
		}

		COMPILE::JS
		private var _internal_:HTMLDivElement;

		/**
		 * We create an internal element with the text and make it invisible.
		 * So we position absolutely to the bottom and add the indicator
		 * to this internal element.
		 * In this way we can manage paddings and other things
		 * in extended renderers.
		 */
		COMPILE::JS
		override protected function addIndicator():void
		{
			// this is to position the indicator when restricted
			_internal_ = document.createElement('div') as HTMLDivElement;
			_internal_.className = "_internal_";
			positioner.appendChild(_internal_);
			_internal_.appendChild(indicator);
		}

		COMPILE::JS
        private function contentSizeChanged():void
		{
			updateInternalSize();
        }

		/**
		 * updated internal size according to real content size
		 */
		COMPILE::JS
		protected function updateInternalSize():void
		{
			_internal_.style.width = content.offsetWidth + "px";
			_internal_.style.height = content.offsetHeight + "px";
		}
	}
}