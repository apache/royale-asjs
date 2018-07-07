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
	import org.apache.royale.collections.ArrayList;

	public class ListsModel 
	{
		/**
		 * Used in the List example.
		 */
		private var _watchmen:Array = [
			"The Comedian", 
			"Doctor Manhattan", 
			"Nite Owl",
			"Ozymandias",
            "Rorschach",
            "Silk Spectre"
		];
		
		public function get watchmen():Array
		{
			return _watchmen;
		}

		
		/**
		 * Used in the List example.
		 */
		private var _iconListData:ArrayList = new ArrayList([
            new IconListVO("Alert", "web_asset"),
            new IconListVO("Button", "crop_7_5"),
            new IconListVO("DropDownList", "credit_card"),
            new IconListVO("CheckBox", "check_box"),
            new IconListVO("Label", "label"),
            new IconListVO("List", "list_alt"),
            new IconListVO("RadioButton", "radio_button_checked"),
            new IconListVO("Slider", "storage"),
            new IconListVO("Text", "subject"),
            new IconListVO("TextInput", "text_fields")            
        ]);

		public function get iconListData():ArrayList
		{
			return _iconListData;
		}
	}
}
