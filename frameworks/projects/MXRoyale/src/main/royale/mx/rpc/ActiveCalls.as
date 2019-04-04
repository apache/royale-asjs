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

import mx.core.mx_internal;

use namespace mx_internal;

[ExcludeClass]

/**
 * @private
 */
public class ActiveCalls
{
    private var calls:Object;
    private var callOrder:Array;

    public function ActiveCalls()
    {
        super();
        calls = {};
        callOrder = [];
    }

    public function addCall(id:String, token:AsyncToken):void
    {
        calls[id] = token;
        callOrder.push(id);
    }
    
    public function getAllMessages():Array
    {
        var msgs:Array = [];
        for (var id:String in calls)
        {
            msgs.push(calls[id]);
        }
        return msgs;
    }

    public function cancelLast():AsyncToken
    {
        if (callOrder.length > 0)
        {
            return removeCall(callOrder[callOrder.length - 1] as String);
        }
        return null;
    }

    public function hasActiveCalls():Boolean
    {
        return callOrder.length > 0;
    }

    public function removeCall(id:String):AsyncToken
    {
        var token:AsyncToken = calls[id];
        if (token != null)
        {
            delete calls[id];
			callOrder.splice(callOrder.lastIndexOf(id),1);
        }
        return token;
    }

    public function wasLastCall(id:String):Boolean
    {
    	if (callOrder.length > 0)
    	{
    		return callOrder[callOrder.length - 1] == id;
    	}
    	return false;
    }
}

}
