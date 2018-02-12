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
package org.apache.royale.html.supportClasses
{

	/**
	 * The NestedStringItemRenderer can be used with lists or DataGridColumns for
	 * items that are not at the top level of the data. For example, if the
	 * data is an Object having: {title: "Something", address:{street: "Main", zip: "02118"}}
	 * using NestedStringItemRenderer for the address field can extract any of
	 * its consitutents: labelField="address.zip". 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 */
	public class NestedStringItemRenderer extends StringItemRenderer
	{
		/**
		 * Constructor
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function NestedStringItemRenderer()
		{
			super();
		}
		
		/**
		 * Takes a labelField (or dataField) path (eg, "foo.bar.goo") and 
		 * returns the value associated with it from the data property by
		 * doing data[foo][bar][goo]. Returns null if the value cannot
		 * be determined.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function getValueFromField(useField:String):Object
		{
			if (data == null) return null;
			
			var currentValue:Object = data;
			
			var fn:Function = function(object:Object, index:int, array:Array):void {
				if (currentValue && currentValue.hasOwnProperty(object)) {
					currentValue = currentValue[object];
				} else {
					currentValue = null;
				}
			}
			var path:Array = useField.split(".");
			path.forEach(fn, this);
			return currentValue;
		}
		
		private var _data:Object;
		
		/**
		 * @private
		 */
		override public function set data(value:Object):void
		{
			// cannot call super.data = value because that function
			// assumes the labelField is not a path
			_data = value;
			
			var text:String;
			if (value is String) text = value as String;
			else if (labelField) text = String(getValueFromField(labelField));
			else if (dataField) text = String(getValueFromField(dataField));
			else text = String(value);
			
			this.text = text;
		}
		
		override public function get data():Object
		{
			return _data;
		}
		
		
	}
}