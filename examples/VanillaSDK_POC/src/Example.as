package  
{

import flash.events.MouseEvent;

import spark.components.Button;
import spark.components.Group;
import spark.components.Label;

public class Example extends Group
{
	public function Example() {}
	
	private const BYEBYE:String = "Bye Bye";
	private const HELLOWORLD:String = "Hello World";
	
	private var _btn:Button;
	private var _lbl:Label;
	
	public function init():void
	{
		_lbl = new Label();
		_lbl.x = 100;
		_lbl.y = 25;
		_lbl.text = HELLOWORLD;
		
		addElement(_lbl);
		
		_btn = new Button();
		_btn.x = 100;
		_btn.y = 50;
		_btn.label = "Click me";
		_btn.addEventListener(MouseEvent.CLICK, btn_clickHandler);
		
		addElement(_btn);
	}
	
	protected function btn_clickHandler(event:MouseEvent):void
	{
		if (_lbl.text == HELLOWORLD)
			_lbl.text = BYEBYE;
		else
			_lbl.text = HELLOWORLD;
	}
	
}
}