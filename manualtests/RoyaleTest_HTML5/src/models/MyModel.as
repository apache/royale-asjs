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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	public class MyModel extends EventDispatcher
	{
		public function MyModel()
		{
		}
		
		private var _labelText:String;
		
		public function get labelText():String
		{
			return _labelText;
		}
		
		public function set labelText(value:String):void
		{
			if (value != _labelText)
			{
				_labelText = value;
				dispatchEvent(new Event("labelTextChanged"));
			}
		}
        
        private var _strings:Array = ["AAPL", "ADBE", "GOOG", "MSFT", "YHOO"];
        public function get strings():Array
        {
            return _strings;
        }
		
		private var _cities:Array = ["London", "Miami", "Paris", "Sydney", "Tokyo"];
		public function get cities():Array
		{
			return _cities;
		}

	}
}
