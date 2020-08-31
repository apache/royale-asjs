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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.beads.models.TabBarPresentationModel;
	import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;

	/**
	 *  The TabBar class is a List used for navigate other organized content
	 *  in a Royale Application. In HTML is represented by a <nav> tag in HTML and
	 *  It parents a list of links.
	 *  By default it uses TabBarButtonItemRenderer class to define each item.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TabBar extends List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TabBar()
		{
			super();
            typeNames = "jewel tabbar";
			//TabBar is always selected, so selectedIndex can't be -1, at least it will default to 0
			ISelectionModel(model).selectedIndex = 0;
			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}

		private function internalMouseHandler(event:MouseEvent):void
		{
			COMPILE::JS
			{
				// avoid a link tries to open a new page 
				event.preventDefault();
			}
		}

		private var _sameWidths:Boolean = false;
		/**
		 *  Assigns variable gap to grid from 1 to 20
		 *  Activate "gap-Xdp" effect selector to set a numeric gap 
		 *  between grid cells
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
        public function get sameWidths():Boolean
        {
            return _sameWidths;
        }
		/**
         *  @private
         */
		public function set sameWidths(value:Boolean):void
		{
			if (value != _sameWidths)
			{
				_sameWidths = value;
				toggleClass("sameWidths", _sameWidths);
			}
		}


		/**
		 *  The presentation model for the tabbar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 */
		override public function get presentationModel():IBead
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
				presModel = new TabBarPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}

		/**
		 * Load the layout bead if it hasn't already been loaded.
         * 
         * @private
         */
        // override protected function addLayoutBead():void {
		// 	// we need to proxy the layout bead to the content in TabBarView
		// }
	}
}
