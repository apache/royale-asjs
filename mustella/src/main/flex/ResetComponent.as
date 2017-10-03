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
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.KeyboardEvent;
import flash.events.FocusEvent;
import flash.net.LocalConnection;
import flash.system.ApplicationDomain;
import flash.system.Capabilities;
import flash.system.System;
import flash.ui.Keyboard;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  The test step that fakes a keyboard event
 *  MXML attributes:
 *  target 
 *  className
 *  waitTarget
 *  waitEvent
 *  timeout
 */
public class ResetComponent extends TestStep
{
    private static var effectsInEffect:QName = new QName(mx_internal, "effectsInEffect");
    private static var activeTweens:QName = new QName(mx_internal, "activeTweens");
    private static var tooltipReset:QName = new QName(mx_internal, "reset");

    private var actualWaitEvent:String;

    private var waited:Boolean = false;

    /**
     *  Called by the TestCase when it is time to start this step
     *  fake waitEvent because we don't want to listen to the old one
     */
    override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
    {
        if (waitTarget == null)
            waitTarget = target;

        // let super think there is no waitEvent
        if (waitEvent && waitTarget == target)
        {
            actualWaitEvent = waitEvent;
            waitEvent = null;
        }
        var val:Boolean = super.execute(root, context, testCase, testResult);
        if (actualWaitEvent && !waited)
        {
            var actualTarget:Object = context.stringToObject(waitTarget);
            if (!actualTarget)
            {
                testResult.doFail("Target " + waitTarget + " not found");
                return true;
            }
            waitEvent = actualWaitEvent;
            actualTarget.addEventListener(actualWaitEvent, waitEventHandler);
            testCase.setExpirationTime(getTimer() + timeout);
        }
        return (actualWaitEvent || waited) ? false : val;
    }

    /**
     *  Set the target's property to the specified value
     */
    override protected function doStep():void
    {
        var effects:Boolean = false;

        var appDom:ApplicationDomain = root["topLevelSystemManager"]["info"]().currentDomain;
        if (!appDom)
            appDom = ApplicationDomain.currentDomain;
        
        var effectMgr:Class = Class(appDom.getDefinition("mx.effects.EffectManager"));

        if (effectMgr)
        {
            effects = effectMgr[effectsInEffect]();
        }
        if (!effects)
        {
            effectMgr = Class(appDom.getDefinition("mx.effects.Tween"));
            if (effectMgr)
            {
                effects = effectMgr[activeTweens].length > 0;
            }
        }
        if (!effects)
            effects = UnitTester.getSandboxedEffects();

        if (!effects)
        {
            actuallyDoStep(waited);
            waited = false;
        }
        else
        {
            UnitTester.callback = doStep;
            waited = true;
        }
    }

    private function actuallyDoStep(addListener:Boolean):void
    {
        
        var actualTarget:Object = context.stringToObject(target);
        if (!actualTarget)
        {
            testResult.doFail("Target " + target + " not found");
            return;
        }
        
        // Introspect target type.
        var targetType:TypeInfo = context.getTypeInfo(actualTarget);
        var targetIsGraphic:Boolean = targetType.implementsInterface("spark.core::IGraphicElement");
        
        // Save id to apply later.
        if (actualTarget is DisplayObject)
        {
            var id:String = actualTarget.id;
        }
        
        try
        {
           // Save parent context.
           if (actualTarget is DisplayObject || targetIsGraphic)
           {
                var parent:Object = actualTarget.parent;
            
                if (!parent)
                {
                    testResult.doFail("Target " + target + " not parented");
                    return;
                }
            }
        }
        catch (se:SecurityError)
        {
            UnitTester.resetSandboxedComponent(target, className);
            return;
        }

        // Garbage collect.
        attemptGC();
        
        // Introspect parent type.
        if (parent)
        {
            var parentType:TypeInfo = context.getTypeInfo(parent);
            var parentIsGroup:Boolean = parentType.isAssignableTo("spark.components::Group");
        }
        
        // Ensure parent of graphic primitive is a Group.
        if (targetIsGraphic && !parentIsGroup)
        {
            testResult.doFail("Graphic primitive " + target + " not parented by a Group.");
            return;
        }
            
        // Infer className is none provided.
        className = className != null ? className : targetType.className;
        
        var targetClass:Class;
        var child:Object;
        var appdom:ApplicationDomain = UnitTester.getApplicationDomain(target, actualTarget, className);
        if (!appdom)
        {
            UnitTester.resetSandboxedComponent(target, className);
            return;
        }
        
        if (actualTarget is DisplayObject || targetIsGraphic)
        {
            // Remove original instance
            if (parentIsGroup)
            {
                var index:int = parent.getElementIndex(actualTarget);
                parent.removeElement(actualTarget);
            }
            else
            {
                index = parent.getChildIndex(actualTarget);
                parent.removeChild(actualTarget);
            }
            
            // Cleanup any related or housekeeping objects.
            cleanupOtherDisplayObjects();
            
            // Lookup requested type for new instance.
            targetClass = Class(appdom.getDefinition(className));
            if (!targetClass)
            {
                testResult.doFail("className " + className + " is not a valid class");
                return;
            }

            // Create new instance.
            child = new targetClass();
            var childType:TypeInfo = context.getTypeInfo(child);
            if (!(child is DisplayObject) && !childType.implementsInterface("spark.core::IGraphicElement"))
            {
                testResult.doFail("className " + className + " is not a DisplayObject or GraphicElement primitive.");
                return;
            }
            
            // Re-add new instance to visual DOM.
            if (parentIsGroup)
                parent.addElementAt(child, index);
            else
                parent.addChildAt(child as DisplayObject, index);   
        }
        else
        {
            // Fallback for non-DOM component instances.
            targetClass = Class(appdom.getDefinition(className));
            if (!targetClass)
            {
                testResult.doFail("className " + className + " is not a valid class");
                return;
            }

            child = new targetClass();
        }

        // Update top level document slots with reference to new instance.
        var obj:Object;
        var varName:String;
        if (target.indexOf(".") == -1)
        {
            if (target.indexOf("script:") == 0)
            {
                obj = context;
                varName = target.substring(7);
            }
            else
            {
                obj = root["document"];
                varName = target;
            }
        }
        else
        {
            var path:String = target.substring(0, target.lastIndexOf("."));
            obj = context.stringToObject(path);
            varName = target.substring(target.lastIndexOf(".") + 1);
        }
        if (!obj)
        {
            testResult.doFail("path " + path + " is not valid");
            return;
        }
        if (!(varName in obj))
        {
            testResult.doFail("property " + varName + " is not valid");
            return;
        }

        if (actualTarget is DisplayObject)
            if (id && child)
                Object(child).id = id;

        try 
        {
            obj[varName] = child;
        }
        catch (e1:Error)
        {
            TestOutput.logResult("Exception thrown setting path to new class instance.");
            testResult.doFail (e1.getStackTrace()); 
        }

        // Initiate wait if requested, otherwise complete step.
        if (actualWaitEvent && addListener)
        {
            actualTarget = context.stringToObject(waitTarget);
            if (!actualTarget)
            {
                testResult.doFail("Target " + waitTarget + " not found");
                stepComplete();
                return;
            }
            waitEvent = actualWaitEvent;
            actualTarget.addEventListener(actualWaitEvent, waitEventHandler);
            testCase.setExpirationTime(getTimer() + timeout);
        }
        else if (addListener)
        {
            stepComplete();
        }
    
    }

