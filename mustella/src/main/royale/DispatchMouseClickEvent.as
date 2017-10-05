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

COMPILE::SWF
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
}

/**
 *  The test step that fakes a mouse event
 *  MXML attributes:
 *  target
 *  type
 *  ctrlKey (optional)
 *  delta (optional)
 *  localX
 *  localY
 *  relatedObject (optional)
 *  shiftKey (optional)
 *  stageX
 *  stageY
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional);
 */
public class DispatchMouseClickEvent extends TestStep
{

	/**
	 *  @private
	 */
    COMPILE::SWF
	override public function execute(root:Object, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		if (waitEvent && waitTarget == null)
			waitTarget = target;
		return super.execute(root, context, testCase, testResult);
	}

	/**
	 *  Set the target's property to the specified value
	 */
    COMPILE::SWF
	override protected function doStep():void
	{
		UnitTester.blockFocusEvents = false;

		var actualTarget:Object = context.stringToObject(target);
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			UnitTester.blockFocusEvents = true;
			return;
		}
		dispatchMouseEvent(actualTarget, "mouseDown");
		dispatchMouseEvent(actualTarget, "mouseUp");
		dispatchMouseEvent(actualTarget, "click");

		UnitTester.blockFocusEvents = true;

	}

    COMPILE::SWF
	private function dispatchMouseEvent(actualTarget:Object, type:String):void
	{
		var event:MouseEvent = new MouseEvent(type, true); // all mouse events bubble
		event.ctrlKey = ctrlKey;
		event.shiftKey = shiftKey;
		event.buttonDown = type == "mouseDown";
		event.delta = delta;
		if (relatedObject && relatedObject.length > 0)
		{
			event.relatedObject = InteractiveObject(context.stringToObject(relatedObject));
		}
		
		var stagePt:Point;
		if (!isNaN(localX) && !isNaN(localY))
		{
			stagePt = actualTarget.localToGlobal(new Point(localX, localY));
		}
		else if (!isNaN(stageX) && !isNaN(stageY))
		{
			stagePt = new Point(stageX, stageY);
		}
		else
		{
			stagePt = actualTarget.localToGlobal(new Point(0, 0));
		}
        /* TODO (aharui) later
        try {
            root[mouseX] = stagePt.x;
            root[mouseY] = stagePt.y;
            UnitTester.setMouseXY(stagePt);
            if (root["topLevelSystemManager"] != root)
            {
                root["topLevelSystemManager"][mouseX] = stagePt.x;
                root["topLevelSystemManager"][mouseY] = stagePt.y;
            }            
        } catch (e:Error) {} // some scenarios don't support this
        */
        
		if (actualTarget is DisplayObjectContainer)
		{
			var targets:Array = actualTarget.stage.getObjectsUnderPoint(stagePt);
			var arr:Array = UnitTester.getObjectsUnderPoint(DisplayObject(actualTarget), stagePt);
			targets = targets.concat(arr);

			for (var i:int = targets.length - 1; i >= 0; i--)
			{
				if (targets[i] is InteractiveObject)
				{
					if (targets[i] is TextField && !targets[i].selectable)
					{
						actualTarget = targets[i].parent;
						break;
					}

					if (isMouseTarget(InteractiveObject(targets[i])))
					{
						actualTarget = targets[i];
						break;
					}
				}
/*				else
				{
					try
					{
						actualTarget = targets[i].parent;
						while (actualTarget)
						{
							if (actualTarget is InteractiveObject)
							{
								if (isMouseTarget(InteractiveObject(actualTarget)))
								{
									break;
								}
							}
							actualTarget = actualTarget.parent;
						}
						if (actualTarget && actualTarget != root)
							break;
					}
					catch (e:Error)
					{
						if (actualTarget)
							break;
					}
				}
*/			}
		}

		var localPt:Point = actualTarget.globalToLocal(stagePt);
		event.localX = localPt.x;
		event.localY = localPt.y;

		if (actualTarget is TextField)
		{
			if (type == "mouseDown")
			{
				var charIndex:int = actualTarget.getCharIndexAtPoint(event.localX, event.localY);
				actualTarget.setSelection(charIndex + 1, charIndex + 1);
			}
		}

		try
		{
			actualTarget.dispatchEvent(event);
		}
		catch (e2:Error)
		{
			TestOutput.logResult("Exception thrown in DispatchMouseClickEvent.");
			testResult.doFail (e2.getStackTrace());	
			return;
		}
	}

	/**
	 *  The object that receives the mouse event
	 */
	public var target:String;

	/**
	 *  The ctrlKey property on the MouseEvent (optional)
	 */
	public var ctrlKey:Boolean;

	/**
	 *  The delta property on the MouseEvent (optional)
	 */
	public var delta:int;

	/**
	 *  The localX property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public var localX:Number;

	/**
	 *  The localY property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public var localY:Number;

	/**
	 *  The stageX property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public var stageX:Number;

	/**
	 *  The stageY property on the MouseEvent (optional)
	 *  Either set stageX/stageY or localX/localY, but not both.
	 */
	public var stageY:Number;

	/**
	 *  The shiftKey property on the MouseEvent (optional)
	 */
	public var shiftKey:Boolean;

	/**
	 *  The relatedObject property on the MouseEvent (optional)
	 */
	public var relatedObject:String;

    COMPILE::SWF
    private function isMouseTarget(target:InteractiveObject):Boolean
    {
        if (!target.mouseEnabled)
            return false;

		// Examine parent chain for "mouseChildren" set to false:
		try
		{
			var parent:DisplayObjectContainer = target.parent;
			while (parent)
			{
				if (!parent.mouseChildren)
					return false;
				parent = parent.parent;
			}
		}
		catch (e1:Error)
		{
		}

        return true;
    }

	/**
	 *  customize string representation
	 */
    COMPILE::SWF
	override public function toString():String
	{
		var s:String = "DispatchMouseClickEvent: target = ";
		s += target;
		if (!isNaN(localX))
			s += ", localX = " + localX.toString();
		if (!isNaN(localY))
			s += ", localY = " + localY.toString();
		if (!isNaN(stageX))
			s += ", stageX = " + stageX.toString();
		if (!isNaN(stageY))
			s += ", stageY = " + stageY.toString();
		if (shiftKey)
			s += ", shiftKey = " + shiftKey.toString();
		if (ctrlKey)
			s += ", ctrlKey = " + ctrlKey.toString();
		if (relatedObject)
			s += ", relatedObject = " + relatedObject.toString();
		if (delta)
			s += ", delta = " + delta.toString();
		return s;
	}
}

}
