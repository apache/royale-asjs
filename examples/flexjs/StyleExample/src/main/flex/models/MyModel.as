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
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	public class MyModel extends EventDispatcher
	{
		public function MyModel()
		{
		}

        private var _strings:Array = ["AAPL", "ADBE", "FX", "GOOG", "MSFT", "NYSE", "YHOO"];
        [Bindable("__NoChangeEvent__")]
        public function get strings():Array
        {
            return _strings;
        }

        private var _gridData:ArrayList = new ArrayList([
			{month:"January", days:31}, {month:"February", days:28},
			{month:"March", days:31}, {month:"April", days:30},
			{month:"May", days:31}, {month:"June", days:30},
			{month:"July", days:31}, {month:"August", days:31},
			{month:"September", days:30}, {month:"October", days:31},
			{month:"November", days:30}, {month:"December", days:31}]);
		[Bindable("__NoChangeEvent__")]
		public function get gridData():IArrayList
		{
			return _gridData;
		}

	}
}
