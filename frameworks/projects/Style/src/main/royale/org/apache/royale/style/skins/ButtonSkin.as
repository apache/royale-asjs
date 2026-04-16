package org.apache.royale.style.skins
{
	import org.apache.royale.core.IStrand;
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
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.sizing.HeightStyle;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.svg.Stroke;
	import org.apache.royale.style.Button;
	import org.apache.royale.style.stylebeads.typography.FontSize;

	/**
	 * Button skin that exposes style beads for Button component.
	 */
	public class ButtonSkin extends StyleSkin
	{
		public function ButtonSkin()
		{
			super();
		}
		private function get host():Button
		{
			return _strand as Button;
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
			var textColor:String = (haveTheme && baseColor.isDark()) ? "white" : darkText.colorSpecifier;
			var hoverTextColor:String = hoverColor.isDark() ? "white" : darkText.colorSpecifier;

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
					new FontSize(host.unit || "base"),
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

		private function getBlockPadding():Number
		{
			switch (host.size)
			{
				case "xs":
					return 0.5;
				case "sm":
					return 1;
				case "md":
					return 1.5;
				case "lg":
					return 2;
				case "xl":
					return 2.5;
				default:
					return 1.5;
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
	}
}
