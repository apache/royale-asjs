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

import mx.logging.LogEventLevel;
import mx.logging.ILogger;

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
public class TraceTarget extends LineFormattedTarget
{
/*  */
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
		super();
    }

    /**
     *  Implementation to log the message via the <code>trace()</code> method.
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
    override protected function internalLog(message:String):void
    {
        trace(message);
    }
	
}

}
