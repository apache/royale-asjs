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
package org.apache.royale.html.test.models
{
	import org.apache.royale.collections.ArrayListView;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	[ExcludeClass]
	/**
	 * @private
	 */
	public class UITestRunnerModel extends EventDispatcher
	{
		public static const RESULT_TYPE_ALL:String = "All Tests";
		public static const RESULT_TYPE_PASSED:String = "Passed";
		public static const RESULT_TYPE_FAILED:String = "Failed";
		public static const RESULT_TYPE_IGNORED:String = "Ignored";
		
		public function UITestRunnerModel()
		{
			super();
		}

		private var _results:ArrayListView = new ArrayListView();

		[Bindable]
		public function get results():ArrayListView
		{
			return this._results;
		}

		[Bindable("change")]
		public function get selectedResult():UITestVO
		{
			if(this.selectedResultIndex == -1)
			{
				return null;
			}
			return this._results.getItemAt(this.selectedResultIndex) as UITestVO;
		}

		private var _selectedResultIndex:int = -1;

		[Bindable("change")]
		public function get selectedResultIndex():int
		{
			return this._selectedResultIndex;
		}

		public function set selectedResultIndex(value:int):void
		{
			this._selectedResultIndex = value;
			this.dispatchEvent(new Event("change"));
		}

		[Bindable]
		public var resultTypes:Array = [RESULT_TYPE_ALL, RESULT_TYPE_FAILED, RESULT_TYPE_PASSED, RESULT_TYPE_IGNORED];
	}
}