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
package {

import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.events.EventDispatcher;
import flash.utils.*;
import flash.net.*;
import flash.events.*;
import flash.display.*;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.core.mx_internal;
use namespace mx_internal;

/**
*  Vector of conditionalValue objects.
**/
[DefaultProperty("conditionalValues")]

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="valueExpression", type="flash.events.Event")]

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  target
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertPixelValue extends Assert
{
	public var conditionalValues:Vector.<ConditionalValue> = null;

    /**
     *  Test the value of a pixel, log result if failure.
     */
    override protected function doStep():void
    {
		var cv:ConditionalValue = null;
		var dispatcher:EventDispatcher = this;
        var pt:Point = new Point(x, y);
        var actualTarget:Object = context.stringToObject(target);
        if (!actualTarget)
        {
            testResult.doFail("Target " + target + " not found");
            return;
        }

		// Use MultiResult to determine the proper value (or valueExpression, below).
		if(conditionalValues){
			cv = new MultiResult().chooseCV(conditionalValues);
			if(cv){
				value = uint(cv.value);
				dispatcher = cv;
			}
		}

        var stagePt:Point = actualTarget.localToGlobal(new Point(0, 0));
        var altPt:Point = actualTarget.localToGlobal(new Point(actualTarget.width, actualTarget.height));
        stagePt.x = Math.min(stagePt.x, altPt.x);
        stagePt.y = Math.min(stagePt.y, altPt.y);
        var screenBits:BitmapData = new BitmapData(actualTarget.width, actualTarget.height);
        try
        {
            screenBits.draw(root.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
        }
        catch(se2:SecurityError)
        {
            screenBits.draw(root, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
        }
        
		if (dispatcher.hasEventListener("valueExpression"))
        {
            context.resetValue();
            try
            {
	           	dispatcher.dispatchEvent(new RunCodeEvent("valueExpression", root["document"], context, testCase, testResult));
            }
            catch (e1:Error)
            {
                TestOutput.logResult("Exception thrown evaluating value expression.");
                testResult.doFail (e1.getStackTrace()); 
                return;
            }
            value = uint(context.value);
            if (!context.valueChanged)
                TestOutput.logResult("WARNING: value was not set by valueExpression.  'value=' missing from expression?");
        }

        if (screenBits.getPixel(pt.x, pt.y) != value)
        {
            testResult.doFail ( target + " pixel at (" + x + "," + y + ") " + 
                screenBits.getPixel(pt.x, pt.y).toString(16).toUpperCase() + " != 0x" + value.toString(16).toUpperCase());
        } 
    }

    /**
     *  The color value the property should have
     */
    public var value:uint;

    /**
     *  The x offset into the component
     */
    public var x:Number;

    /**
     *  The y offset into the component
     */
    public var y:Number;

    /**
     *  customize string representation
     */
    override public function toString():String
    {
        var s:String = "AssertPixelValue";
        if (target)
            s += ": target = " + target;
        s += ", x = " + x;
        s += ", y = " + y;
        return s;
    }
}

}
