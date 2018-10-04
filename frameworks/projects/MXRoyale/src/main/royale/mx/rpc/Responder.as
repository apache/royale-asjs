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

package mx.rpc
{

/**
 *  This class provides a default implementation of 
 *  the mx.rpc.IResponder interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Responder implements IResponder
{
    /**
     *  Constructs an instance of the responder with the specified handlers.
     *  
     *  @param  result Function that should be called when the request has
     *           completed successfully.
     *  @param  fault Function that should be called when the request has
     *          completed with errors.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function Responder(result:Function, fault:Function)
    {
        super();
        _resultHandler = result;
        _faultHandler = fault;
    }
    
    /**
     *  This method is called by a remote service when the return value has been 
     *  received.
         *
     *  @param data Object containing the information about the error that occured. .
     *  While <code>data</code> is typed as Object, it is often (but not always) 
     *  an mx.rpc.events.ResultEvent.
     */
    public function result(data:Object):void
    {
        _resultHandler(data);
    }
    
    /**
     *  This method is called by a service when an error has been received.
         *
     *  @param info Object containing the information returned from the request.
     *  While <code>info</code> is typed as Object, it is often (but not always) 
     *  an mx.rpc.events.FaultEvent.
     */
    public function fault(info:Object):void
    {
        _faultHandler(info);
    }
    
    /**
     *  @private
     */
    private var _resultHandler:Function;
    
    /**
     *  @private
     */
    private var _faultHandler:Function;
}


}