package flex.text
{
COMPILE::SWF
{
	import flash.text.TextLineMetrics;		
}

COMPILE::SWF
public class TextLineMetrics extends flash.text.TextLineMetrics
{
	public function TextLineMetrics(x:Number, width:Number, height:Number, ascent:Number, descent:Number, leading:Number)
	{
		super(x, width, height, ascent, descent, leading);
	}
	
	public static function convert(tlm:flash.text.TextLineMetrics):flex.text.TextLineMetrics
	{
		return new flex.text.TextLineMetrics(tlm.x, tlm.width, tlm.height, tlm.ascent, tlm.descent, tlm.leading);
	}
}

COMPILE::JS
public class TextLineMetrics
{
	public function TextLineMetrics(x:Number, width:Number, height:Number, ascent:Number, descent:Number, leading:Number)
	{
		this.x = x;
		this.width = width;
		this.height = height;
		this.ascent = ascent;
		this.descent = descent;
		this.leading = leading;
	}
	
	public var x:Number;
	public var width:Number;
	public var height:Number;
	public var ascent:Number;
	public var descent:Number;
	public var leading:Number;
}
}
