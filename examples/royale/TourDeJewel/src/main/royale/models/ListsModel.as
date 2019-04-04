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
package models
{
	import vos.IconListVO;
	import vos.DetailIconListVO;
	import org.apache.royale.collections.ArrayList;

	[Bindable]
	public class ListsModel
	{
		/**
		 * Used in the List example.
		 */
		private var _watchmen:ArrayList = new ArrayList([
			"The Comedian",
			"Doctor Manhattan",
			"Nite Owl",
			"Ozymandias",
            "Rorschach",
            "Silk Spectre"
		]);
		
		public function get watchmen():ArrayList
		{
			return _watchmen;
		}

		private var _avengers:ArrayList = new ArrayList([
			new IconListVO("Iron Man", MaterialIconType.WEB_ASSET),
			new IconListVO("Hulk", MaterialIconType.WEB_ASSET),
			new IconListVO("Thor", MaterialIconType.WEB_ASSET),
			new IconListVO("Captain America", MaterialIconType.WEB_ASSET),
            new IconListVO("Black Widow", MaterialIconType.WEB_ASSET),
            new IconListVO("Hawkeye", MaterialIconType.WEB_ASSET),
            new IconListVO("Vision", MaterialIconType.WEB_ASSET),
            new IconListVO("Scarlet Witch", MaterialIconType.WEB_ASSET),
            new IconListVO("Spiderman", MaterialIconType.WEB_ASSET),
            new IconListVO("All Avengers and Guardians of the Galaxy", MaterialIconType.WEB_ASSET)
		]);
		
		public function get avengers():ArrayList
		{
			return _avengers;
		}
		

		
		/**
		 * Used in the List example.
		 */
		private var _iconListData:ArrayList = new ArrayList([
            new IconListVO("All Jewel UI Set Controls", MaterialIconType.SETTINGS),
            new IconListVO("Alert", MaterialIconType.WEB_ASSET),
            new IconListVO("Button", MaterialIconType.CROP_7_5),
            new IconListVO("DropDownList", MaterialIconType.CREDIT_CARD),
            new IconListVO("CheckBox", MaterialIconType.CHECK_BOX),
            new IconListVO("Label", MaterialIconType.LABEL),
            new IconListVO("List", MaterialIconType.LIST_ALT),
            new IconListVO("RadioButton", MaterialIconType.RADIO_BUTTON_CHECKED),
            new IconListVO("Slider", MaterialIconType.STORAGE),
            new IconListVO("Text", MaterialIconType.SUBJECT),
            new IconListVO("TextInput", MaterialIconType.TEXT_FIELDS)
        ]);

		public function get iconListData():ArrayList
		{
			return _iconListData;
		}
		
		
		
		/**
		 * Used in the AdvancedLists example.
		 */
		private var _iconLDetailistDataSource:Array = [
			new DetailIconListVO("All Jewel UI Set Controls", "Jewel", MaterialIconType.SETTINGS),
			new DetailIconListVO("Alert", "Jewel", MaterialIconType.WEB_ASSET),
			new DetailIconListVO("Button", "Jewel", MaterialIconType.CROP_7_5),
			new DetailIconListVO("DropDownList", "Jewel", MaterialIconType.CREDIT_CARD),
			new DetailIconListVO("CheckBox", "Jewel", MaterialIconType.CHECK_BOX),
			new DetailIconListVO("Label","Jewel",  MaterialIconType.LABEL),
			new DetailIconListVO("List", "Jewel", MaterialIconType.LIST_ALT),
			new DetailIconListVO("RadioButton", "Jewel", MaterialIconType.RADIO_BUTTON_CHECKED),
			new DetailIconListVO("Slider", "Jewel", MaterialIconType.STORAGE),
			new DetailIconListVO("Text", "Jewel", MaterialIconType.SUBJECT),
			new DetailIconListVO("TextInput", "Jewel", MaterialIconType.TEXT_FIELDS),
			new DetailIconListVO("Button", "Basic", MaterialIconType.CROP_7_5),
			new DetailIconListVO("DropDownList", "Basic", MaterialIconType.CREDIT_CARD),
			new DetailIconListVO("CheckBox", "Basic", MaterialIconType.CHECK_BOX),
			new DetailIconListVO("Label","Basic",  MaterialIconType.LABEL),
			new DetailIconListVO("List", "Basic", MaterialIconType.LIST_ALT),
			new DetailIconListVO("RadioButton", "Basic", MaterialIconType.RADIO_BUTTON_CHECKED),
			new DetailIconListVO("Slider", "Basic", MaterialIconType.STORAGE),
			new DetailIconListVO("Text", "Basic", MaterialIconType.SUBJECT),
			new DetailIconListVO("TextInput", "Basic", MaterialIconType.TEXT_FIELDS)
		];
		
		private var _iconLDetailistData:ArrayList;
		
		public function get iconDetailListData():ArrayList
		{
			return _iconLDetailistData || (_iconLDetailistData = new ArrayList(_iconLDetailistDataSource.slice()));
		}
		
		public function get iconDetailListDataSource():Array
		{
			return _iconLDetailistDataSource.slice();
		}
	}
}
