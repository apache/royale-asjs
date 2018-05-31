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
package org.apache.royale.net.remoting.messages
{
    [RemoteClass(alias="flex.messaging.messages.ErrorMessage")]
    /**
     *  ErrorMessages are sometimes returned from RPC requests to a remote endpoint.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     * 
     *  @royalesuppresspublicvarwarning
     */
    public class ErrorMessage extends AcknowledgeMessage
    {
        //--------------------------------------------------------------------------
        //
        // Constructor
        // 
        //--------------------------------------------------------------------------
        
        /**
         *  Constructs an uninitialized ErrorMessage.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public function ErrorMessage()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        // Variables
        // 
        //--------------------------------------------------------------------------    

        /**
         *  Provides the error message.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3 
         */
        public var message:String;


    }
}
