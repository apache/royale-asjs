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

import mx.rpc.soap.SOAPConstants;
import mx.rpc.xml.SchemaManager;

[ExcludeClass]

/**
 * A <code>WSDLOperation</code> describes both the interface for messages being
 * sent to and from an operation and the SOAP encoding style for operation
 * binding.
 * 
 * @private
 */
public class WSDLOperation
{    
    /**
     * Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function WSDLOperation(name:String)
    {
        super();
        _name = name;
    }


    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    /**
     * Describes the parts and encoding for the input message of this
     * operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var inputMessage:WSDLMessage;

    /**
     * Used to map prefixes to namespace URIs.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var namespaces:Object;

    /**
     * Describes the parts and encoding for the output message of this
     * operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var outputMessage:WSDLMessage;

    [Inspectable(enumeration="document,rpc", category="General")]
    /**
     * Represents the style attribute for an operation's SOAP binding which
     * indicates whether an operation is RPC-oriented (messages containing
     * parameters and return values) or document-oriented (message containing
     * document(s)).
     * <p>
     * If a style is not specified for an operation the default will be
     * determined from the parent WSDLBinding's style attribute.
     * </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var style:String;


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * The name of this WSDL operation.
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
     * A SchemaManager handles the XML Schema types section of a WSDL and
     * is used to locate a type definition by QName.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get schemaManager():SchemaManager
    {
        return _schemaManager;
    }
    
    public function set schemaManager(manager:SchemaManager):void
    {
        _schemaManager = manager;
    }

    [Inspectable(defaultValue="", category="General")]
    /**
     * Specifies the value for the SOAPAction HTTPHeader used for the HTTP
     * binding of SOAP.
     * <p>
     * Although technically the soapAction must always be specified, a default
     * value of the empty String will be returned in the event that it is
     * not set.
     * </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function get soapAction():String
    {
        if (_soapAction == null)
            _soapAction = "";

        return _soapAction;
    }

    public function set soapAction(value:String):void
    {
        _soapAction = value;
    }

    /**
     * The constants for the version of SOAP used to encode messages
     * to and from this operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get soapConstants():SOAPConstants
    {
        if (_soapConstants == null)
            _soapConstants = SOAPConstants.getConstants(null);

        return _soapConstants;
    }

    public function set soapConstants(value:SOAPConstants):void
    {
        _soapConstants = value;
    }

    /**
     * The constants for the version of WSDL used to define this operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get wsdlConstants():WSDLConstants
    {
        if (_wsdlConstants == null)
            _wsdlConstants = WSDLConstants.getConstants(null);

        return _wsdlConstants;
    }

    public function set wsdlConstants(value:WSDLConstants):void
    {
        _wsdlConstants = value;
    }
    
  
    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Registers the encoding and type information for a potential fault for
     * this operation.
     * @private
     */
    public function addFault(fault:WSDLMessage):void
    {
        if (_faultsMap == null)
            _faultsMap = {};

        _faultsMap[fault.name] = fault;
    }

    /**
     * Locates a fault by name.
     * @private
     */
    public function getFault(name:String):WSDLMessage
    {
        var fault:WSDLMessage;

        if (_faultsMap != null)
            fault = _faultsMap[name];

        return fault;
    }

    private var _faultsMap:Object;
    private var _name:String;
    private var _soapAction:String;
    private var _soapConstants:SOAPConstants;
    private var _schemaManager:SchemaManager;
    private var _wsdlConstants:WSDLConstants;
}

}