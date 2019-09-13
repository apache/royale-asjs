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
 * A port defines an individual endpoint by specifying a single address for
 * a binding.
 * 
 * @private
 */
public class WSDLPort
{
    public function WSDLPort(name:String, service:WSDLService)
    {
        super();
        _name = name;
        _service = service;
    }

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * Represents the binding which defines the message format and protocol
     * used to interoperate with operations for this port.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get binding():WSDLBinding
    {
        return _binding;
    }

    public function set binding(value:WSDLBinding):void
    {
        _binding = value;
    }

    /**
     * The endpointURI is the SOAP bound address defined for this port.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get endpointURI():String
    {
        return _endpointURI;
    }

    public function set endpointURI(value:String):void
    {
        _endpointURI = value;
    }

    /**
     * The unique name of this port.
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
     * The WSDL service to which this port belongs.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get service():WSDLService
    {
        return _service;
    }


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public function toString():String
    {
        return "WSDLPort name=" + _name
            + ", endpointURI=" + _endpointURI
            + ", binding=" + _binding;
    }

    private var _binding:WSDLBinding
    private var _endpointURI:String;
    private var _name:String;
    private var _service:WSDLService;
}

}
