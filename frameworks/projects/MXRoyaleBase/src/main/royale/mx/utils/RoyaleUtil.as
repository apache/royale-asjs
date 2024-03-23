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
package mx.utils
{

import mx.core.IUIComponent;
import mx.core.IUIComponent;
import mx.core.IChildList;

COMPILE::SWF{

    import flash.utils.setTimeout;
}

/**
 *  The RoyaleUtil utility class is an all-static class
 *  with methods for emulation support
 *
 * @langversion 3.0
 * @playerversion Flash 10.2
 * @playerversion AIR 2.6
 * @productversion Royale 0.9.9
 *
 * @royalesuppressexport
 */
public class RoyaleUtil
{	

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    public static const DELAY:uint = 5;

    private static var timeOut:Number = -1;
    public static function commitDeferred(commitPropertiesFunc:Function):Boolean{
        if (deferreds.indexOf(commitPropertiesFunc) == -1) {
            deferreds.push(commitPropertiesFunc);
            if (timeOut == -1) {
                timeOut = setTimeout(onDeferral, 5);
            }
            return true;
        }
        return false;
    }

    /**
     * @royaleignorecoercion Function
     */
    private static function onDeferral():void{
        timeOut = -1;
        var local:Array = deferreds;
        deferreds = [];
        var l:uint = local.length;
        for (var i:uint = 0; i<l;i++) {
            var commitPropertiesFunc:Function = local[i];
            commitPropertiesFunc();
        }
    }

    private static var deferreds:Array = [];


    COMPILE::JS
    public static function childByName(parent:IChildList, name:String):IUIComponent{
        var i:uint = 0;
        var l:uint = parent.numChildren;
        for (;i<l;i++) {
            var child:IUIComponent = parent.getChildAt(i);
            if (child && child.name == name) return child;
        }
        return null;
    }


    COMPILE::JS
    public static function linkEventEnhancer(base:IUIComponent):void{

    }

   // COMPILE::JS
    //private static function onClickLinkCheck(event:Mou)



}

}
