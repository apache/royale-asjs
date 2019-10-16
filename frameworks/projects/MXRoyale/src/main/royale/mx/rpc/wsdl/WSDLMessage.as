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
 * From the WSDL 1.1 specification:
 * 
 * Messages consist of one or more logical parts. Each part is associated with
 * a type from some type system using a message-typing attribute. The set of
 * message-typing attributes is extensible.
 * 
 * @private
 */
public class WSDLMessage
{
    public function WSDLMessage(name:String = null)
    {
        super();

        this.name = name;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    /**
     * The SOAP encoding extensions for this message.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var encoding:WSDLEncoding;

    /**
     * Whether this message is using .NET wrapped style for document literal
     * requests.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var isWrapped:Boolean;

    /**
     * The unique name of this message.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var name:String;

    /**
     * An Array of message parts which describe the parameters of this
     * message and the order in which they were specified. By default each of
     * these parameters appear in a SOAP Envelope's Body section.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var parts:Array;

    /**
     * The QName of the element wrapper if the message is to be encoded using
     * .NET document-literal wrapped style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var wrappedQName:QName;


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Add a part to this message. The parts Array tracks the order in which
     * parts were added; an internal map allows a part to be located by name.
     * @see #getPart(String)
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function addPart(part:WSDLMessagePart):void
    {
        if (_partsMap == null)
            _partsMap = {};

        if (parts == null)
            parts = [];

        _partsMap[part.name.localName] = part;
        parts.push(part);
    }

    /**
     * Locates a message part by name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getPart(name:String):WSDLMessagePart
    {
        var part:WSDLMessagePart;

        if (_partsMap != null)
            part = _partsMap[name];

        return part;
    }

    /**
     * @private
     */
    public function addHeader(header:WSDLMessage):void
    {
        if (_headersMap == null)
            _headersMap = {};

        _headersMap[header.name] = header;
    }

    /**
     * @private
     */
    public function getHeader(name:String):WSDLMessage
    {
        var header:WSDLMessage;

        if (_headersMap != null)
            header = _headersMap[name];

        return header;
    }

    /**
     * @private
     */
    public function addHeaderFault(headerFault:WSDLMessage):void
    {
        if (_headerFaultsMap == null)
            _headerFaultsMap = {};

        _headerFaultsMap[headerFault.name] = headerFault;
    }

    /**
     * @private
     */
    public function getHeaderFault(name:String):WSDLMessage
    {
        var headerFault:WSDLMessage;

        if (_headerFaultsMap != null)
            headerFault = _headerFaultsMap[name];

        return headerFault;
    }

    private var _partsMap:Object;
    private var _headersMap:Object;
    private var _headerFaultsMap:Object;
}

}