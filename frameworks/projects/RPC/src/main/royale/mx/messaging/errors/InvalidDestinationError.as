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

package mx.messaging.errors
{

/**
 *  This error is thrown when a destination can't be accessed
 *  or is not valid.
 *  This error is thrown by the following methods/properties
 *  within the framework:
 *  <ul>
 *    <li><code>ServerConfig.getChannelSet()</code> if an invalid destination is specified.</li>
 *    <li><code>ServerConfig.getProperties()</code> if an invalid destination is specified.</li>
 *    <li><code>Channel.send()</code> if no destination is specified for the message to send.</li>
 *    <li><code>MessageAgent.destination</code> setter if the destination value is null or zero length.</li>
 *    <li><code>Producer.send()</code> if no destination is specified for the Producer or message to send.</li>
 *    <li><code>Consumer.subscribe()</code> if no destination is specified for the Consumer.</li>
 *  </ul>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class InvalidDestinationError extends ChannelError
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructs a new instance of an InvalidDestinationError with the specified message.
     *
     *  @param msg String that contains the message that describes this InvalidDestinationError.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function InvalidDestinationError(msg:String)
    {
        super(msg);
    }
}

}
