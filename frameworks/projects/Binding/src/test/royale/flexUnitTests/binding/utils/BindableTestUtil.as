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
package flexUnitTests.binding.utils {
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.ValueChangeEvent;
import org.apache.royale.reflection.getQualifiedClassName;

public class BindableTestUtil {
    
    public static var deactivated:Boolean;

    private static var _unlocked:Boolean;
    private static var _instance:BindableTestUtil;
    public static function get instance():BindableTestUtil{
        if (!_instance) {
            _unlocked = true;
            _instance = new BindableTestUtil();
            _unlocked = false;
        }
        return _instance;
    }

    private var _history:Array= [];


    public function BindableTestUtil() {
        if (!_unlocked) throw new Error("Singleton only, access view BindableTestUtil.instance");
    }


    public function reset():void{
        _history= [];
        for (var eventType:String in listening) {
            var arr:Array = listening[eventType];
            for (var i:int=0; i<arr.length; i++) {
                var dispatcher:IEventDispatcher = arr[i];
                dispatcher.removeEventListener(eventType, addEventItem);
            }
        }
        listening = {};
    }

    public function getContents():Array{
        return _history.slice();
    }

    public function getSequenceString():String{
        var temp:Array = _history.slice();
        temp = temp.map(function(val:*, index:int, arr:Array):*{
            return index + ":" + val;
        });
        return temp.join("\n");
    }

    public function addHistoryItem(...rest):void{
        if (deactivated) return;
        var contents:Array = rest;
        contents = contents.map(
                function(value:*, index:int, arr:Array):*{
                    if (value === null) return 'null';
                    if (value === undefined) return 'undefined';
                    return (value.toString());
                }
        );
        _history.push("history:" + contents.join(' , '));
    }

    public function addStacktrace():void{
        if (deactivated) return;
        var stack:String;
        COMPILE::SWF{
            stack = new Error().getStackTrace();

        }
        COMPILE::JS{
            stack = new Error().stack;
        }
        //remove the first line
        var contents:Array = stack.split('\n').slice(1);
        contents[0] = "Execution stack: [";
        contents.push("]");
        _history.push(contents.join('\n'));
    }

    public function addEventItem(event:Event):void{
        if (deactivated) return;
        if (event is ValueChangeEvent) {
            var vce:ValueChangeEvent = ValueChangeEvent(event);
            _history.push('ValueChangeEvent::property('+ vce.propertyName+'), oldVal:('+ vce.oldValue+ "), newValue:("+ vce.newValue+")");
        } else {

            _history.push(getQualifiedClassName(event)+'(type="'+event.type+'", bubbles='+event.bubbles+', cancelable='+event.cancelable+')');
        }
    }
    
    private var listening:Object  = {};
    public function listenTo(object:Object, eventType:String):void{
        if (object is IEventDispatcher) {
            IEventDispatcher(object).addEventListener(eventType,addEventItem);
            var listeners:Array = listening[eventType] || (listening[eventType] = []);
            listeners.push(object);
        } else {
            throw new Error("Cannot listen to a non-IEventDispatcher");
        }
    }

    public function unListenTo(object:Object, eventType:String):void{
        if (object is IEventDispatcher) {
            IEventDispatcher(object).removeEventListener(eventType,addEventItem);
            var listeners:Array = listening[eventType] || (listening[eventType] = []);
            var idx:int = listeners.indexOf(object);
            if (idx != -1) {
                listeners.splice(idx,1);
            }
        } else {
            throw new Error("Cannot unListen to a non-IEventDispatcher");
        }
    }
    
}
}
