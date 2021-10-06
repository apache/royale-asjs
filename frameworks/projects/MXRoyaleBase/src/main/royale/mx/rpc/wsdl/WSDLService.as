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

package mx.rpc.wsdl
{

[ExcludeClass]

/**
 * A service groups a set of related ports together for a given WSDL.
 * 
 * @private
 */
public class WSDLService
{
    public function WSDLService(name:String)
    {
        super();
        _name = name;
        _ports = {};
    }


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    public function get defaultPort():WSDLPort
    {
        return _defaultPort;
    }

    /**
     * The unique name of this service.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get name():String
    {
        return _name;
    }

    /**
     * Provides access to this service's map of ports.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get ports():Object
    {
        return _ports;
    }


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Registers a port with this service.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addPort(port:WSDLPort):void
    {
        _ports[port.name] = port;
        if (_defaultPort == null)
            _defaultPort = port;
    }    

    /**
     * Retrieves a port by name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getPort(name:String):WSDLPort
    {
        return _ports[name];
    }

    
    private var _defaultPort:WSDLPort;
    private var _name:String;
    private var _ports:Object;
}

}
