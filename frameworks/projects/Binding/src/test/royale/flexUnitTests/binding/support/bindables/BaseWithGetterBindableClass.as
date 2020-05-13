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

[Bindable]
	public class BaseWithGetterBindableClass
	{
		private var _accessorOfBaseWithGetterBindableClass:String = "accessorOfBaseWithGetterBindableClass_value";
		

		public function get accessorOfBaseWithGetterBindableClass():String
		{
			BindableTestUtil.instance.addHistoryItem('accessing value from original getter', _accessorOfBaseWithGetterBindableClass);
			return _accessorOfBaseWithGetterBindableClass;
		}
		
		public function set accessorOfBaseWithGetterBindableClass(value:String):void
		{
			BindableTestUtil.instance.addHistoryItem('assigning value in original setter', value);
			_accessorOfBaseWithGetterBindableClass = value;
		}

	}
}
