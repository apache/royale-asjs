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

package mx.globalization.supportClasses
{

import mx.errors.IllegalOperationError;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;

import mx.core.FlexGlobals;
import mx.core.mx_internal;
//import mx.styles.AdvancedStyleClient;

import mx.globalization.LastOperationStatus;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  The change event is generated whenever the <code>locale</code> style is changed or
 *  another property is set that would cause
 *  the format of a number to change or cause updates to the other
 *  values available through this class.
 *
 *  @eventType flash.events.Event.CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.8
 */
//[Event(name="change", type="flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The locale identifier that specifies the language, region, script
 *  and optionally other related tags and keys.
 *  The syntax of this identifier must follow the syntax defined
 *  by the Unicode Technical Standard #35 (e.g. en-US, de-DE, zh-Hans-CN)
 * 
 *  @see http://www.unicode.org/reports/tr35/
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.8
 */
[Style(name="locale", type="String", inherit="yes")]

/**
 *  This is a base class used for wrapper classes that make use of the
 *  flash.globalization classes for language and region specific formatting
 *  of dates, times, number, and currency amounts, string comparison and
 *  case conversion.
 *
 *  @see spark.formatters.CurrencyFormatter
 *  @see spark.formatters.DateTimeFormatter
 *  @see spark.formatters.NumberFormatter
 *  @see mx.globalization.MatchingCollator
 *  @see mx.globalization.SortingCollator
 *  @see mx.globalization.StringTools
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.8
 */
public class GlobalizationBase /*extends AdvancedStyleClient*/
{
    //include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function GlobalizationBase()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Basic properties of underlying flash.globalization class instance.
     *
     *  Stores basic properties of underlying class's properties that can be
     *  simply copied into a new instance.
     */
    private var basicProperties:Object = null;
    
    /**
     *  @private
     *  Properties object to be used by higher level class ONLY.
     *
     *  Store overriden properties.
     */
    mx_internal var properties:Object = null;

    /**
     *  @private
     *  Cache for "locale" style.
     *
     *  The code needs be able to find out if the locale style has been changed
     *  from earlier.
     */
    mx_internal var localeStyle:* = undefined;

    /**
     *  @private
     *  lastOperationStatus for the fallback class.
     *
     *  In case workingInstance is not null, this value will be used as the
     *  official value of get lastOperationStatus().
     */
    mx_internal var fallbackLastOperationStatus:String
                                                = LastOperationStatus.NO_ERROR;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  actualLocaleIDName
    //----------------------------------

    [Bindable("change")]

    /**
     *  The name of the actual locale ID used by this class object.
     *
     *  This is the locale that is used to access the formatting data and
     *  functionality from the operating system.
     *
     *  <p>If the locale that was set by the <code>locale</code> style is not available,
     *  then the value of the <code>actualLocaleIDName</code> is different
     *  from the value of the <code>locale</code> style.
     *  It indicates the fallback locale that is being used.
     *  If the locale style was set to <code>LocaleID.DEFAULT</code> the
     *  name of the locale specified by the user's operating system is 
     *  used.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get actualLocaleIDName():String
    {
        // This method must be overridden by the inherited class.
        throw new IllegalOperationError();

        return null;
    }

    //----------------------------------
    //  enforceFallback
    //----------------------------------

    private var _enforceFallback:Boolean = false;

    /**
     *  @private
     *  Enforces to use the fallback class internally even when
     *  flash.globalization class is available.
     */
    mx_internal function get enforceFallback():Boolean
    {
        return _enforceFallback;
    }

    /**
     *  @private
     */
    mx_internal function set enforceFallback(value:Boolean):void
    {
        if (_enforceFallback == value)
            return;

        _enforceFallback = value;

        if (localeStyle == null)
            return;

        createWorkingInstance();

        update();
    }

    //----------------------------------
    //  lastOperationStatus
    //----------------------------------

    [Bindable("change")]

    /**
     *  The status of the most recent operation that this class object
     *  performed.
     *
     *  The <code>lastOperationStatus</code> is set whenever the constructor
     *  or a method of this class is called, or when a property is set.
     *  For the possible values see the description under each method.
     *
     * @see flash.globalization.LastOperationStatus
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    public function get lastOperationStatus():String
    {
        // This method must be overridden by the inherited class.
        throw new IllegalOperationError();

        return null;
    }

    //----------------------------------
    //  useFallback
    //----------------------------------

    [Bindable("change")]

    /**
     *  @private
     *  Flag to indicate if a fallback class (true) or flash.globalization
     *  class (false) is used.
     */
    mx_internal function get useFallback():Boolean
    {
        // This method must be overridden by the inherited class.
        throw new IllegalOperationError();

        return false;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy mx.core.UIComponent#getStyle()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    /* override public function getStyle(styleProp:String):*
    {
        if (styleProp != "locale")
            return super.getStyle(styleProp);

        if ((localeStyle !== undefined) && (localeStyle !== null))
            return localeStyle;

        if (styleParent)
            return styleParent.getStyle(styleProp);

        if (FlexGlobals.topLevelApplication)
            return FlexGlobals.topLevelApplication.getStyle(styleProp);

        return undefined;
    } */

    /**
     *  @private
     *  Intercept style change for "locale".
     *
     *  In the case that there is no associated UI component or the
     *  module factory of the UIComponent has not yet been intialized
     *  style changes are only recorded but the styleChanged method
     *  is not called.  Overriding the setStyle method allows
     *  the class to be updated immediately when the locale style is
     *  set directly on this class instance.
     */
    /* override public function setStyle(styleProp:String, newValue:*):void
    {
        super.setStyle(styleProp, newValue);

        if (styleProp != "locale")
            return;

        localeChanged();
    } */

    /**
     *  @private
     *  Detects changes to style properties. When any style property is set,
     *  Flex calls the <code>styleChanged()</code> method,
     *  passing to it the name of the style being set.
     *
     *  For the Collator class this method determines whether or not the
     *  locale style has changed and if needed updates the instance of
     *  the class to reflect this change. If the locale has been
     *  updated the <code>change</code> event will be dispatched and
     *  uses of the bindable methods or properties will be updated.
     *
     *  @param styleProp The name of the style property, or null if
     *  all styles for this component have changed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.8
     */
    /* override public function styleChanged(styleProp:String):void
    {
        localeChanged();
        super.styleChanged(styleProp);
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Create an instance of the flash.globalization class used for
     *  the subclasses of this base class.
     *
     *  Classes that extend this base class MUST override this function
     */
    mx_internal function createWorkingInstance():void
    {
        // This method must be overridden by the inherited class.
        throw new IllegalOperationError();
    }

    /**
     *  @private
     *  Ensure some style source exists for this instance of a globalization
     *  object.
     *
     *  A style source is considered exist if (A) styleParent value is non-null,
     *  or (B) localeStyle value has some useable value.
     *  If neither is the case, this style client will be added to the
     *  FlexGlobals.topLevelApplication as a child if possible.
     *
     *  As a side effect this will call the styleChanged method and if the
     *  locale has changed will cause the createWorkingInstance method
     *  to be called.
     */
    mx_internal function ensureStyleSource():void
    {
        // TODO
        localeStyle = "dummy";  // needed so that derived classes return stuff
        localeChanged();        // really should be styleChanged();  needed so that createWorkingInstance() is called
        /* if (!styleParent &&
            ((localeStyle === undefined) || (localeStyle === null)))
        {
            if (FlexGlobals.topLevelApplication) 
            {
                FlexGlobals.topLevelApplication.addStyleClient(this);
            }
        } */
    }

   /**
     *  @private
     *  Helper method to propagate properties from the current instance
     *  of the class to a newly created instance.  For example when the
     *  locale changes, a new flash.globalization class is created with the
     *  new locale. This copies any properties that have been individually
     *  set to the new instance.
     *
     *  @param target  The new instance to copy the properties too.
     */
    mx_internal function propagateBasicProperties(target:Object):void
    {
        if (basicProperties)
        {
            for (var propertyName:String in basicProperties)
            {
                target[propertyName] = basicProperties[propertyName];
            }
        }
    }

    /**
     *  @private
     *  Helper method to get simple property values for all classes that
     *  extend this class.
     *
     *  @param obj The object to get the property from.
     *  @param propertyName the name of the property.
     */
    mx_internal function getBasicProperty(obj:Object, propertyName:String):*
    {
        ensureStyleSource();

        if (obj)
        {
            return obj[propertyName];
        }
        // ensureStyleSource() above could have created properties.
        else if (properties)
        {
            return properties[propertyName];
        }

        // Note that there is the rule in flash.globalization class is that the
        // getters do not update lastOperationStatus property. So we are
        // following such rule here. We update the lastOperationStatus only when
        // locale is undefined.

        if ((localeStyle === undefined) || (localeStyle === null))
        {
            fallbackLastOperationStatus
                                = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
        }

        return undefined;
    }

    /**
     *  @private
     *  Helper method to set simple property values for all classes that
     *  extend this class.
     *
     *  @param obj The object to get the property from.
     *  @param propertyName the name of the property.
     *  @param value the property value to set.
     */
    mx_internal function setBasicProperty(
                                obj:Object, propertyName:String, value:*):void
    {
        // We don't know if we are operating against flash.globalization class
        // instance or fallback one. So we clear the fallback's
        // lastOperationStatus anyway. It is not the best idea but it won't
        // hurt much either.

        fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;

        if (basicProperties)
        {
            if (basicProperties[propertyName] == value)
                return;
        }
        else
        {
            basicProperties = new Object;
        }

        basicProperties[propertyName] = value;

        if (obj)
            obj[propertyName] = value;

        update();
    }

    /**
     *  @private
     */
    mx_internal function update():void
    {
        // TODO - throws exception
        //dispatchEvent(new Event(Event.CHANGE));
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  This method is called if a style is changed on the instances of
     *  this formatter.
     *
     *  This method determines if the locale style has changed and if
     *  so it updates the formatter to reflect this change.
     *  If the locale has been updated the <code>change</code> event
     *  will be dispatched and uses of the
     *  bindable methods or properties will be updated.
     */
    private function localeChanged():void
    {
        /* const newlocaleStyle:* = super.getStyle("locale") ;

        if (localeStyle === newlocaleStyle)
            return;

        localeStyle = newlocaleStyle;
         */
        createWorkingInstance();

        update();
    }
}
}
