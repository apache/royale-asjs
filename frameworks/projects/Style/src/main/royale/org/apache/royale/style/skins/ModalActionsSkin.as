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
	import org.apache.royale.style.ModalActions;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;

	public class ModalActionsSkin extends StyleSkin
	{
		public function ModalActionsSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.ModalActions
		 */
		private function get host():ModalActions
		{
			return _strand as ModalActions;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			if(!_styles)
			{
				_styles = [
					new Display("flex"),
					new JustifyContent("end"),
					new Gap(computeSize(8, host.unit))
				];
				host.setStyles(_styles);
			}
		}
	}
}
