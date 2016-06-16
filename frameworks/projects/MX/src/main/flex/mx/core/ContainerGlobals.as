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

package mx.core
{

COMPILE::SWF
{
	import flash.display.InteractiveObject;	
}
COMPILE::JS
{
	import flex.display.InteractiveObject;	
}
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerContainer;

/**
*  @private
*/
public class ContainerGlobals
{
    /**
     *  @private
     *  Internal variable that keeps track of the container
     *  that currently has focus.
     */
    public static var focusedContainer:InteractiveObject;

    /**
     *  @private
     *  Support for defaultButton.
     */
    public static function checkFocus(oldObj:InteractiveObject,
                                           newObj:InteractiveObject):void
    {
        var objParent:InteractiveObject = newObj;
        var currObj:InteractiveObject = newObj;
        var lastUIComp:IUIComponent = null;

        if (newObj != null && oldObj == newObj)
            return;
        
        // Find the Container parent with a defaultButton defined.
        while (currObj)
        {
            if (currObj.parent)
            {
                objParent = currObj.parent;
            }
            else
            {
                objParent = null;
            }

            if (currObj is IUIComponent)
                lastUIComp = IUIComponent(currObj);

            currObj = objParent;

            if (currObj &&
                currObj is IFocusManagerContainer && IFocusManagerContainer(currObj).defaultButton)
            {
                break;
            }
        }

        if (ContainerGlobals.focusedContainer != currObj || 
            (ContainerGlobals.focusedContainer == null && currObj == null))
        {
            if (!currObj)
                currObj = InteractiveObject(lastUIComp);

            if (currObj && currObj is IFocusManagerContainer)
            {
                var fm:IFocusManager = IFocusManagerContainer(currObj).focusManager;
                if (!fm)
                    return;
                var defButton:IButton = IFocusManagerContainer(currObj).defaultButton as IButton;
                if (defButton)
                {
                    ContainerGlobals.focusedContainer = InteractiveObject(currObj);
                    fm.defaultButton = defButton as IButton;
                }
                else
                {
                    ContainerGlobals.focusedContainer = InteractiveObject(currObj);
                    fm.defaultButton = null;
                }
            }
        }
    }


}

}

