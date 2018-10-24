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
        
        public static function get objectID():String
        {
            COMPILE::SWF
            {
                return flash.external.ExternalInterface.objectID;
            }
            COMPILE::JS
            {
                trace("TODO: ExternalInterface.objectID");
                return "TODO: ExternalInterface.objectID";
            }
        }

        public static function addCallback(functionName:String, closure:Function):void
        {
            COMPILE::SWF
            {
                flash.external.ExternalInterface.addCallback(functionName, closure);
            }
            COMPILE::JS
            {
                trace("TODO: ExternalInterface.addCallback");
            }
        }
        
        public static function call(functionName:String, ... arguments):*
        {
            COMPILE::SWF
            {
                arguments.unshift(functionName);
                return flash.external.ExternalInterface.call.apply(null, arguments);
            }
            COMPILE::JS
            {
                trace("TODO: ExternalInterface.call");
                return null;
            }
        }
        
    }
}

