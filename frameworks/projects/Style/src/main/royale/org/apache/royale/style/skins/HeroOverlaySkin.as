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
	import org.apache.royale.style.HeroOverlay;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.layout.Bottom;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Left;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.Right;
	import org.apache.royale.style.stylebeads.layout.Top;
	import org.apache.royale.style.stylebeads.layout.ZIndex;

	public class HeroOverlaySkin extends StyleSkin
	{
		public function HeroOverlaySkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.HeroOverlay
		 */
		override public function set strand(value:IStrand):void
		{
			var overlay:HeroOverlay = value as HeroOverlay;

			_styles = [
				new Position("absolute"),
				new Top(computeSize(0, overlay.unit)),
				new Right(computeSize(0, overlay.unit)),
				new Bottom(computeSize(0, overlay.unit)),
				new Left(computeSize(0, overlay.unit)),
				new Display("block"),
				new ZIndex(0),
				new BackgroundColor("slate-900/55")
			];

			super.strand = value;
		}
	}
}
