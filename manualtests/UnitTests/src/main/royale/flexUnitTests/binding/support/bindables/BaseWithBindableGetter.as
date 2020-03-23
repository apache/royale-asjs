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
package flexUnitTests.binding.support.bindables
{
	import flexUnitTests.binding.utils.BindableTestUtil;
	
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	public class BaseWithBindableGetter
	{
		private var _accessorOfBaseWithBindableGetter:String = "accessorOfBaseWithBindableGetter_value";
		
		[Bindable]
		public function get accessorOfBaseWithBindableGetter():String
		{
			BindableTestUtil.instance.addHistoryItem('accessing value from original getter', _accessorOfBaseWithBindableGetter);
			return _accessorOfBaseWithBindableGetter;
		}
		
		public function set accessorOfBaseWithBindableGetter(value:String):void
		{
			BindableTestUtil.instance.addHistoryItem('assigning value in original setter', value);
			_accessorOfBaseWithBindableGetter = value;
		}

		private var _accessorOfBaseWithBindableGetter2:String = '_accessorOfBaseWithBindableGetter2_value';

		//this has at least one [Bindable] so should code-gen Bindable code
		[Bindable]
		[Bindable(event='testEvent')]
		public function get accessorOfBaseWithBindableGetter2():String
		{
			BindableTestUtil.instance.addHistoryItem('accessing value from original getter', _accessorOfBaseWithBindableGetter2);
			return _accessorOfBaseWithBindableGetter2;
		}

		public function set accessorOfBaseWithBindableGetter2(value:String):void
		{
			BindableTestUtil.instance.addHistoryItem('assigning value in original setter', value);
			if (value != _accessorOfBaseWithBindableGetter2) {
				_accessorOfBaseWithBindableGetter2 = value;
				IEventDispatcher(this).dispatchEvent(new Event('testEvent'));
			}

		}

		//this should be ignored, because this class itself is not marked [Bindable]
		[Bindable('somethingChanged')]
		public var something:String;

	}
}
