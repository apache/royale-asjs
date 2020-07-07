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
package org.apache.royale.html.beads.layouts
{

    /**
     *  The ScrollingFlexibleChild class allows flexible children to be scrollable.
	 *  
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 9.4
     */

	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.layouts.IOneFlexibleChildLayout;

	public class ScrollingFlexibleChild implements IBead, IDocument
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 9.4
		 */

		/**
		 *  @private
		 *  The document.
		 */
		private var document:Object;

		public function ScrollingFlexibleChild()
		{
			super();
		}

		public function setDocument(document:Object, id:String = null):void
		{
				this.document = document;
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			COMPILE::JS
			{
				(value as IEventDispatcher).addEventListener("layoutComplete", layoutCompleteHandler);
			}
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IStrand
		 *  @royaleignorecoercion org.apache.royale.html.beads.IOneFlexibleChildLayout
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		protected function layoutCompleteHandler(event:Event):void
		{
			var layout:IOneFlexibleChildLayout = (event.target as IStrand).getBeadByType(IOneFlexibleChildLayout) as IOneFlexibleChildLayout;
			var child:IRenderedObject = document[layout.flexibleChild] as IRenderedObject;
			child.element.style["flex-shrink"] = "1";
		}
		
	}

}
