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
package org.apache.flex.html.staticControls
{
	import org.apache.flex.core.ISpinnerModel;
	import org.apache.flex.core.UIBase;
	
	[Event(name="valueChanged", type="org.apache.flex.events.Event")]
	
	public class Spinner extends UIBase
	{
		public function Spinner()
		{
			super();
			
			className = "Spinner";
		}
		
		public function get value():Number
		{
			return ISpinnerModel(model).value;
		}
		public function set value(newValue:Number):void
		{
			ISpinnerModel(model).value = newValue;
		}
		
		public function get minimum():Number
		{
			return ISpinnerModel(model).minimum;
		}
		public function set minimum(value:Number):void
		{
			ISpinnerModel(model).minimum = value;
		}
		
		public function get maximum():Number
		{
			return ISpinnerModel(model).maximum;
		}
		public function set maximum(value:Number):void
		{
			ISpinnerModel(model).maximum = value;
		}
		
		public function get snapInterval():Number
		{
			return ISpinnerModel(model).snapInterval;
		}
		public function set snapInterval(value:Number):void
		{
			ISpinnerModel(model).snapInterval = value;
		}
		
		public function get stepSize():Number
		{
			return ISpinnerModel(model).stepSize;
		}
		public function set stepSize(value:Number):void
		{
			ISpinnerModel(model).stepSize = value;
		}
		
	}
}