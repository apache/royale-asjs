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

import org.apache.flex.core.SimpleApplication;
import org.apache.flex.events.Event;

import classes.B;

import interfaces.IA;
import interfaces.IB;
import interfaces.IC;
import interfaces.ID;
import interfaces.IE;
import interfaces.IF;

public class LanguageTests extends SimpleApplication implements IA, IE
{
	public function LanguageTests()
	{
		var testResult:Boolean;
		var testObject:Object;
		
		var b:B = new B();
		
		testResult = this instanceof SimpleApplication;
		trace('this instanceof SimpleApplication - true: ' + testResult.toString());
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
		testResult = this is SimpleApplication;
		trace('this is SimpleApplication - true: ' + testResult.toString());
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
		testObject = (this as SimpleApplication) ? this as SimpleApplication : 'null';
		trace('this as SimpleApplication - [object ...]: ' + testObject.toString());
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
			testObject = SimpleApplication(this);
			trace('SimpleApplication(this) - [object ...]: ' + testObject.toString());
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
        
        addEventListener("foo", eventHandler);
        if (hasEventListener("foo"))
            trace("addEventListener worked");
        else
            trace("This shouldn't show!");
            
        removeEventListener("foo", eventHandler);
        if (!hasEventListener("foo"))
            trace("removeEventListener worked");
        else
            trace("This shouldn't show!");
	}
    
    public function eventHandler(e:Event):void
    {
        
    }
}
}