    private function cleanupOtherDisplayObjects():void
    {
        var r:Object;
        var i:int;
        var n:int;
        var c:Object;

        var appDom:ApplicationDomain = root["info"]().currentDomain;
        if (!appDom)
            appDom = ApplicationDomain.currentDomain;

        r = root;
        r = root["topLevelSystemManager"];

        UnitTester.blockFocusEvents = false;
        r.stage.focus = null;
        UnitTester.blockFocusEvents = true;

        n = r.numChildren;
        for (i = 0; i < n; i++)
        {
            if (context.knownDisplayObjects[r.getChildAt(i)] == null)
            {
                c = r.getChildAt(i);
                if (getQualifiedClassName(c) == "mx.managers::SystemManagerProxy")
                {
                    while (c.rawChildren.numChildren)
                    c.rawChildren.removeChildAt(c.rawChildren.numChildren - 1);
                }
                else
                    r.removeChildAt(i);
                i--;
                n--;
            }
        }

        r = root;
        r = root["topLevelSystemManager"];
        r = r.popUpChildren;
        n = r.numChildren;
        for (i = 0; i < n; i++)
        {
            if (context.knownDisplayObjects[r.getChildAt(i)] == null)
            {
                c = r.getChildAt(i);
                if (getQualifiedClassName(c) == "mx.managers::SystemManagerProxy")
                {
                    while (c.rawChildren.numChildren)
                        c.rawChildren.removeChildAt(c.rawChildren.numChildren - 1);
                }
                else
                    r.removeChildAt(i);

                i--;
                n--;
            }
        }

        r = root;
        r = root["topLevelSystemManager"];
        r = r.toolTipChildren;
        n = r.numChildren;
        if (n > 0)
        {
            var mgr:Class = Class(appDom.getDefinition("mx.core.Singleton"));
            var impl:Object = mgr["getInstance"]("mx.managers::IToolTipManager2");
            try
            {
                impl[tooltipReset]();
            }
            catch (e:Error)
            {
                // ignore, chart datatips don't setup tooltipmanager so reset will RTE.
            }
        }
        n = r.numChildren;
        for (i = 0; i < n; i++)
        {
            if (context.knownDisplayObjects[r.getChildAt(i)] == null)
            {
                r.removeChildAt(i);
                i--;
                n--;
            }
        }

        r = root;
        r = root["topLevelSystemManager"];
        r = r.cursorChildren;
        n = r.numChildren;
        if (n > 0)
        {
            var cmgr:Class = Class(appDom.getDefinition("mx.core.Singleton"));
            var cimpl:Object = cmgr["getInstance"]("mx.managers::ICursorManager");
            cimpl["removeAllCursors"]();
        }
        n = r.numChildren;
        for (i = 0; i < n; i++)
        {
            var o:DisplayObject = r.getChildAt(i);
            if (context.knownDisplayObjects[o] == null)
            {
                if (o.name == "cursorHolder")
                    continue;

                r.removeChildAt(i);
                i--;
                n--;
            }
        }

    }

    private function attemptGC():void
    {
		if (Capabilities.isDebugger)
		{
			System.gc();
			return;
		}
        // unsupported hack that seems to force a full GC
        try 
        {
            var lc1:LocalConnection = new LocalConnection();
            var lc2:LocalConnection = new LocalConnection();

            lc1.connect('name');
            lc2.connect('name');
        }
        catch (e:Error)
        {
        }
    }

    /**
     *  The type of the event to send (keyUp, keyDown, etc).
     *  If not set, we'll send both a keyDown and a keyUp
     */
    public var target:String;

    /**
     *  The char to send as a string/char if you don't know the charCode (optional)
     */
    public var className:String;

    /**
     *  customize string representation
     */
    override public function toString():String
    {
        var s:String = "ResetComponent";
        if (target)
            s += ": target = " + target;
        if (className)
            s += ", className = " + className;
        return s;
    }
}

}
