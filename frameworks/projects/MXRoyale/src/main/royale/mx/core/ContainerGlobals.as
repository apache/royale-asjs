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

//import flash.display.InteractiveObject;
import mx.core.UIComponent;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerContainer;

import org.apache.royale.core.UIBase;

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
    public static var focusedContainer:IUIComponent;


    /**
     * @private
     * Support for defaultButton.
     */
    public static function checkFocus(oldObj:UIBase, newObj:UIBase):void{
        var objParent:UIBase = newObj;
        var currObj:UIBase = newObj;
        var lastUIComp:IUIComponent = null;

        //Find Container parent with a defaultButton defined
        while(currObj) {
            if (currObj.parent) {
                objParent = currObj.parent as UIBase;
            } else {
                objParent = null;
            }
            if (currObj is IUIComponent) lastUIComp = IUIComponent(currObj);

            currObj = objParent;
            //note the current below conditional deviates from the original Flex, @todo check/resolve:
            if (currObj && currObj is IFocusManagerContainer && IFocusManagerContainer(currObj).defaultButton) {
                break;
            }
        }
        var currIUIObj:IUIComponent = currObj as IUIComponent;
        if (focusedContainer != currIUIObj || (focusedContainer == null && currIUIObj == null)) {
            if (!currIUIObj)
                currIUIObj = lastUIComp;
            if (currIUIObj && currIUIObj is IFocusManagerContainer) {
                var fm:IFocusManager = IFocusManagerContainer(currIUIObj).focusManager;
                if (!fm) {
                  //  trace('cannot find focusmanager')
                    return;
                }

                var defaultBtn:IUIComponent = IFocusManagerContainer(currIUIObj).defaultButton as IUIComponent;
                focusedContainer = UIComponent(currIUIObj);
                if (defaultBtn) {
                    fm.defaultButton = defaultBtn;
                } else {
                    fm.defaultButton = null;
                }
            }
        }

    }

}
}

