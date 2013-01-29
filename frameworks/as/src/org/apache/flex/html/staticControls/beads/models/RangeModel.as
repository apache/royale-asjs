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
package org.apache.flex.html.staticControls.beads.models
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IRangeModel;
		
	public class RangeModel extends EventDispatcher implements IBead, IRangeModel
	{
		public function RangeModel()
		{
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}

		private var _maximum:Number;
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if (value != _maximum)
			{
				_maximum = value;
				dispatchEvent(new Event("maximumChange"));
			}
		}
		
		private var _minimum:Number;
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if (value != _minimum)
			{
				_minimum = value;
				dispatchEvent(new Event("minimumChange"));
			}
		}

		private var _snapInterval:Number;
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		
		public function set snapInterval(value:Number):void
		{
			if (value != _snapInterval)
			{
				_snapInterval = value;
				dispatchEvent(new Event("snapIntervalChange"));
			}
		}
		
		private var _stepSize:Number;
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		public function set stepSize(value:Number):void
		{
			if (value != _stepSize)
			{
				_stepSize = value;
				dispatchEvent(new Event("stepSizeChange"));
			}
		}
		
		private var _value:Number;
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(newValue:Number):void
		{
			if (newValue != _value)
			{
				_value = newValue;
				dispatchEvent(new Event("valueChange"));
			}
		}
		
	}
}