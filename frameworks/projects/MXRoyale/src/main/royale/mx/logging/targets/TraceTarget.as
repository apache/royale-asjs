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

import mx.core.mx_internal;
import mx.logging.LogEventLevel;
import mx.logging.ILogger;
use namespace mx_internal;

/**
 *  Provides a logger target that uses the global <code>trace()</code> method to output log messages.
 *  
 *  <p>To view <code>trace()</code> method output, you must be running the 
 *  debugger version of Flash Player or AIR Debug Launcher.</p>
 *  
 *  <p>The debugger version of Flash Player and AIR Debug Launcher send output from the <code>trace()</code> method 
 *  to the flashlog.txt file. The default location of this file is the same directory as 
 *  the mm.cfg file. You can customize the location of this file by using the <code>TraceOutputFileName</code> 
 *  property in the mm.cfg file. You must also set <code>TraceOutputFileEnable</code> to 1 in your mm.cfg file.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class TraceTarget 
{
/* extends LineFormattedTarget */
 //   include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>Constructs an instance of a logger target that will send
     *  the log data to the global <code>trace()</code> method.
     *  All output will be directed to flashlog.txt by default.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function TraceTarget()
    {
		//super();
		
		
		
    }

   
    //----------------------------------
    //  includeLevel copied from LineFormattedTarget
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Indicates if the level for the event should added to the trace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var includeLevel:Boolean;

	 //----------------------------------
    //  includeTime copied from LineFormattedTarget
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  Indicates if the time should be added to the trace.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var includeTime:Boolean;

	 //----------------------------------
    //  filters copied from AbstractTarget
    //----------------------------------

    /**
     *  @private
     *  Storage for the filters property.
     */
    private var _filters:Array = [ "*" ];

    [Inspectable(category="General", arrayType="String")]
    
    /**
     *  In addition to the <code>level</code> setting, filters are used to
     *  provide a psuedo-hierarchical mapping for processing only those events
     *  for a given category.
     *  <p>
     *  Each logger belongs to a category.
     *  By convention these categories map to the fully-qualified class name in
     *  which the logger is used.
     *  For example, a logger that is logging messages for the
     *  <code>mx.rpc.soap.WebService</code> class, uses 
     *  "mx.rpc.soap.WebService" as the parameter to the 
     *  <code>Log.getLogger()</code> method call.
     *  When messages are sent under this category only those targets that have
     *  a filter which matches that category receive notification of those
     *  events.
     *  Filter expressions can include a wildcard match, indicated with an
     *  asterisk.
     *  The wildcard must be the right-most character in the expression.
     *  For example: rpc~~, mx.~~, or ~~.
     *  If an invalid expression is specified, a <code>InvalidFilterError</code>
     *  is thrown.
     *  If <code>null</code> or [] is specified, the filters are set to the
     *  default of ["~~"].
     *  </p>
     *  <p>For example:
     *     <pre>
     *           var traceLogger:ILoggingTarget = new TraceTarget();
     *           traceLogger.filters = ["mx.rpc.~~", "mx.messaging.~~"];
     *           Log.addTarget(traceLogger);
     *     </pre>
     *  </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get filters():Array
    {
        return _filters;
    }

    /**
     *  @private
     *  This method will make sure that all of the filter expressions specified
     *  are valid, and will throw <code>InvalidFilterError</code> if any are not.
     */
    public function set filters(value:Array):void
    {
        /* if (value && value.length > 0)
        {
            // a valid filter value will be fully qualified or have a wildcard
            // in it.  the wild card can only be located at the end of the
            // expression.  valid examples  xx*, xx.*,  *
            var filter:String;
            var index:int;
            var message:String;
            for (var i:uint = 0; i<value.length; i++)
            {
                filter = value[i];
                  // check for invalid characters
                if (Log.hasIllegalCharacters(filter))
                {
                    message = resourceManager.getString(
                        "logging", "charsInvalid", [ filter ]);
                    throw new InvalidFilterError(message);
                }

                index = filter.indexOf("*");
                if ((index >= 0) && (index != (filter.length -1)))
                {
                    message = resourceManager.getString(
                        "logging", "charPlacement", [ filter ]);
                    throw new InvalidFilterError(message);
                }
            } // for
        }
        else
        {
            // if null was specified then default to all
            value = ["*"];
        }

        if (_loggerCount > 0)
        {
            Log.removeTarget(this);
            _filters = value;
            Log.addTarget(this);
        }
        else
        {
            _filters = value;
        } */
    }
	//addLogger copied from AbstractTarget
	/**
     *  Sets up this target with the specified logger.
     *  This allows this target to receive log events from the specified logger.
     *
     *  @param logger The ILogger that this target should listen to.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function addLogger(logger:ILogger):void
    {
        if (logger)
        {
           // _loggerCount++;
           // logger.addEventListener(LogEvent.LOG, logHandler);
        }
    }
	
	//removeLogger copied from AbstractTarget
	/**
     *  Stops this target from receiving events from the specified logger.
     *
     *  @param logger The ILogger that this target should ignore.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function removeLogger(logger:ILogger):void
    {
        if (logger)
        {
          //  _loggerCount--;
           // logger.removeEventListener(LogEvent.LOG, logHandler);
        }
    }
	
	 //----------------------------------
    //  level
    //----------------------------------

    /**
     *  @private
     *  Storage for the level property.
     */
    private var _level:int = LogEventLevel.ALL;

    /**
     *  Provides access to the level this target is currently set at.
     *  Value values are:
     *    <ul>
     *      <li><code>LogEventLevel.FATAL (1000)</code> designates events that are very
     *      harmful and will eventually lead to application failure</li>
     *
     *      <li><code>LogEventLevel.ERROR (8)</code> designates error events that might
     *      still allow the application to continue running.</li>
     *
     *      <li><code>LogEventLevel.WARN (6)</code> designates events that could be
     *      harmful to the application operation</li>
     *
     *      <li><code>LogEventLevel.INFO (4)</code> designates informational messages
     *      that highlight the progress of the application at
     *      coarse-grained level.</li>
     *
     *      <li><code>LogEventLevel.DEBUG (2)</code> designates informational
     *      level messages that are fine grained and most helpful when
     *      debugging an application.</li>
     *
     *      <li><code>LogEventLevel.ALL (0)</code> intended to force a target to
     *      process all messages.</li>
     *    </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get level():int
    {
        return _level;
    }

    /**
     *  @private
     */
    public function set level(value:int):void
    {
        // A change of level may impact the target level for Log.
       //Log.removeTarget(this);
        _level = value;
      //  Log.addTarget(this);        
    }
	
}

}
