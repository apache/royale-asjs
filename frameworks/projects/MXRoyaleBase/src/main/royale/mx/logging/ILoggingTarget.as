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

/**
 *  All logger target implementations within the logging framework
 *  must implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface ILoggingTarget 
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  filters
	//----------------------------------

     /**
     *  In addition to the <code>level</code> setting, filters are used to
     *  provide a psuedo-hierarchical mapping for processing only those events
     *  for a given category.
     *  
     *  <p>Each logger belongs to a category.
     *  By convention these categories map to the fully qualified class name
     *  in which the logger is used.
     *  For example, a logger that is logging messages for the
     *  <code>mx.rpc.soap.WebService</code> class would use 
     *  <code>"mx.rpc.soap.WebService"</code> as the parameter
     *  to the <code>Log.getLogger()</code> call.
     *  When messages are sent under this category only those targets that have
     *  a filter which matches that category will receive notification of those
     *  events.
     *  Filter expressions may include a wildcard match, indicated with an
     *  asterisk.
     *  The wildcard must be the right most character in the expression.
     *  For example: rpc~~, mx.~~, or ~~.
     *  If an invalid expression is specified a <code>InvalidFilterError</code>
     *  will be thrown.
     *  No spaces or any of the following characters are valid within a filter
     *  expression: []~$^&amp;\/(){}&lt;&gt;+=`!#%?,:;'"&#64;.</p>
     *  
     *  @example
     *  <pre>
     *  var traceLogger:ILoggingTarget = new TraceTarget();
     *  traceLogger.filters = [ "mx.rpc.~~", "mx.messaging.~~" ];
     *  Log.addTarget(traceLogger);
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get filters():Array;
    
    /**
     *  @private
     */
    function set filters(value:Array):void;

	//----------------------------------
	//  level
	//----------------------------------

    /**
     *  Provides access to the level this target is currently set at.
     *  Value values are:
     *  <ul>
     *    <li><code>LogEventLevel.FATAL</code> designates events that are very
     *    harmful and will eventually lead to application failure</li>
     *
     *    <li><code>LogEventLevel.ERROR</code> designates error events that might
     *    still allow the application to continue running.</li>
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
     *
     *    <li><code>LogEventLevel.ALL</code> intended to force a target to
     *    process all messages.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get level():int;

    /**
     *  @private
     */
    function set level(value:int):void;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

    /**
     *  Sets up this target with the specified logger.
     *  This allows this target to receive log events from the specified logger.
     *  
     *  <p><b>Note:</b> This method is called by the framework
     *  and should not be called by you directly.</p>
     *  
     *  @param logger The ILogger that this target listens to.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function addLogger(logger:ILogger):void;

    /**
     *  Stops this target from receiving events from the specified logger.
     *  
     *  <p><b>Note:</b> This method is called by the framework
     *  and should not be called by you directly.</p>
     *
     *  @param logger The ILogger that this target ignores.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function removeLogger(logger:ILogger):void;
}

}
