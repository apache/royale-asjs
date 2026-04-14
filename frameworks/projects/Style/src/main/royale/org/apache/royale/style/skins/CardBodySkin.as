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
	import org.apache.royale.style.CardBody;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.spacing.Padding;

	public class CardBodySkin extends StyleSkin
	{
		public function CardBodySkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.CardBody
		 */
		private function get host():CardBody
		{
			return _strand as CardBody;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			applyStyles();
		}

		private function applyStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var paddingVal:String = computeSize(size * 1.5, host.unit);
			var gapVal:String = computeSize(size * 0.5, host.unit);

			var padding:Padding = new Padding();
			padding.padding = paddingVal;

			if(!_styles)
			{
				_styles = [
					new Display("flex"),
					new FlexDirection("column"),
					new Gap(gapVal),
					padding
				];
				host.setStyles(_styles);
			}
		}

		private function getMultiplier():Number
		{
			switch(host.size)
			{
				case "xs":
					return 0.75;
				case "sm":
					return 0.875;
				case "md":
					return 1;
				case "lg":
					return 1.125;
				case "xl":
					return 1.25;
				default:
					return 1;
			}
		}
	}
}
