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
	import org.apache.royale.style.Dropdown;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.layout.Position;
	import org.apache.royale.style.stylebeads.layout.Top;
	import org.apache.royale.style.stylebeads.layout.Visibility;
	import org.apache.royale.style.stylebeads.layout.ZIndex;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.sizing.MinWidth;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.states.FocusWithinState;
	import org.apache.royale.style.stylebeads.states.HoverState;
	import org.apache.royale.style.stylebeads.states.attribute.OpenState;
	import org.apache.royale.style.stylebeads.states.attribute.DataState;
	import org.apache.royale.style.stylebeads.states.GroupPseudo;

	public class DropdownSkin extends StyleSkin implements IDropdownSkin
	{
		public function DropdownSkin()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Dropdown
		 */
		private function get host():Dropdown
		{
			return _strand as Dropdown;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_styles = [
				new Position("relative"),
				new Display("inline-block")
			];
			host.setStyles(_styles);
		}

		private var _triggerStyles:Array;

		public function get triggerStyles():Array
		{
			if (!_triggerStyles)
				createTriggerStyles();
			return _triggerStyles;
		}

		public function set triggerStyles(value:Array):void
		{
			_triggerStyles = value;
		}

		private function createTriggerStyles():void
		{
			_triggerStyles = [
				new Cursor("pointer"),
				// When the wrapper has [data-disabled], override the trigger cursor to default
				new GroupPseudo([
					new DataState("disabled", [
						new Cursor("default")
					])
				], host.getWrapperStyle())
			];
		}

		private var _contentStyles:Array;

		public function get contentStyles():Array
		{
			if (!_contentStyles)
				createContentStyles();
			return _contentStyles;
		}

		public function set contentStyles(value:Array):void
		{
			_contentStyles = value;
		}

		private function createContentStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var bgColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 100);
			var borderColor:ColorSwatch = colorSet.getSwatch(ThemeColorSet.NEUTRAL, 200);

			var top:Top = new Top();
			top.value = "100%";

			var margin:Margin = new Margin();
			margin.top = 1;

			var padding:Padding = new Padding();
			padding.block = 2;
			padding.inline = 0;

			_contentStyles = [
				new Position("absolute"),
				top,
				new ZIndex(50),
				new Visibility("hidden"),
				new OpacityStyle(0),
				new Transition(),
				new MinWidth("12rem"),
				new BackgroundColor(bgColor),
				new BorderWidth(0.25),
				new BorderColor(borderColor),
				new BorderRadius(ThemeManager.instance.activeTheme.radiusMD),
				margin,
				padding,
				new GroupPseudo([
					new FocusWithinState([
						new Visibility("visible"),
						new OpacityStyle(100)
					])
				], host.getWrapperStyle()),
				new GroupPseudo([
					new OpenState([
						new Visibility("visible"),
						new OpacityStyle(100)
					])
				], host.getWrapperStyle())
			];
		}

		private var _itemStyles:Array;

		public function get itemStyles():Array
		{
			if (!_itemStyles)
				createItemStyles();
			return _itemStyles;
		}

		public function set itemStyles(value:Array):void
		{
			_itemStyles = value;
		}

		private function createItemStyles():void
		{
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var hoverBg:ColorSwatch = colorSet.getSwatch(ThemeColorSet.BASE, 200);

			var padding:Padding = new Padding();
			padding.block = 2;
			padding.inline = 3;

			_itemStyles = [
				new Cursor("pointer"),
				padding,
				new HoverState([
					new BackgroundColor(hoverBg)
				])
			];
		}

		override public function update():void
		{
			_triggerStyles = null;
			_contentStyles = null;
			_itemStyles = null;
		}
	}
}
