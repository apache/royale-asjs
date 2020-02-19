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
package org.apache.royale.jewel.beads.controls.tabbar
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.TabBar;
	import org.apache.royale.jewel.TabBarContent;
	
	[DefaultProperty("content")]

	/**
	 *  The Disabled bead class is a specialty bead that can be used to disable a Jewel control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class AssignTabContent implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function AssignTabContent()
		{
		}

		protected var tabbar:TabBar;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			tabbar = value as TabBar;
			tabbar.addEventListener(Event.CHANGE, changeHandler);
			tabbar.addEventListener("selectionChanged", selectionChangedChangeHandler);
			updateHost();
		}

		protected function updateHost():void
		{
			if(tabbar)
			{
				tabbar.parent.addElement(content);
				if(tabbar.dataProvider)
					content.selectedContent = tabbar.selectedItem[selectedContentProperty];
			}
		}
		
		protected function selectionChangedChangeHandler(event:Event):void
		{
			if(content)
			{
				content.selectedContent = tabbar.selectedItem[selectedContentProperty];
			}
		}

		protected function changeHandler(event:Event):void
		{
			var item:Object = event.target.selectedItem;
			content.selectedContent = item[selectedContentProperty];
		}

		private var _content:TabBarContent;
        /**
		 *  The TabBarContent related to the TabBar
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get content():TabBarContent
        {
            return _content;
        }
        public function set content(value:TabBarContent):void
        {
            _content = value;
			updateHost();
        }
		
		private var _selectedContentProperty:String;
        /**
		 *  the property in the object in the TabBar dataProvider that will be used to
		 *  select the content
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get selectedContentProperty():String
        {
            return _selectedContentProperty;
        }
        public function set selectedContentProperty(value:String):void
        {
            _selectedContentProperty = value;
        }
	}
}
