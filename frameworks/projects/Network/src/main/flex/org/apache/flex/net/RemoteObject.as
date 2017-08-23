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
package org.apache.flex.net
{
    COMPILE::SWF
    {
        import flash.events.AsyncErrorEvent;
        import flash.events.IOErrorEvent;
        import flash.events.NetStatusEvent;
        import flash.events.SecurityErrorEvent;
        import flash.net.NetConnection;
        import flash.net.Responder;
        import flash.net.ObjectEncoding;
    }
        
    
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.net.events.FaultEvent;
    import org.apache.flex.net.events.ResultEvent;
    import org.apache.flex.net.remoting.Operation;
    import org.apache.flex.reflection.getClassByAlias;
    import org.apache.flex.reflection.registerClassAlias;

	[Event(name="result", type="org.apache.flex.net.events.ResultEvent")]
	[Event(name="fault", type="org.apache.flex.net.events.FaultEvent")]
	public class RemoteObject extends EventDispatcher implements IBead
	{
		private var _endPoint:String;
		private var _destination:String;
		private var _source:String;
		
		/** 
		 * 
		 * <inject_html>
		 * <script src="https://rawgit.com/emilkm/amfjs/master/amf.js"></script>
		 * </inject_html>
		 */ 
		public function RemoteObject()
		{
            COMPILE::SWF
            {
                nc = new NetConnection();
                nc.objectEncoding = ObjectEncoding.AMF3;
                nc.client = this;
            }
		}
		
        private var _strand:IStrand;
        
        public function set strand(value:IStrand):void
        {
            _strand = value;	
        }
        
        COMPILE::SWF
        public var nc:NetConnection;
        
		public function set endPoint(value:String):void
		{
			_endPoint = value;	
		}
		public function get endPoint():String
		{
			return _endPoint;	
		}
		
		public function set destination(value:String):void
		{
			_destination = value;	
		}
		public function get destination():String
		{
			return _destination;	
		}
		
		public function set source(value:String):void
		{
			_source = value;	
		}
		public function get source():String
		{
			return _source;	
		}
		
		public function send(operation:String, params:Array):void
		{
            COMPILE::SWF
            {
                nc.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
                nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
                nc.connect(endPoint);
                
                var op:Operation = new Operation(operation, this, params);
                op.send();
            }
			COMPILE::JS
			{				
				var amfClient:Object = new ((window as Object).amf).Client(_destination, _endPoint);
				var amfReq:Object = amfClient.invoke(_source, operation, params[0]);
				amfReq.then(resultHandler , faultHandler);
			}
		}
		
        COMPILE::SWF
        private function statusHandler(event:NetStatusEvent):void
        {
            trace("statusHandler", event.info.code);
        }
        
        COMPILE::SWF
        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
            trace("securityErrorHandler", event);
        }
        
        COMPILE::SWF
        private function ioErrorHandler(event:IOErrorEvent):void
        {
            trace("ioErrorHandler", event);
        }
        
        COMPILE::SWF
        private function asyncErrorHandler(event:AsyncErrorEvent):void
        {
            trace("asyncErrorHandler", event);
        }
        
		public function resultHandler(param:Object):void
		{
            COMPILE::JS
            {
    			if(param is Object && param.hasOwnProperty("_explicitType"))
    			{
    				param = typeUntypedObject(param);
    			}
    			else if (param is Array && param.length > 0)
    			{
    				for(var i:uint ; i < param.length ; i++)
    				{
    					var typedObj:Object = typeUntypedObject(param[i]);
    					param[i] = typedObj;
    				}
    			}
            }
			dispatchEvent(new ResultEvent(ResultEvent.RESULT,param.body));
		}
		
		public function faultHandler(param:Object):void
		{
			dispatchEvent(new FaultEvent(FaultEvent.FAULT,param));
		}
		
        COMPILE::JS
		private function typeUntypedObject(unTypeObject:Object):Object
		{
			registerClassAlias(unTypeObject['_explicitType'],getClassByAlias(unTypeObject['_explicitType']));
			
			var classToInstantiate:Class = getClassByAlias(unTypeObject['_explicitType']); 
			
			var typedInstance:Object = new classToInstantiate(); 
			
			for (var field:String in unTypeObject) 
			{ 
				if (field == "_explicitType") continue; //Do nothing incase of "_explicitType"
				
				typedInstance[field] = unTypeObject[field]; 
			}

			return  typedInstance;
		}
                
        /**
         *  @private
         *  Special handler for legacy AMF packet level header "AppendToGatewayUrl".
         *  When we receive this header we assume the server detected that a session was
         *  created but it believed the client could not accept its session cookie, so we
         *  need to decorate the channel endpoint with the session id.
         *
         *  We do not modify the underlying endpoint property, however, as this session
         *  is transient and should not apply if the channel is disconnected and re-connected
         *  at some point in the future.
         */
        COMPILE::SWF
        public function AppendToGatewayUrl(value:String):void
        {
            if (value != null && value != "")
            {
                nc.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
                trace("disconnecting because AppendToGatewayUrl called");
                nc.close();
                trace("disconnecting returned from close()");
                var url:String = endPoint;
                // WSRP support - append any extra stuff on the wsrp-url, not the actual url.
                
                // Do we have a wsrp-url?
                var i:int = url.indexOf("wsrp-url=");
                if (i != -1)
                {
                    // Extract the wsrp-url in to a string which will get the
                    // extra info appended to it
                    var temp:String = url.substr(i + 9, url.length);
                    var j:int = temp.indexOf("&");
                    if (j != -1)
                    {
                        temp = temp.substr(0, j);
                    }
                    
                    // Replace the wsrp-url with a version that has the extra stuff
                    url = url.replace(temp, temp + value);
                }
                else
                {
                    // If we didn't find a wsrp-url, just append the info
                    url += value;
                }
                nc.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
                trace("reconnecting with " + url);
                nc.connect(url);
                trace("reconnecting returned from connect()");
            }
        }

	}
}
