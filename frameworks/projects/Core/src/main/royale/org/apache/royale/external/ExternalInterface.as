package org.apache.royale.external
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
    public class ExternalInterface
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
        
        /** Returns the id attribute of the Flash Player object if running as a SWF,
         *  or <code>"ExternalInterface"</code> if running in HTML.
         */
        public static function get objectID():String
        {
            COMPILE::SWF
            {
                return flash.external.ExternalInterface.objectID;
            }
            COMPILE::JS
            {
                return "ExternalInterface";
            }
        }

        /** Registers an ActionScript method as callable from the container.
         *  After a successful invocation of addCallBack(), the registered
         *  function in the player can be called by JavaScript.
         *
         *  The JavaScript needs to obtain the ExternalInterface element and
         *  then call the function as a property of this element. For example
         *  if <code>addCallback</code> has been called with <code>functionName>/code>
         *  set to "myFunction", the call can be made by:
         *  <code>document.getElementById("ExternalInterface").myFunction(args);</code>
         *
         * @param functionName The name by which the browser can invoke the function.
         * @param closure The function closure to invoke.
         */
        public static function addCallback(functionName:String, closure:Function):void
        {
            COMPILE::SWF
            {
                flash.external.ExternalInterface.addCallback(functionName, closure);
            }
            COMPILE::JS
            {
                // use a special div object to hang our callback properties off..
                var extInt = document.getElementById("ExternalInterface");
                if (!extInt)
                {
                    extInt = document.createElement("DIV");
                    extInt.id = "ExternalInterface";
                    extInt.style.display = "none";
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
                var fnc : Function = window[functionName];
                if (fnc)
                {
                    return fnc.apply(null, args);
                }
                return null;
            }
        }
        
    }
}

