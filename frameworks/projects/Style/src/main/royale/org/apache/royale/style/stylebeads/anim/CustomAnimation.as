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
package org.apache.royale.style.stylebeads.anim
{
	import org.apache.royale.style.stylebeads.CompositeStyle;

	public class CustomAnimation extends CompositeStyle
	{
		public function CustomAnimation(name:String = null,keyframes:Array = null,duration:Object = 'default',timingFunction:String = 'default',iterationCount:String = null)
		{
			super();
			_nameStyle = new Keyframes(name,keyframes);
			_timingStyle = new AnimationTimingFunction(timingFunction);
			_durationStyle = new AnimationDuration(duration);
			styles = [
				_nameStyle,
				_timingStyle,
				_durationStyle
			];
			if (iterationCount)
			{
				this.iterationCount = iterationCount;
			}
		}

		private var _nameStyle:Keyframes;
		private var _timingStyle:AnimationTimingFunction;
		private var _durationStyle:AnimationDuration;
		private var _iterationCountStyle:AnimationIterationCount;

		public function get name():String
		{
			return _nameStyle.value;
		}

		public function set name(value:String):void
		{
			_nameStyle.value = value;
		}

		public function get keyframes():Array
		{
			return _nameStyle.keyframes;
		}

		public function set keyframes(value:Array):void
		{
			_nameStyle.keyframes = value;
		}

		public function get timingFunction():String
		{
			return _timingStyle.value;
		}

		public function set timingFunction(value:String):void
		{
			_timingStyle.value = value;
		}

		public function get duration():*
		{
			return _durationStyle.value;
		}

		public function set duration(value:*):void
		{
			_durationStyle.value = value;
		}

		public function get iterationCount():String
		{
			return _iterationCountStyle ? _iterationCountStyle.value : null;
		}

		public function set iterationCount(value:String):void
		{
			if (!_iterationCountStyle)
			{
				_iterationCountStyle = new AnimationIterationCount(value);
				addStyleBead(_iterationCountStyle);
			}
			else
			{
				_iterationCountStyle.value = value;
			}
		}
	}
}
