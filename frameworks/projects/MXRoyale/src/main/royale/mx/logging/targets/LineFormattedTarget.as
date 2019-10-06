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

package mx.logging.targets
{

import mx.logging.AbstractTarget;
import mx.logging.ILogger;
import mx.logging.LogEvent;


/**
 *  All logger target implementations that have a formatted line style output
 *  should extend this class.
 *  It provides default behavior for including date, time, category, and level
 *  within the output.
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class LineFormattedTarget extends AbstractTarget
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>Constructs an instance of a logger target that will format
     *  the message data on a single line.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function LineFormattedTarget()
    {
        super();

        includeTime = false;
        includeDate = false;
        includeCategory = false;
        includeLevel = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fieldSeparator
    //----------------------------------

    [Inspectable(category="General", defaultValue=" ")]
    
    /**
     *  The separator string to use between fields (the default is " ")
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var fieldSeparator:String = " ";

    //----------------------------------
    //  includeCategory
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Indicates if the category for this target should added to the trace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var includeCategory:Boolean;

    //----------------------------------
    //  includeDate
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Indicates if the date should be added to the trace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var includeDate:Boolean;

    //----------------------------------
    //  includeLevel
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Indicates if the level for the event should added to the trace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var includeLevel:Boolean;

    //----------------------------------
    //  includeTime
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Indicates if the time should be added to the trace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var includeTime:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  This method handles a <code>LogEvent</code> from an associated logger.
     *  A target uses this method to translate the event into the appropriate
     *  format for transmission, storage, or display.
     *  This method is called only if the event's level is in range of the
     *  target's level.
     * 
     *  @param event The <code>LogEvent</code> handled by this method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function logEvent(event:LogEvent):void
    {
        var date:String = "";
        if (includeDate || includeTime)
        {
            var d:Date = new Date();
            if (includeDate)
            {
                date = Number(d.getMonth() + 1).toString() + "/" +
                       d.getDate().toString() + "/" + 
                       d.getFullYear() + fieldSeparator;
            }   
            if (includeTime)
            {
                date += padTime(d.getHours()) + ":" +
                        padTime(d.getMinutes()) + ":" +
                        padTime(d.getSeconds()) + "." +
                        padTime(d.getMilliseconds(), true) + fieldSeparator;
            }
        }
        
        var level:String = "";
        if (includeLevel)
        {
            level = "[" + LogEvent.getLevelString(event.level) +
                    "]" + fieldSeparator;
        }

        var category:String = includeCategory ?
                              ILogger(event.target).category + fieldSeparator :
                              "";

        internalLog(date + level + category + event.message);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function padTime(num:Number, millis:Boolean = false):String
    {
        if (millis)
        {
            if (num < 10)
                return "00" + num.toString();
            else if (num < 100)
                return "0" + num.toString();
            else 
                return num.toString();
        }
        else
        {
            return num > 9 ? num.toString() : "0" + num.toString();
        }
    }

    /**
     *  Descendants of this class should override this method to direct the 
     *  specified message to the desired output.
     *
     *  @param  message String containing preprocessed log message which may
     *              include time, date, category, etc. based on property settings,
     *              such as <code>includeDate</code>, <code>includeCategory</code>,
     *          etc.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function internalLog(message:String):void
    {
        // override this method to perform the redirection to the desired output
    }
}

}
