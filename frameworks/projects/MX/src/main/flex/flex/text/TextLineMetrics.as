package flex.text
{
COMPILE::AS3
{
	import flash.text.TextLineMetrics;		
}

COMPILE::AS3
public class TextLineMetrics extends flash.text.TextLineMetrics
{
	public function TextLineMetrics(x:Number, width:Number, height:Number, ascent:Number, descent:Number, leading:Number)
	{
		super(x, width, height, ascent, descent, leading);
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