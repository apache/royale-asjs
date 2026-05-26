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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.HeroContent;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.ZIndex;
	import org.apache.royale.style.stylebeads.sizing.MaxWidth;
	import org.apache.royale.style.stylebeads.typography.TextAlign;

	public class HeroContentSkin extends StyleSkin
	{
		public function HeroContentSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.HeroContent
		 */
		override public function set strand(value:IStrand):void
		{
			var content:HeroContent = value as HeroContent;

			_styles = [
				new Display("flex"),
				new Position("relative"),
				new ZIndex(1),
				new FlexDirection("column"),
				new AlignItems("center"),
				new JustifyContent("center"),
				new Gap(computeSize(16, content.unit)),
				new TextAlign("center"),
				new MaxWidth(computeSize(640, content.unit))
			];

			super.strand = value;
		}
	}
}
