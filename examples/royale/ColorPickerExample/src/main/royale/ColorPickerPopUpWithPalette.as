package 
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.HideColorSpectrumThumbWhenEmpty;
	import org.apache.royale.html.beads.layouts.TileLayout;
	import org.apache.royale.html.supportClasses.ColorPalette;
	import org.apache.royale.html.supportClasses.ColorPickerPopUp;
	import org.apache.royale.core.IColorSpectrumModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	public class ColorPickerPopUpWithPalette extends ColorPickerPopUp
	{
		protected var colorPalette:ColorPalette;
		public function ColorPickerPopUpWithPalette()
		{
			super();
			colorSpectrum.addBead(new HideColorSpectrumThumbWhenEmpty());
			style = {padding: 10};
			colorPalette = new ColorPalette();
			var colorPaletteLayout:TileLayout = loadBeadFromValuesManager(TileLayout, "iBeadLayout", colorPalette) as TileLayout;
			colorPaletteLayout.rowHeight = colorPaletteLayout.columnWidth = 30;
			var pwidth:Number = 100;
			var margin:Number = 10;
			colorPalette.width =  pwidth;
			colorSpectrum.x = pwidth + margin;
			COMPILE::JS 
			{
				colorSpectrum.element.style.position = "absolute";
			}
			hueSelector.x += pwidth + margin;
			
		}
		
		override public function set model(value:Object):void
		{
			super.model = value;
			colorPalette.model = value;
			(value as IEventDispatcher).addEventListener("change", changeHandler);
			
			if (getElementIndex(colorPalette) < 0)
			{
				addElement(colorPalette);
			}
		}
		
		private function changeHandler(event:org.apache.royale.events.Event):void
		{
			var model:IColorSpectrumModel = colorSpectrum.model as IColorSpectrumModel;
			model.baseColor = model.hsvModifiedColor = colorPalette.selectedItem as Number;
		}
	}
}
