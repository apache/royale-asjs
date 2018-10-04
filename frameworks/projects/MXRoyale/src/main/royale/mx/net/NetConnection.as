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

package mx.net
{
    import mx.messaging.messages.IMessage;
    
    import org.apache.royale.events.EventDispatcher;

/**
 *  The NetConnection class mimics the Flash NetConnection.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class NetConnection extends EventDispatcher
{
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  close
	 * 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion ApacheFlex 4.10
	 */
	public function close():void
    {
        
    }

    /**
     *  connected
     * 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion ApacheFlex 4.10
     */
    public var connected:Boolean;
    
    /**
     *  client
     * 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion ApacheFlex 4.10
     */
    public var client:Object;
    
    /**
     *  objectencoding
     * 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion ApacheFlex 4.10
     */
    public var objectEncoding:uint;
    
    /**
     *  uri
     * 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion ApacheFlex 4.10
     */
    public var uri:String;
    
    /**
     *  connect
     * 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion ApacheFlex 4.10
     */
    public function connect(url:String):void
    {
        
    }

    /**
     *  call
     * 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion ApacheFlex 4.10
     */
    public function call(thisObject:Object, responder:Responder, message:IMessage):void
    {
        
    }
}

}