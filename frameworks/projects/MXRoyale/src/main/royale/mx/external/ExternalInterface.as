/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package mx.external
{
	COMPILE::SWF
	{
		import flash.external.ExternalInterface;
	}
	/**
	 * The ExternalInterface class provides a mechanism for a Royale application to communicate with other JavaScript functionality present within the web page.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * @playerversion AIR 1.0
	 * @productversion Royale 0.9
     * 
     *  @royalesuppresspublicvarwarning
	 */
    public final class ExternalInterface
    {

        /**
         * Indicates whether this player is in a container that offers an external interface.
         * If the external interface is available, this property is true; otherwise, it is false.
         */
        public static function get available():Boolean
        {
            COMPILE::SWF
            {
                return flash.external.ExternalInterface.available;
            }
            COMPILE::JS
            {
                return true;
            }
        }
        
        /**
         * Indicates whether the external interface should attempt to pass ActionScript exceptions
         * to the current browser and JavaScript exceptions to the player.
         * When running as a SWF: default is false. You must explicitly set this property to true
         * to catch JavaScript exceptions in ActionScript and to catch ActionScript exceptions in JavaScript.
         * When running as HTML, this is always true and cannot be changed.
         */
        public static function get marshallExceptions():Boolean
        {
            COMPILE::SWF
            {
                return flash.external.ExternalInterface.marshallExceptions;
            }
            COMPILE::JS
            {
                return true;
            }
        }
        /**
         * @private
         */
        public static function set marshallExceptions(val:Boolean):void
        {
            COMPILE::SWF
            {
                flash.external.ExternalInterface.marshallExceptions = val;
            }
            COMPILE::JS
            {
                if (!val) trace("WARNING: trying to set ExternalInterface.marshallExceptions to false; not supported in Royale");
            }
        }
        
        /**
         * @private
         * If we're using an HTML element to hang our callbacks off,
         * the ID of this can be adjusted via this attribute
         */
         COMPILE::JS
         private static var _objectID : String = "ExternalInterface";
        
        /** Returns the id attribute of the Flash Player object if running as a SWF,
         *  or of the HTML element that is used for hooking up callback objects if
         *  running in HTML (default then is <code>ExternalInterface</code>).
         *  Read-only in SWF mode; read-write in JS mode. This needs to be set prior
         *  to any calls to <code>addCallback</code>.
         */
        public static function get objectID():String
        {
            COMPILE::SWF
            {
                return flash.external.ExternalInterface.objectID;
            }
            COMPILE::JS
            {
                return _objectID;
            }
        }
        
        COMPILE::JS
        public static function set objectID(value:String):void
        {
            _objectID = value;
        }

        /** Registers an ActionScript method as callable from the container.
         *  After a successful invocation of addCallBack(), the registered
         *  function in the player can be called by JavaScript.
         *
         *  The JavaScript needs to obtain the appopriate element (set via <code>objectID</code>
         *  and then call the function as a property of this element. For example
         *  if <code>addCallback</code> has been called with <code>functionName>/code>
         *  set to "myFunction", the call can be made by:
         *  <code>document.getElementById("ExternalInterface").myFunction(args);</code>
         *
         * @param functionName The name by which the browser can invoke the function.
         * @param closure The function closure to invoke.
         * 
         * @royaleignorecoercion HTMLElement
         */
        public static function addCallback(functionName:String, closure:Function):void
        {
            COMPILE::SWF
            {
                flash.external.ExternalInterface.addCallback(functionName, closure);
            }
            COMPILE::JS
            {
                // use a simple script object to hang our callback properties off..
                var extInt:HTMLElement = document.getElementById(_objectID) as HTMLElement;
                if (!extInt)
                {
                    extInt = document.createElement("script") as HTMLElement;
                    extInt.id = _objectID;
                    document.body.appendChild(extInt);
                }
                extInt[functionName] = closure;
            }
        }
        
        /** Calls a function exposed by the browser, passing zero or more arguments.
         *  If the function is not available, the call returns <code>null</code>,
         *  otherwise it returns the value provided by the function.
         *
         * @param functionName The name of the JavaScript function to call.
         * @param ... args The arguments to pass to the JavaScript function in the browser.
         */
        public static function call(functionName:String, ... args):*
        {
            COMPILE::SWF
            {
                args.unshift(functionName);
                return flash.external.ExternalInterface.call.apply(null, args);
            }
            COMPILE::JS
            {
                // find a function with the name...
                var fnc : Function;
                if (functionName) {
                    var base:Object = window;
                    var dotIdx:int = functionName.indexOf('.');
                    if (dotIdx != -1) {
                        while(dotIdx != -1) {
                            base = base[functionName.substr(0, dotIdx)];
                            functionName = functionName.substr(dotIdx + 1);
                            dotIdx = functionName.indexOf('.');
                        }
                    }
                    fnc = base[functionName];
                }

                if (fnc)
                {
                    return fnc.apply(null, args);
                }
                return null;
            }
        }
        
    }
}

