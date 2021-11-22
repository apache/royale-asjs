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
	import org.apache.royale.jewel.TriStateCheckBox;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	}


	/**
	 * The TriStateCheckBoxStatesValues bead allows to set a custom value for each state.
	 */
    COMPILE::JS
	public class TriStateCheckBoxStatesValues implements IBead
	{

		public function TriStateCheckBoxStatesValues()
		{
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			var hostBase:TriStateCheckBox = value as TriStateCheckBox;

			var oldstateval:String = hostBase.state;
			var newstateval:String = hostBase.state;

			if( indeterminateValue != "" && hostBase.STATE_INDETERMINATE != indeterminateValue ){
				if(oldstateval == hostBase.STATE_INDETERMINATE)
					newstateval = indeterminateValue;
				hostBase.STATE_INDETERMINATE = indeterminateValue;
			}

			if( uncheckedValue != "" && hostBase.STATE_UNCHECKED != uncheckedValue ){
				if(oldstateval == hostBase.STATE_UNCHECKED)
					newstateval = uncheckedValue;
				hostBase.STATE_UNCHECKED = uncheckedValue;
			}

			if( checkedValue != "" && hostBase.STATE_CHECKED != checkedValue ){
				if(oldstateval == hostBase.STATE_CHECKED)
					newstateval = checkedValue;
				hostBase.STATE_CHECKED = checkedValue;
			}

			if(oldstateval != newstateval)
				hostBase.state = newstateval;
		}

		public var indeterminateValue:String= "";
		public var uncheckedValue:String= "";
		public var checkedValue:String= "";

	}

    COMPILE::SWF
	public class TriStateCheckBoxStatesValues
	{

		public function TriStateCheckBoxStatesValues()
		{
		}
	}
}
