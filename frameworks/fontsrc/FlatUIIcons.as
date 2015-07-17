package
{
import flash.display.Sprite;
import flash.text.Font;

public class FlatUIIcons extends Sprite
{
	 /* 
      * Embed a font with bold typeface by location. 
      */
     [Embed(source='../fonts/flat-ui-icons-regular.ttf', 
        fontWeight='normal', 
        fontName='Flat-UI-Icons', 
        mimeType='application/x-font', 
        embedAsCFF='false'
     )] 
     private var font2:Class;

	public function FlatUIIcons()
	{
		Font.registerFont(font2);
	}
}
}
