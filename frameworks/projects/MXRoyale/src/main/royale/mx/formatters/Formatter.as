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

package mx.formatters
{

import mx.formatters.IFormatter;
import mx.core.mx_internal;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
//import mx.resources.IResourceManager;
//import mx.resources.ResourceManager;

use namespace mx_internal;

// [ResourceBundle("formatters")]

/**
 *  The Formatter class is the base class for all data formatters.
 *  Any subclass of Formatter must override the <code>format()</code> method.
 *
 *  @mxml
 *
 *  <p>The Formatter class defines the following tag attributes,
 *  which all of its subclasses inherit:</p>
 *  
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    <b>Properties</b>
 *    error=""
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/SimpleFormatterExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Formatter implements IFormatter 
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	//private static var initialized:Boolean = false;

	/**
	 *  @private
	 *  Storage for the resourceManager getter.
	 *  This gets initialized on first access,
	 *  not at static initialization time, in order to ensure
	 *  that the Singleton registry has already been initialized.
	 */
	//private static var _static_resourceManager:IResourceManager;
	
	/**
	 *  @private
     *  A reference to the object which manages
     *  all of the application's localized resources.
     *  This is a singleton instance which implements
     *  the IResourceManager interface.
	 */
	/* private static function get static_resourceManager():IResourceManager
	{
		 if (!_static_resourceManager)
			_static_resourceManager = ResourceManager.getInstance(); 

		return _static_resourceManager; 
	} */
	
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
		
	//----------------------------------
	//  defaultInvalidFormatError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the defaultInvalidFormatError property.
	 */
	private static var _defaultInvalidFormatError:String
	
    /**
	 *  @private
	 */
	private static var defaultInvalidFormatErrorOverride:String

	/**
	 *  Error message for an invalid format string specified to the formatter.
	 *  The localeChain property of the ResourceManager is used to resolve
	 *  the default error message. If it is unable to find a value, it will
	 *  return <code>null</code>. This can happen if none of the locales
	 *  specified in the localeChain are compiled into the application.
	 * 
	 *  @default "Invalid format"
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function get defaultInvalidFormatError():String
	{
		// initialize();

		return _defaultInvalidFormatError; 
	}

	/**
	 *  @private
	 */
	public static function set defaultInvalidFormatError(value:String):void
	{
		defaultInvalidFormatErrorOverride = value;
		
		 _defaultInvalidFormatError = 
			value != null ?
			value : "Invalid format";
			// static_resourceManager.getString(
			// 	"formatters", "defaultInvalidFormatError"); 
	}

	//----------------------------------
	//  defaultInvalidValueError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the defaultInvalidValueError property.
	 */
	private static var _defaultInvalidValueError:String
	
    /**
	 *  @private
	 */
	private static var defaultInvalidValueErrorOverride:String

	/**
	 *  Error messages for an invalid value specified to the formatter. The
	 *  localeChain property of the ResourceManager is used to resolve the
	 *  default error message. If it is unable to find a value, it will return
	 *  <code>null</code>. This can happen if none of the locales specified in
	 *  the localeChain are compiled into the application.
	 * 
	 *  @default "Invalid value"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function get defaultInvalidValueError():String
	{
		// initialize();

		return _defaultInvalidValueError; 
	}

	/**
	 *  @private
	 */
	public static function set defaultInvalidValueError(value:String):void
	{
		defaultInvalidValueErrorOverride = value;

		 _defaultInvalidValueError =
			value != null ?
			value : "Invalid value";
			// static_resourceManager.getString(
			// 	"formatters", "defaultInvalidValueError"); 
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

    /**
	 *  @private    
     */
	/* private static function initialize():void
	{
		 if (!initialized)
		{ */ 
			// Register as a weak listener for "change" events
			// from ResourceManager.
			/* static_resourceManager.addEventListener(
				Event.CHANGE, static_resourceManager_changeHandler,
				false, 0, true);

			static_resourcesChanged();

			initialized = true;
		} 
	} */

    /**
	 *  @private    
     */
	/* private static function static_resourcesChanged():void
	{
		 defaultInvalidFormatError = defaultInvalidFormatErrorOverride;
		defaultInvalidValueError = defaultInvalidValueErrorOverride; 
	} */

	//--------------------------------------------------------------------------
	//
	//  Class event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	/* private static function static_resourceManager_changeHandler(
								event:Event):void
	{
		static_resourcesChanged();
	} */

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function Formatter()
	{
		super();

		// Register as a weak listener for "change" events from ResourceManager.
		// If Formatters registered as a strong listener,
		// they wouldn't get garbage collected.
		/* resourceManager.addEventListener(
			Event.CHANGE, resourceManager_changeHandler, false, 0, true);

		resourcesChanged(); */
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  error
	//----------------------------------

   // [Inspectable(category="General", defaultValue="null")]

	/**
	 *  Description saved by the formatter when an error occurs.
	 *  For the possible values of this property,
	 *  see the description of each formatter.
	 *  <p>Subclasses must set this value
	 *  in the <code>format()</code> method.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public var error:String;

    //----------------------------------
    //  resourceManager
    //----------------------------------
    
    /**
	 *  @private
	 *  Storage for the resourceManager property.
	 */
	//private var _resourceManager:IResourceManager = ResourceManager.getInstance();
    
	/**
	 *  @private
	 *  This metadata suppresses a trace() in PropertyWatcher:
	 *  "warning: unable to bind to property 'resourceManager' ..."
	 */
	//[Bindable("unused")]
	
	/**
	 *  @copy mx.core.UIComponent#resourceManager
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	/* protected function get resourceManager():IResourceManager
    {
    	return _resourceManager;
    }
     */
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  This method is called when a Formatter is constructed,
	 *  and again whenever the ResourceManager dispatches
	 *  a <code>"change"</code> Event to indicate
	 *  that the localized resources have changed in some way.
	 * 
	 *  <p>This event will be dispatched when you set the ResourceManager's
	 *  <code>localeChain</code> property, when a resource module
	 *  has finished loading, and when you call the ResourceManager's
	 *  <code>update()</code> method.</p>
	 *
	 *  <p>Subclasses should override this method and, after calling
	 *  <code>super.resourcesChanged()</code>, do whatever is appropriate
	 *  in response to having new resource values.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	/* protected function resourcesChanged():void
	{
	} */

	/**
	 *  Formats a value and returns a String
	 *  containing the new, formatted, value.
	 *  All subclasses must override this method to implement the formatter.
	 *
	 *  @param value Value to be formatted.
	 *
	 *  @return The formatted string.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function format(value:Object):String
	{
		/* error = "This format function is abstract. " +
			    "Subclasses must override it."; */

	    return "";
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	/* private function resourceManager_changeHandler(event:Event):void
	{
		resourcesChanged();
	} */
}

}
