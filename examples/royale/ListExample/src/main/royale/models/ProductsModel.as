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
	import org.apache.royale.collections.ArrayList;

	public class ProductsModel
	{
		/**
		 * Used for the GenericList example.
		 */
		private var _productNames:ArrayList = new ArrayList(["Widgets", "Thingys", "Sprockets", "Doohickies", "Weejets"]);
		public function get productNames():ArrayList
		{
			return _productNames;
		}
		
		public var simple:Array = ["Blueberries", "Bananas", "Lemons", "Oranges", "Watermelons"];
		
		private var _states:ArrayList = new ArrayList([
				"Massachusetts", "Vermont", "New Hampshire", "Maine", "Rhode Island", "Conneticutt"]);
		
		public function get states():ArrayList
		{
			return _states;
		}

		public function set states(a:ArrayList):void
		{
			_states = a;
		}
        
        public var _bigArray:Array;
        
        public function get bigArray():Array
        {
            if (!_bigArray)
            {
                _bigArray = [];
                for (var i:int = 0; i < 1000; i++)
                {
                    _bigArray.push("row " + i.toString());
                }
            }
            return _bigArray;
        }
	}
}
