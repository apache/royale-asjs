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
package org.apache.royale.html.beads
{
	COMPILE::JS
	{
	import org.apache.royale.core.UIBase;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;

	/**
	 *  The SetFocus class allows any component to set focus.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class SetFocus implements IBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function SetFocus()
		{
		}

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			if(_enableFocus)
				setFocus();
		}

		/**
		 * perform the set focus on the _strand
		 */
		public function setFocus():void
		{
			COMPILE::JS
			{
			UIBase(_strand).element.focus();
			}
		}

		private var _enableFocus:Boolean;
		/**
		 *  if true sets the focus on the _strand
		 */
		[Bindable("enableFocusChanged")]
		public function get enableFocus():Boolean
		{
			return _enableFocus;
		}
		public function set enableFocus(value:Boolean):void
		{
			if(_enableFocus != value)
			{
				_enableFocus = value;
				if(_enableFocus)
					setFocus();
			}
		}
	}
}
