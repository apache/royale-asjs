package
{

import flash.display.Sprite;

import classes.B;

import interfaces.IA;
import interfaces.IB;
import interfaces.IC;
import interfaces.ID;
import interfaces.IE;

public class LanguageTests extends Sprite implements IA, IE
{
	public function LanguageTests()
	{
		var testResult:Boolean;
		var testObject:Object;
		
		var b:B = new B();
		
		testResult = this instanceof Sprite;
		trace('this instanceof Sprite - true: ' + testResult.toString());
		testResult = this instanceof B;
		trace('this instanceof classes.B - false: ' + testResult.toString());
		testResult = b instanceof classes.B;
		trace('b instanceof classes.B - true: ' + testResult.toString());
		testResult = b instanceof classes.C;
		trace('b instanceof classes.C - true: ' + testResult.toString());
		testResult = b instanceof interfaces.IC;
		trace('b instanceof interfaces.IC - false: ' + testResult.toString());
		testResult = b instanceof interfaces.IF;
		trace('b instanceof interfaces.IF - false: ' + testResult.toString());
		testResult = this instanceof IA;
		trace('this instanceof interfaces.IA - false: ' + testResult.toString());
		testResult = this instanceof IB;
		trace('this instanceof interfaces.IB - false: ' + testResult.toString());
		testResult = this instanceof IC;
		trace('this instanceof interfaces.IC - false: ' + testResult.toString());
		testResult = this instanceof ID;
		trace('this instanceof interfaces.ID - false: ' + testResult.toString());
		testResult = this instanceof IE;
		trace('this instanceof interfaces.IE - false: ' + testResult.toString());
		trace();
		testResult = this is Sprite;
		trace('this is Sprite - true: ' + testResult.toString());
		testResult = this is B;
		trace('this is classes.B - false: ' + testResult.toString());
		testResult = b is classes.B;
		trace('b is classes.B - true: ' + testResult.toString());
		testResult = b is classes.C;
		trace('b is classes.C - true: ' + testResult.toString());
		testResult = b is interfaces.IC;
		trace('b is interfaces.IC - false: ' + testResult.toString());
		testResult = b is interfaces.IF;
		trace('b is interfaces.IF - true: ' + testResult.toString());
		testResult = this is IA;
		trace('this is interfaces.IA - true: ' + testResult.toString());
		testResult = this is IB;
		trace('this is interfaces.IB - false: ' + testResult.toString());
		testResult = this is IC;
		trace('this is interfaces.IC - true: ' + testResult.toString());
		testResult = this is ID;
		trace('this is interfaces.ID - true: ' + testResult.toString());
		testResult = this is IE;
		trace('this is interfaces.IE - true: ' + testResult.toString());
		trace();
		testObject = (this as Sprite) ? this as Sprite : 'null';
		trace('this as Sprite - [object ...]: ' + testObject.toString());
		testObject = (this as B) ? this as B : 'null';
		trace('this as classes.B - null: ' + testObject.toString());
		testObject = (b as classes.B) ? b as classes.B : 'null';
		trace('b as classes.B - [object ...]: ' + testObject.toString());
		testObject = (b as classes.C) ? b as classes.C : 'null';
		trace('b as classes.C - [object ...]: ' + testObject.toString());
		testObject = (b as interfaces.IC) ? b as interfaces.IC : 'null';
		trace('b as interfaces.IC - null: ' + testObject.toString());
		testObject = (b as interfaces.IF) ? b as interfaces.IF : 'null';
		trace('b as interfaces.IF - [object ...]: ' + testObject.toString());
		testObject = (this as IA) ? this as IA : 'null';
		trace('this as interfaces.IA - [object ...]: ' + testObject.toString());
		testObject = (this as IB) ? this as IB : 'null';
		trace('this as interfaces.IB - null: ' + testObject.toString());
		testObject = (this as IC) ? this as IC : 'null';
		trace('this as interfaces.IC - [object ...]: ' + testObject.toString());
		testObject = (this as ID) ? this as ID : 'null';
		trace('this as interfaces.ID - [object ...]: ' + testObject.toString());
		testObject = (this as IE) ? this as IE : 'null';
		trace('this as interfaces.IE - [object ...]: ' + testObject.toString());
	}
}
}