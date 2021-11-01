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

package mx.rpc.remoting.mxml
{

import mx.core.mx_internal;
import mx.rpc.AsyncToken;
import mx.rpc.AsyncDispatcher;
import mx.rpc.mxml.Concurrency;
import mx.rpc.mxml.IMXMLSupport;
import mx.rpc.remoting.RemoteObject;
import mx.rpc.remoting.Operation;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.validators.Validator;

use namespace mx_internal;

//[ResourceBundle("rpc")]

/**
 * The Operation used for RemoteObject when created in an MXML document.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Operation extends mx.rpc.remoting.Operation implements IMXMLSupport
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public function Operation(remoteObject:mx.rpc.remoting.RemoteObject = null, name:String = null)
    {
        super(remoteObject, name);

    }


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    // Internal Methods
    // 
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * Return the id for the NetworkMonitor
     */
    override mx_internal function getNetmonId():String
    {
        return remoteObject.id;
    }
    

}

}
