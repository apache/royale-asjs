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
package org.apache.royale.style.skins
{
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.IIcon;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.IStyleUIBase;

	public class CheckBoxSkin extends StyleSkin implements ICheckBoxSkin
	{
		public function CheckBoxSkin()
		{
			super();
			_styles = [
				// new CheckBoxBackground(),
				// new CheckBoxBorder(),
				// new CheckBoxCheckmark()
			];
		}

		private var _boxStyles:Array;

		public function get boxStyles():Array
		{
			return _boxStyles;
		}

		public function set boxStyles(value:Array):void
		{
			_boxStyles = value;
		}
		private var _labelStyles:Array;

		public function get labelStyles():Array
		{
			return _labelStyles;
		}

		public function set labelStyles(value:Array):void
		{
			_labelStyles = value;
		}

		private var _checkIcon:IStyleUIBase;
		/**
		 * The checkIcon should have any styles pre-applied.
		 */
		public function get checkIcon():IStyleUIBase
		{
			if(!_checkIcon){
				var iconName:String = "style_checkIconSmall";
				if(!Icon.isRegistered(iconName))
					Icon.registerIcon(iconName,
						<svg viewBox="0 0 12 10" fill="none" aria-hidden="true" width="10" height="10">
							<path d="M1.5 5.5L4.5 8.5L10.5 1.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
						</svg>);
				_checkIcon = new Icon(iconName);
			}
			return _checkIcon;
		}

		public function set checkIcon(value:IStyleUIBase):void
		{
			_checkIcon = value;
		}

		private var _indeterminateIcon:IStyleUIBase;
		/**
		 * The indeterminateIcon should have any styles pre-applied.
		 */
		public function get indeterminateIcon():IStyleUIBase
		{
			if(!_indeterminateIcon){
				var iconName:String = "style_indeterminateIconSmall";
				if(!Icon.isRegistered(iconName))
					Icon.registerIcon(iconName,
						<svg viewBox="0 0 12 10" fill="none" aria-hidden="true" width="10" height="10">
							<rect x="1" y="4.5" width="10" height="1" fill="currentColor"/>
						</svg>);
				_indeterminateIcon = new Icon(iconName);
			}
			return _indeterminateIcon;
		}

		public function set indeterminateIcon(value:IStyleUIBase):void
		{
			_indeterminateIcon = value;
		}

	}
}