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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.CheckBox;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.interact.Cursor;
	import org.apache.royale.style.stylebeads.flexgrid.GridAutoColumns;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.RowGap;
	import org.apache.royale.style.stylebeads.interact.UserSelect;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumn;
	import org.apache.royale.style.stylebeads.flexgrid.GridColumnStart;
	import org.apache.royale.style.stylebeads.flexgrid.GridRowStart;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.border.BorderWidth;
	import org.apache.royale.style.stylebeads.border.BorderColor;
	import org.apache.royale.style.stylebeads.anim.Transition;
	import org.apache.royale.style.stylebeads.states.PeerPseudo;
	import org.apache.royale.style.stylebeads.states.FocusVisibleState;
	import org.apache.royale.style.stylebeads.border.Outline;
	import org.apache.royale.style.stylebeads.states.CheckedState;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.states.IndeterminateState;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.stylebeads.CompositeStyle;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceContent;
	import org.apache.royale.style.stylebeads.flexgrid.PlaceSelf;
	import org.apache.royale.style.stylebeads.border.Border;
	import org.apache.royale.style.stylebeads.transform.Transform;
	import org.apache.royale.style.stylebeads.effects.OpacityStyle;

	public class CheckBoxSkin extends StyleSkin implements ICheckBoxSkin
	{
		public function CheckBoxSkin()
		{
			super();
		}
		/**
    .checkbox[data-size="sm"] {
      --size: 0.875rem;
    }

    .checkbox[data-size="md"] {
      --size: 1rem; *4;
    }

    .checkbox[data-size="lg"] {
      --size: 1.125rem;
    }

    .checkbox[data-size="xl"] {
      --size: 1.25rem;
    }

		 */
		/**
		 * @royaleignorecoercion org.apache.royale.style.CheckBox
		 */
		private function get host():CheckBox
		{
			return _strand as CheckBox;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			// Manually set. Don't create the default ones.
			if(_styles)
				return;
			var size:Number = 16 * getMultiplier();
			var box:String = computeSize(size * 1.25, host.unit);
			var gap:String = computeSize(size * 0.75, host.unit);
			var disabledStyle:DisabledState = new DisabledState();
			disabledStyle.styles = [
				new Cursor("auto")
			];
			_styles = [
				new Display("inline-grid"),
				new Cursor("pointer"),
				new GridAutoColumns(box + " auto"),
				new AlignItems("center"),
				new RowGap(gap),
				new UserSelect("none"),
				disabledStyle
			];
		}
		private function getMultiplier():Number
		{
			var multiple:Number;
			switch(host.size)
			{
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

		private var _boxStyles:Array;

		public function get boxStyles():Array
		{
			if(!_boxStyles)
				createBoxStyles();
			return _boxStyles;
		}
		private function createBoxStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var box:String = computeSize(size * 1.25, host.unit);
			var gap:String = computeSize(size * 0.75, host.unit);
			_boxStyles = [
				new GridColumnStart("1"),
				new GridRowStart("1"),
				new HeightStyle(box),
				new WidthStyle(box),
				new BorderRadius(ThemeManager.instance.activeTheme.radiusSM),
				new BorderWidth(2),
				new BorderColor("slate-500"),
				new Transition()
			];
			var peer:PeerPseudo = new PeerPseudo();
			var focusVisible:FocusVisibleState = new FocusVisibleState();
			var outline1:Outline = new Outline();
			outline1.width = 2;
			outline1.color = "orange-500/40";
			outline1.offset = 2;
			focusVisible.styles = [outline1];
			var checked:CheckedState = new CheckedState();
			checked.styles = [
				new BorderColor("orange-500"),
				new BackgroundColor("orange-500")
			];
			var indeterminate:IndeterminateState = new IndeterminateState();
			indeterminate.styles = [
				new BorderColor("orange-500"),
				new BackgroundColor("orange-500")
			];
			var disabled:DisabledState = new DisabledState();
			disabled.styles = [
				new BorderColor("slate-300"),
				new BackgroundColor("slate-100")
			];

			peer.styles = [
				focusVisible,
				checked,
				indeterminate,
				disabled
			];
			_boxStyles.push(peer);
		/**
		 col-start-1
		row-start-1
		h-[var(--box)]
		w-[var(--box)]
		rounded
		border-2
		border-slate-500
		transition
		peer-focus-visible:ring-2
		peer-focus-visible:ring-orange-500/40
		peer-focus-visible:ring-offset-2
		peer-focus-visible:ring-offset-slate-50
		peer-checked:border-orange-500
		peer-checked:bg-orange-500
		peer-indeterminate:border-orange-500
		peer-indeterminate:bg-orange-500
		peer-disabled:border-slate-300
		peer-disabled:bg-slate-100
		dark:border-slate-400
		dark:peer-focus-visible:ring-orange-500/40
		dark:peer-focus-visible:ring-offset-slate-950
		dark:peer-disabled:border-slate-600
		dark:peer-disabled:bg-slate-800
		
		peer-focus-visible:outline
		peer-focus-visible:outline-2
		peer-focus-visible:outline-orange-500/40
		peer-focus-visible:outline-offset-2
		peer-checked:border-orange-500
		peer-checked:bg-orange-500
		peer-indeterminate:border-orange-500
		peer-indeterminate:bg-orange-500
		peer-disabled:border-slate-300
		peer-disabled:bg-slate-100
		dark:border-slate-400
		dark:peer-disabled:border-slate-600
		dark:peer-disabled:bg-slate-800

		*/
		}

		public function set boxStyles(value:Array):void
		{
			_boxStyles = value;
		}
		private var _labelStyles:Array;

		public function get labelStyles():Array
		{
			if(!_labelStyles)
				createLabelStyles();
			return _labelStyles;
		}
		private function createLabelStyles():void
		{
			var size:Number = 16 * getMultiplier();
			var fontSize:String = computeSize(size, host.unit);

			_labelStyles = [
				new GridColumnStart("2"),
				new GridRowStart("1"),
				new FontSize(fontSize),
				new FontWeight("600"),
				new TextColor("slate-800")
			];
			var peer:PeerPseudo = new PeerPseudo();
			var disabled:DisabledState = new DisabledState();
			disabled.styles = [
				new TextColor("slate-400")
			];
			peer.styles = [
				disabled
			];
			_labelStyles.push(peer);
/**
 col-start-2
 row-start-1
 text-[length:var(--size)]
 font-semibold
 text-slate-800
 dark:text-slate-100
 peer-disabled:text-slate-400
 dark:peer-disabled:text-slate-500
 */

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
				var div:Div = new Div();
				_checkIcon = div;
				// var iconName:String = "style_checkIconSmall";
				// if(!Icon.isRegistered(iconName))
				// 	Icon.registerIcon(iconName,
				// 		<svg viewBox="0 0 12 10" fill="none" aria-hidden="true" width="10" height="10">
				// 			<path d="M1.5 5.5L4.5 8.5L10.5 1.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
				// 		</svg>);
				// _checkIcon = new Icon(iconName);
				// --tick-h: calc(var(--size) * 0.625);
				// --tick-w: calc(var(--size) * 0.375);
				var size:Number = 16 * getMultiplier();
				var transform:Transform = new Transform();
				transform.translateY = "8%";
				transform.rotate = "45deg";
	
				var borderWidth:BorderWidth = new BorderWidth();
				borderWidth.bottom = 3;
				borderWidth.right = 3;
				var styles:CompositeStyle = new CompositeStyle();
				styles.styles = [
					new GridColumnStart("1"),
					new GridRowStart("1"),
					new HeightStyle(computeSize(size * 0.625, host.unit)),
					new WidthStyle(computeSize(size * 0.375, host.unit)),
					new PlaceSelf("center"),
					transform,
					borderWidth,
					new BorderColor("white"),
					new Transition(),
					new OpacityStyle(0),
					new PeerPseudo([
						new CheckedState([
							new OpacityStyle(1)
						]),
						new IndeterminateState([
							new OpacityStyle(0)
						]),
						new DisabledState([
							new BorderColor("slate-300"),
						])
					])
				];
				div.addStyleBead(styles);
				// TODO dark mode styles
			}

/**
col-start-1
row-start-1
h-[var(--tick-h)]
w-[var(--tick-w)]
place-self-center
-translate-y-[8%]
rotate-45
border-b-[3px]
border-r-[3px]
border-white
opacity-0
transition
peer-checked:opacity-100
peer-indeterminate:opacity-0
peer-disabled:border-slate-300
dark:peer-disabled:border-slate-500
 */				
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
				_indeterminateIcon = new Div();
				var size:Number = 16 * getMultiplier();

				var styles:CompositeStyle = new CompositeStyle();
				styles.styles = [
					new GridColumnStart("1"),
					new GridRowStart("1"),
					new HeightStyle("14%"),
					new WidthStyle(computeSize(size * 0.625, host.unit)),
					new PlaceSelf("center"),
					new BorderRadius(ThemeManager.instance.activeTheme.radiusSM),
					new BackgroundColor("white"),
					new Transition(),
					new OpacityStyle(0),
					new PeerPseudo([
						new IndeterminateState([
							new OpacityStyle(1)
						]),
						new DisabledState([
							new BackgroundColor("slate-300")
						])
					])
				];
				// var iconName:String = "style_indeterminateIconSmall";
				// if(!Icon.isRegistered(iconName))
				// 	Icon.registerIcon(iconName,
				// 		<svg viewBox="0 0 12 10" fill="none" aria-hidden="true" width="10" height="10">
				// 			<rect x="1" y="4.5" width="10" height="1" fill="currentColor"/>
				// 		</svg>);
				// _indeterminateIcon = new Icon(iconName);
/**
 col-start-1
 row-start-1
 h-[14%]
 w-[var(--minus-w)]
 place-self-center
 rounded
 bg-white
 opacity-0
 transition
 peer-indeterminate:opacity-100
 peer-disabled:bg-slate-300
 dark:peer-disabled:bg-slate-500
 */

			}
			return _indeterminateIcon;
		}

		public function set indeterminateIcon(value:IStyleUIBase):void
		{
			_indeterminateIcon = value;
		}

	}
}