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

package mx.rpc.mxml
{

/**
 * Concurrency is set via MXML based access to RPC services to indicate how to handle multiple
 * calls to the same service. The default concurrency value is <code>multiple</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public final class Concurrency
{
    /**
     * Making a request causes the client to ignore a result or fault for any current outstanding request. 
     * Only the result or fault for the most recent request will be dispatched on the client. 
     * This may simplify event handling in the client application, but care should be taken to only use 
     * this mode when results or faults for requests may be safely ignored.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const LAST:String = "last";

    /**
     * Existing requests are not cancelled, and the developer is responsible for ensuring
     * the consistency of returned data by carefully managing the event stream.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const MULTIPLE:String = "multiple";


    /**
     * Making only one request at a time is allowed on the method; additional requests made 
     * while a request is outstanding are immediately faulted on the client and are not sent to the server.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const SINGLE:String = "single";
}

}