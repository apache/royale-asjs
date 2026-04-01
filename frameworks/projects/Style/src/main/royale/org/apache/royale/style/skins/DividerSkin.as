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
	import org.apache.royale.style.stylebeads.background.BackgroundClip;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.Flex;
	import org.apache.royale.style.stylebeads.flexgrid.FlexGrow;
	import org.apache.royale.style.stylebeads.flexgrid.FlexBasis;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.layout.Display;
	
	import org.apache.royale.style.Divider;

	public class DividerSkin extends StyleSkin implements IDividerSkin
	{
		public function DividerSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Divider
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
		
		override public function update():void{
			processStyles()
		}

		private var _lineStyles:Array;

		public function get lineStyles():Array
		{
			if(!_lineStyles)
				processStyles();
			return _lineStyles;
		}
		
		private function processStyles():void{
			var host:Divider = getHost();
			var hostSize:String = host.size;
			var hostUnit:String = host.unit;
			var size:Number =  getAppliedSize(hostSize);
			var colorAdjust:Number = getShading(hostSize);
			var edgePadding:String = computeSize(host.edgePadding, hostUnit);
			
			var appliedSize:String = computeSize(size, hostUnit);
			
			var hostStyles:Array = [
			//	new BackgroundColor('transparent'), //probably not needed
				new Display('flex'),
				new Flex(0),
				new JustifyContent('center'),
				new AlignItems('center')
			];

			var lineStylesArr:Array = [
				new BackgroundColor("slate-"+colorAdjust),
				new BorderRadius(ThemeManager.instance.activeTheme.radiusSM)
			];
			
			lineStylesArr.push(new Display('block')); // Ensure it renders

			if (host.vertical) {
				hostStyles.push(new FlexDirection('column'));
				hostStyles.push(new HeightStyle('100%'));
				
				lineStylesArr.push(new WidthStyle(appliedSize));
				lineStylesArr.push(new FlexGrow(1));
				lineStylesArr.push(new FlexBasis(0));

				if (edgePadding) {
					var hMargin:Margin = new Margin();
					hMargin.unit = hostUnit;
					hMargin.left = edgePadding;
					hMargin.right = edgePadding;
					lineStylesArr.push(hMargin);
				}
			} else {
				hostStyles.push(new FlexDirection('row'));
				hostStyles.push(new WidthStyle('100%'));

				lineStylesArr.push(new HeightStyle(appliedSize));
				lineStylesArr.push(new FlexGrow(1));
				lineStylesArr.push(new FlexBasis(0));

				if (edgePadding) {
					var vMargin:Margin = new Margin();
					vMargin.unit = hostUnit;
					vMargin.top = edgePadding;
					vMargin.bottom = edgePadding;
					lineStylesArr.push(vMargin);
				}
			}
			
			_lineStyles = lineStylesArr;
			_styles = hostStyles;
			host.setStyles(_styles, true);
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