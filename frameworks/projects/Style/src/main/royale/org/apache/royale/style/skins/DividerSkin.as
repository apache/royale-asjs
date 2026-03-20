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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	
	import org.apache.royale.style.Divider;
	
	public class DividerSkin extends StyleSkin /*implements ICheckBoxSkin*/
	{
		public function DividerSkin()
		{
			super();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.CheckBox
		 */
		private function getHost():Divider
		{
			return _strand as Divider;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			processStyles();
		}
		
		private function processStyles():void{
			var host:Divider = getHost();
			var hostSize:String = getHost().size;
			var size:Number =  getAppliedSize(hostSize);
			var colorAdjust:Number = getShading(hostSize);
			var appliedSize:String = computeSize(size , host.unit);
			var styles:Array = [
					new BackgroundColor("slate-"+colorAdjust),
				    new BorderRadius(ThemeManager.instance.activeTheme.radiusSM)
			]
			if (getHost().vertical) {
				styles.push(new HeightStyle('100%'));
				styles.push(new WidthStyle())
			} else {
				styles.push(new WidthStyle('100%'));
				styles.push(new HeightStyle(appliedSize));
			}
			_styles = styles;
			
			host.setStyles(_styles);
		}
		
		private function getShading(size:String):Number{
			switch(size)
			{
				case "sm":
					return 250;
				case "lg":
					return 500;
				case "xl":
					return 700;
				case "md":
				default:
					return 900;
			}
		}
		
		private function getAppliedSize(size:String):Number
		{
			switch(size)
			{
				case "sm":
					return 1;
				case "lg":
					return 4;
				case "xl":
					return 8;
				case "md":
				default:
					return 2;
			}
		}

		
	}
}