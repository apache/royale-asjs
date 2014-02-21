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
package
{

import flash.display.Sprite;

import classes.B;

import interfaces.IA;
import interfaces.IB;
import interfaces.IC;
import interfaces.ID;
import interfaces.IE;
import interfaces.IF;

public class LanguageTests extends Sprite implements IA, IE
{
	public function LanguageTests()
	{
		var testResult:Boolean;
		var testObject:Object;
		
		var b:B = new B();
		
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
		trace('b is interfaces.IF - false: ' + testResult.toString());
		testResult = this is IA;
		trace('this is interfaces.IA - false: ' + testResult.toString());
		testResult = this is IB;
		trace('this is interfaces.IB - false: ' + testResult.toString());
		testResult = this is IC;
		trace('this is interfaces.IC - false: ' + testResult.toString());
		testResult = this is ID;
		trace('this is interfaces.ID - false: ' + testResult.toString());
		testResult = this is IE;
		trace('this is interfaces.IE - false: ' + testResult.toString());
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
		trace();
		try {
			testObject = Sprite(this);
			trace('Sprite(this) - [object ...]: ' + testObject.toString());
		} catch (e:Error) 
		{
			trace("This shouldn't show!");
		}
		try {
			testObject = B(this);
			trace("This shouldn't show!");
		} catch (e:Error) 
		{
			trace('B(this) - exception expected: ' + e.message);
		}
		try {
			testObject = interfaces.IC(b);
			trace("This shouldn't show!");
		} catch (e:Error) 
		{
			trace('IC(b) - exception expected: ' + e.message);
		}
		try {
			testObject = interfaces.IF(b);
			trace('IF(b) - [object ...]: ' + testObject.toString());
		} catch (e:Error) 
		{
			trace("This shouldn't show!");
		}
	}
}
}