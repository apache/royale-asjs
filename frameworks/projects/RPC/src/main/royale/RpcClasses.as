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
package
{

/**
 *  @private
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class RpcClasses
{
	import mx.rpc.http.HTTPService; mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject; mx.rpc.remoting.RemoteObject;
	import mx.rpc.remoting.CompressedRemoteObject; mx.rpc.remoting.CompressedRemoteObject;
	import mx.rpc.Fault; Fault;
	import mx.rpc.events.InvokeEvent; InvokeEvent;
	import mx.rpc.events.ResultEvent; ResultEvent;
	import mx.rpc.AsyncResponder; AsyncResponder;
	import mx.rpc.Responder; Responder;
	import mx.rpc.events.FaultEvent; FaultEvent;
	import mx.rpc.soap.WebService; WebService;
	import mx.errors.EOFError; EOFError;
	
	import mx.rpc.http.HTTPMultiService; HTTPMultiService;
	import mx.messaging.messages.HTTPRequestMessage; HTTPRequestMessage;
	import mx.messaging.channels.DirectHTTPChannel; DirectHTTPChannel;
	import mx.messaging.errors.MessageSerializationError; MessageSerializationError;
	import mx.rpc.http.SerializationFilter; SerializationFilter;
	import mx.rpc.http.AbstractOperation; AbstractOperation;
	import mx.rpc.CallResponder; CallResponder;
	import mx.rpc.http.Operation; Operation;
	import mx.messaging.channels.URLVariables; URLVariables;
	


	import org.apache.royale.reflection.registerClassAlias;
	import mx.messaging.messages.AcknowledgeMessageExt;
	import mx.messaging.messages.AsyncMessageExt;
	import mx.messaging.messages.CommandMessageExt;
	//RpcClassAliasInitializer
	registerClassAlias("DSK", AcknowledgeMessageExt);
	registerClassAlias("DSA", AsyncMessageExt);
	registerClassAlias("DSC", CommandMessageExt);
    
}

}

