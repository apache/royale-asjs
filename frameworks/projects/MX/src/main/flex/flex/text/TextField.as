package flex.text
{
COMPILE::AS3
{
	import flash.text.TextField;		
}
COMPILE::JS
{
	import org.apache.flex.html.Label;
}

COMPILE::AS3
public class TextField extends flash.text.TextField
{
	public function TextField()
	{
		super();
	}
}

COMPILE::JS
public class TextField extends Label implements IUITextField
{
	
}
}