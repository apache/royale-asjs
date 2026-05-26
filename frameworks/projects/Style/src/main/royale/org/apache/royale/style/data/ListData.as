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
package org.apache.royale.style.data
{
	/**
	 * The ListData class is a simple implementation of the IListData interface. It is used to hold data for a list item.
	 * It is used by the List component to hold data for each item in the list.
	 * 
	 * @languageversion 3.0
	 * @productversion Royale 1.0.0
	 */
	public class ListData extends DataItem implements IListData
	{
		public function ListData(text:String="")
    {
      this.text = text;
    }
    private var _text:String;

    public function get text():String
    {
    	return _text;
    }

    public function set text(value:String):void
    {
    	_text = value;
    }
    public function get label():String{
      return _text;
    }
    private var _icon:String;

    public function get icon():String
    {
    	return _icon;
    }

    public function set icon(value:String):void
    {
    	_icon = value;
    }

    private var _imageIcon:String;
    /**
     * src of an icon to be rendered an an img
     */
    public function get imageIcon():String
    {
    	return _imageIcon;
    }

    public function set imageIcon(value:String):void
    {
    	_imageIcon = value;
    }
	}
}