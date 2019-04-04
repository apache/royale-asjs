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

package mx.logging
{

import org.apache.royale.events.IEventDispatcher;

/**
 *  All loggers within the logging framework must implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface ILogger extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  category
    //----------------------------------

    /**
     *  The category value for the logger.
     *
     *  @return String containing the category for this logger.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get category():String;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Logs the specified data at the given level.
     *  
     *  <p>The String specified for logging can contain braces with an index
     *  indicating which additional parameter should be inserted
     *  into the String before it is logged.
     *  For example "the first additional parameter was {0} the second was {1}"
     *  is translated into "the first additional parameter was 10 the
     *  second was 15" when called with 10 and 15 as parameters.</p>
     *  
     *  @param level The level this information should be logged at.
     *  Valid values are:
     *  <ul>
     *    <li><code>LogEventLevel.FATAL</code> designates events that are very
     *    harmful and will eventually lead to application failure</li>
     *
     *    <li><code>LogEventLevel.ERROR</code> designates error events
     *    that might still allow the application to continue running.</li>
     *
     *    <li><code>LogEventLevel.WARN</code> designates events that could be
     *    harmful to the application operation</li>
     *
     *    <li><code>LogEventLevel.INFO</code> designates informational messages
     *    that highlight the progress of the application at
     *    coarse-grained level.</li>
     *
     *    <li><code>LogEventLevel.DEBUG</code> designates informational
     *    level messages that are fine grained and most helpful when
     *    debugging an application.</li>
     *  </ul>
     *
     *  @param message The information to log.
     *  This String can contain special marker characters of the form {x},
     *  where x is a zero based index that will be replaced with
     *  the additional parameters found at that index if specified.
     *
     *  @param rest Additional parameters that can be subsituted in the str
     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
     *  is an integer (zero based) index value into the Array of values
     *  specified.  
     *
     *  @example
     *  <pre>
     *  // Get the logger for the mx.messaging.Channel "category"
     *  // and send some data to it.
     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
     *  logger.log(LogEventLevel.DEBUG, "here is some channel info {0} and {1}", LogEventLevel.DEBUG, 15.4, true);
     *
     *  // This will log the following String as a DEBUG log message:
     *  //   "here is some channel info 15.4 and true"
     *  </pre>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function log(level:int, message:String, ... rest):void;

    /**
     *  Logs the specified data using the <code>LogEventLevel.DEBUG</code>
     *  level.
     *  <code>LogEventLevel.DEBUG</code> designates informational level
     *  messages that are fine grained and most helpful when debugging
     *  an application.
     *  
     *  <p>The string specified for logging can contain braces with an index
     *  indicating which additional parameter should be inserted
     *  into the string before it is logged.
     *  For example "the first additional parameter was {0} the second was {1}"
     *  will be translated into "the first additional parameter was 10 the
     *  second was 15" when called with 10 and 15 as parameters.</p>
     *
     *  @param message The information to log.
     *  This string can contain special marker characters of the form {x},
     *  where x is a zero based index that will be replaced with
     *  the additional parameters found at that index if specified.
     *
     *  @param rest Additional parameters that can be subsituted in the str
     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
     *  is an integer (zero based) index value into the Array of values
     *  specified.
     *
     *  @example
     *  <pre>
     *  // Get the logger for the mx.messaging.Channel "category"
     *  // and send some data to it.
     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
     *  logger.debug("here is some channel info {0} and {1}", 15.4, true);
     *
     *  // This will log the following String:
     *  //   "here is some channel info 15.4 and true"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function debug(message:String, ... rest):void;

    /**
     *  Logs the specified data using the <code>LogEventLevel.ERROR</code>
     *  level.
     *  <code>LogEventLevel.ERROR</code> designates error events
     *  that might still allow the application to continue running.
     *  
     *  <p>The string specified for logging can contain braces with an index
     *  indicating which additional parameter should be inserted
     *  into the string before it is logged.
     *  For example "the first additional parameter was {0} the second was {1}"
     *  will be translated into "the first additional parameter was 10 the
     *  second was 15" when called with 10 and 15 as parameters.</p>
     *
     *  @param message The information to log.
     *  This String can contain special marker characters of the form {x},
     *  where x is a zero based index that will be replaced with
     *  the additional parameters found at that index if specified.
     *
     *  @param rest Additional parameters that can be subsituted in the str
     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
     *  is an integer (zero based) index value into the Array of values
     *  specified.
     *
     *  @example
     *  <pre>
     *  // Get the logger for the mx.messaging.Channel "category"
     *  // and send some data to it.
     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
     *  logger.error("here is some channel info {0} and {1}", 15.4, true);
     *
     *  // This will log the following String:
     *  //   "here is some channel info 15.4 and true"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function error(message:String, ... rest):void;

    /**
     *  Logs the specified data using the <code>LogEventLevel.FATAL</code> 
     *  level.
     *  <code>LogEventLevel.FATAL</code> designates events that are very 
     *  harmful and will eventually lead to application failure
     *
     *  <p>The string specified for logging can contain braces with an index
     *  indicating which additional parameter should be inserted
     *  into the string before it is logged.
     *  For example "the first additional parameter was {0} the second was {1}"
     *  will be translated into "the first additional parameter was 10 the
     *  second was 15" when called with 10 and 15 as parameters.</p>
     *
     *  @param message The information to log.
     *  This String can contain special marker characters of the form {x},
     *  where x is a zero based index that will be replaced with
     *  the additional parameters found at that index if specified.
     *
     *  @param rest Additional parameters that can be subsituted in the str
     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
     *  is an integer (zero based) index value into the Array of values
     *  specified.
     *
     *  @example
     *  <pre>
     *  // Get the logger for the mx.messaging.Channel "category"
     *  // and send some data to it.
     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
     *  logger.fatal("here is some channel info {0} and {1}", 15.4, true);
     *
     *  // This will log the following String:
     *  //   "here is some channel info 15.4 and true"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function fatal(message:String, ... rest):void;

    /**
     *  Logs the specified data using the <code>LogEvent.INFO</code> level.
     *  <code>LogEventLevel.INFO</code> designates informational messages that 
     *  highlight the progress of the application at coarse-grained level.
     *  
     *  <p>The string specified for logging can contain braces with an index
     *  indicating which additional parameter should be inserted
     *  into the string before it is logged.
     *  For example "the first additional parameter was {0} the second was {1}"
     *  will be translated into "the first additional parameter was 10 the
     *  second was 15" when called with 10 and 15 as parameters.</p>
     *
     *  @param message The information to log.
     *  This String can contain special marker characters of the form {x},
     *  where x is a zero based index that will be replaced with
     *  the additional parameters found at that index if specified.
     *
     *  @param rest Additional parameters that can be subsituted in the str
     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
     *  is an integer (zero based) index value into the Array of values
     *  specified.
     *
     *  @example
     *  <pre>
     *  // Get the logger for the mx.messaging.Channel "category"
     *  // and send some data to it.
     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
     *  logger.info("here is some channel info {0} and {1}", 15.4, true);
     *
     *  // This will log the following String:
     *  //   "here is some channel info 15.4 and true"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function info(message:String, ... rest):void;

    /**
     *  Logs the specified data using the <code>LogEventLevel.WARN</code> level.
     *  <code>LogEventLevel.WARN</code> designates events that could be harmful 
     *  to the application operation.
     *      
     *  <p>The string specified for logging can contain braces with an index
     *  indicating which additional parameter should be inserted
     *  into the string before it is logged.
     *  For example "the first additional parameter was {0} the second was {1}"
     *  will be translated into "the first additional parameter was 10 the
     *  second was 15" when called with 10 and 15 as parameters.</p>
     *  
     *  @param message The information to log.
     *  This String can contain special marker characters of the form {x},
     *  where x is a zero based index that will be replaced with
     *  the additional parameters found at that index if specified.
     *
     *  @param rest Aadditional parameters that can be subsituted in the str
     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
     *  is an integer (zero based) index value into the Array of values
     *  specified.
     *
     *  @example
     *  <pre>
     *  // Get the logger for the mx.messaging.Channel "category"
     *  // and send some data to it.
     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
     *  logger.warn("here is some channel info {0} and {1}", 15.4, true);
     *
     *  // This will log the following String:
     *  //   "here is some channel info 15.4 and true"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function warn(message:String, ... rest):void;
}

}