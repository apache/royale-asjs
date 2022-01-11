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
package org.apache.royale.jewel.beads.controls.tristatecheckbox
{
	COMPILE::JS
	{
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.TriStateCheckBox;
	}

	/**
	 * The TriStateCheckBoxLabelState bead allows us to display a different Text for each state.
	 */
    COMPILE::JS
	public class TriStateCheckBoxLabelState extends Bead
	{

		public function TriStateCheckBoxLabelState()
		{
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher;
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("change", textLabelChangeHandler);
			listenOnStrand(Event.COMPLETE, textLabelChangeHandler);
		}

		private function get hostBase():TriStateCheckBox
		{
			return _strand as TriStateCheckBox;
		}

		protected function textLabelChangeHandler(event:Event):void
		{
			if(event.type == Event.COMPLETE)
				IEventDispatcher(_strand).removeEventListener(Event.COMPLETE, textLabelChangeHandler);
			updateHost();
		}

		private var _lastText:String;
		protected function updateHost():void
		{
			if (!hostBase)
				return;
			switch(hostBase.state)
			{
				case hostBase.STATE_INDETERMINATE:
					_lastText = _indeterminateText;
					break;
				case hostBase.STATE_UNCHECKED:
					_lastText = _uncheckedText;
					break;
				case hostBase.STATE_CHECKED:
					_lastText = _checkedText;
					break;
				default:
					break;
			}
			if(_lastText != hostBase.text)
				hostBase.text = _lastText;

        }

		private var _indeterminateText:String;
		public function get indeterminateText():String { return _indeterminateText; }
		public function set indeterminateText(value:String):void
		{
			_indeterminateText = value;

			if(!hostBase)
				return;
			if(hostBase.state == hostBase.STATE_INDETERMINATE)
				hostBase.text = value;
		}

		private var _uncheckedText:String;
		public function get uncheckedText():String { return _uncheckedText; }
		public function set uncheckedText(value:String):void
		{
			_uncheckedText = value;

			if(!hostBase)
				return;
			if(hostBase.state == hostBase.STATE_UNCHECKED)
				hostBase.text = value;
		}

		private var _checkedText:String;
		public function get checkedText():String { return _checkedText; }
		public function set checkedText(value:String):void
		{
			_checkedText = value;

			if(!hostBase)
				return;
			if(hostBase.state == hostBase.STATE_CHECKED)
				hostBase.text = value;
		}

	}

    COMPILE::SWF
	public class TriStateCheckBoxLabelState
	{

		public function TriStateCheckBoxLabelState()
		{
		}
	}
}
