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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.beads.controls.ToolTip;
	import org.apache.royale.jewel.TriStateCheckBox;

	
    COMPILE::JS
	public class TriStateCheckBoxTooltipState extends ToolTip
	{
		
		public function TriStateCheckBoxTooltipState()
		{
		}
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            listenOnStrand("change", toolTipChangeHandler);
		}

		private function get hostBase():TriStateCheckBox
		{
			return _strand as TriStateCheckBox;
		}
		
		protected function toolTipChangeHandler(event:Event):void
		{
			updateHost();
		}
		
		protected function updateHost():void
		{
			if (!hostBase)
				return;
            
            var _lastTooltip:String;
			if(hostBase.isIndeterminate())
				_lastTooltip = _indeterminateTooltip;
			else if(hostBase.isUnChecked())
				_lastTooltip = _uncheckedTooltip;
			else
				_lastTooltip = _checkedTooltip;

			if(_lastTooltip != toolTip)
				toolTip = _lastTooltip;
				
        }

		private var _indeterminateTooltip:String;
		public function get indeterminateTooltip():String { return _indeterminateTooltip; }
		public function set indeterminateTooltip(value:String):void 		
		{
			_indeterminateTooltip = value;
            updateHost();
		}

		private var _uncheckedTooltip:String;
		public function get uncheckedTooltip():String { return _uncheckedTooltip; }
		public function set uncheckedTooltip(value:String):void 		
		{
			_uncheckedTooltip = value;
            updateHost();
		}

		private var _checkedTooltip:String;
		public function get checkedTooltip():String { return _checkedTooltip; }
		public function set checkedTooltip(value:String):void 		
		{
			_checkedTooltip = value;
            updateHost();
		}
		
	}

    COMPILE::SWF
	public class TriStateCheckBoxTooltipState extends ToolTip
	{
		
		public function TriStateCheckBoxTooltipState()
		{
		}
	}
}