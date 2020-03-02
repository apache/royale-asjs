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

	[Bindable]
	public class BaseWithAccesorVariantsBindableClass
	{
		private var _accessorOfBaseWithAccesorVariantsBindableClass:String = "BaseWithAccessorVariantsBindableClass_value";
		private var _alternate:String = 'alternate_value';

		public function get accessorOfBaseWithAccesorVariantsBindableClass():String
		{
			BindableTestUtil.instance.addHistoryItem('accessing value from original getter', _accessorOfBaseWithAccesorVariantsBindableClass);
			return _accessorOfBaseWithAccesorVariantsBindableClass;
		}
		
		public function set accessorOfBaseWithAccesorVariantsBindableClass(value:String):void
		{
			BindableTestUtil.instance.addHistoryItem('assigning value in original setter', value);
			_accessorOfBaseWithAccesorVariantsBindableClass = value;
		}
		
		private var _setterOnly:String;
		public function set setterOnly(value:String):void{
			BindableTestUtil.instance.addHistoryItem('setting non bindable setterOnly', value);
			_setterOnly = value;
		}


		public function get getterOnly():String{
			BindableTestUtil.instance.addHistoryItem('getting non bindable getterOnly', 'getterOnly');
			return 'getterOnly';
		}
		
		[Bindable('alternateChanged')]
		public function get alternate():String{
			BindableTestUtil.instance.addHistoryItem('getting alternate value with explicit Bindable event', _alternate);
			return _alternate
		}

		public function set alternate(value:String):void{
			BindableTestUtil.instance.addHistoryItem('setting alternate value with explicit Bindable event', value);
			var dispatch:Boolean = value != _alternate;
			_alternate = value;
			if (dispatch) {
				(this as IEventDispatcher).dispatchEvent(new Event('alternateChanged'));
			}
		}


		private var _alternate2:String = 'alternate2_value';
		[Bindable]
		public function get alternate2():String{
			BindableTestUtil.instance.addHistoryItem('getting alternate2 value with both types of Bindable event', _alternate2);
			return _alternate2
		}

		[Bindable('alternate2Changed')]
		public function set alternate2(value:String):void{
			BindableTestUtil.instance.addHistoryItem('setting alternate2 value with both types of Bindable event', value);
			var dispatch:Boolean = value != _alternate2;
			_alternate2 = value;
			if (dispatch) {
				(this as IEventDispatcher).dispatchEvent(new Event('alternate2Changed'));
			}
		}

		//this should get normal [Bindable] treatment from the class [Bindable] meta (because it is a variable):
		[Bindable('somethingChanged')]
		public var something:String;
		
	}
}
