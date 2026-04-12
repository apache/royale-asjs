package org.apache.royale.style.skins
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.style.TextButton;
	import org.apache.royale.style.StyleSkin;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.colors.ThemeColorSet;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.style.stylebeads.spacing.Padding;
	import org.apache.royale.style.stylebeads.border.BorderRadius;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.typography.FontWeight;
	import org.apache.royale.style.stylebeads.typography.TextColor;
	import org.apache.royale.style.stylebeads.typography.LetterSpacing;
	import org.apache.royale.style.stylebeads.states.HoverState;
	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.style.stylebeads.states.DisabledState;
	import org.apache.royale.style.stylebeads.states.RequiredState;
	import org.apache.royale.style.stylebeads.typography.FontSize;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.svg.Stroke;

	/**
	 * Button skin that exposes style beads and optional icons for Button component.
	 */
	public class TextButtonSkin extends StyleSkin
	{
		public function TextButtonSkin()
		{
			super();
		}
		private function get host():TextButton
		{
			return _strand as TextButton;
		}
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (_styles)
				return;
			var colorSet:ThemeColorSet = ThemeManager.instance.activeTheme.themeColorSet;
			var haveTheme:Boolean = host.theme && host.theme != "default";
			var baseColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 300) : null;
			var hoverColor:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 400) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 200);

			var darkText:ColorSwatch = haveTheme ? colorSet.getSwatch(host.theme, 800) : colorSet.getSwatch(ThemeColorSet.NEUTRAL, 800);
			var textColor:String = (haveTheme && getTextColorBasedOnBackground(baseColor)) ? "white" : darkText.colorSpecifier;
			var hoverTextColor:String = getTextColorBasedOnBackground(hoverColor) ? "white" : darkText.colorSpecifier;

			var fontSize:String = computeSize(getFontSizePx(), host.unit);
			var paddings:Padding = new Padding();
			paddings.block = getBlockPadding();
			paddings.inline = getInlinePadding();
			_styles = [
					new BorderRadius(ThemeManager.instance.activeTheme.radiusSM),
					new Display("inline-flex"),
					new AlignItems("center"),
					new JustifyContent("center"),
					new Gap(2),
					paddings,
					new FontWeight("semibold"),
					new FontSize(fontSize),
					new LetterSpacing("wide"),
					new HoverState([
							new BackgroundColor(hoverColor),
							new TextColor(hoverTextColor)
						]),
					new DisabledState([
							new BackgroundColor(colorSet.getSwatch(ThemeColorSet.NEUTRAL, 300)),
							new TextColor(colorSet.getSwatch(ThemeColorSet.NEUTRAL, 500))
						])
				];
				if(haveTheme)
				{
					_styles.push(new TextColor(textColor));
				}
			if (baseColor)
			{
				_styles.push(
						new BackgroundColor(baseColor)
					);
			}
			host.setStyles(_styles);
		}
		public function getIcon():Icon
		{
			var markup:XML = <svg fill="none" viewBox="0 0 24 24" class="shrink-0" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>;
			var iconName:String = "alert-" + ThemeColorSet.INFO;
			Icon.registerIcon(iconName, markup);
			var icon:Icon = new Icon(iconName);
			var iconSize:String = computeSize(getIconSizePx(), host.unit);
			icon.styleBeads = [
					new WidthStyle(iconSize),
					new HeightStyle(iconSize),
					new Stroke("currentColor"),
				];
			return icon;
		}

		private function getIconSizePx():Number
		{
			switch (host.size)
			{
				case "xs":
					return 14;
				case "sm":
					return 16;
				case "md":
					return 18;
				case "lg":
					return 20;
				case "xl":
					return 22;
				default:
					return 18;
			}
		}
		// Returns true when white text has better contrast; false means black text.
		private function getTextColorBasedOnBackground(color:ColorSwatch):Boolean
		{
			if (!color)
				return false;
			var rgb:Array = color.getRGB();
			var bgLuminance:Number = getRelativeLuminance(rgb[0], rgb[1], rgb[2]);
			var whiteContrast:Number = (1.0 + 0.05) / (bgLuminance + 0.05);
			var blackContrast:Number = (bgLuminance + 0.05) / 0.05;
			return whiteContrast >= blackContrast;
		}

		private function getRelativeLuminance(r:Number, g:Number, b:Number):Number
		{
			var sr:Number = getLinearChannel(r / 255.0);
			var sg:Number = getLinearChannel(g / 255.0);
			var sb:Number = getLinearChannel(b / 255.0);
			return 0.2126 * sr + 0.7152 * sg + 0.0722 * sb;
		}

		private function getFontSizePx():Number
		{
			switch (host.size)
			{
				case "xs":
					return 11; // text-[0.6875rem]
				case "sm":
					return 12; // text-[0.75rem]
				case "md":
					return 14; // text-[0.875rem]
				case "lg":
					return 18; // text-[1.125rem]
				case "xl":
					return 22; // text-[1.375rem]
				default:
					return 14; // text-[0.875rem]
			}
		}

		private function getBlockPadding():Number
		{
			switch (host.size)
			{
				case "xs":
					return 1;
					// return 0.5;
				case "sm":
					return 2;
					// return 1;
				case "md":
					return 3;
					// return 1.5;
				case "lg":
					return 4;
					// return 2;
				case "xl":
					return 5;
					// return 2.5;
				default:
					return 3;
					// return 1.5;
			}
		}

		private function getInlinePadding():Number
		{
			switch (host.size)
			{
				case "xs":
					return 2;
				case "sm":
					return 3;
				case "md":
					return 4;
				case "lg":
					return 5;
				case "xl":
					return 6;
				default:
					return 4;
			}
		}

		private function getLinearChannel(value:Number):Number
		{
			return value <= 0.03928 ? (value / 12.92) : Math.pow((value + 0.055) / 1.055, 2.4);
		}
	}
}
