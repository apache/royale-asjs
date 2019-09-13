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

package mx.rpc.soap
{

/**
 * You use a SOAPHeader to specify the headers that need 
 * to be added to a SOAP envelope of a WebService Operation request.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SOAPHeader
{
    /**
     * Constructs a new SOAPHeader. The qualified name and content for the
     * SOAP header are required.
     *
     * @param qname The qualified name of the SOAP header.
     *
     * @param content The content to send for the header value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SOAPHeader(qname:QName, content:Object)
    {
        super();
        this.qname = qname;
        this.content = content;
    }

    /**
     * The content to send for the header value. 
     * If you provide an XML or flash.xml.XMLNode instance for the header, it is
     * used directly as pre-encoded content and appended as a child to the soap:header element.
     * Otherwise, you can provide the value as a String or Number, etc. and the underlying SOAP encoder
     * attempts to encode the value correctly based on the QName provided in the SOAPHeader
     * (with the last resort being xsd:anyType if a type definition is not present).     
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var content:Object;

    /**
     * The qualified name of the SOAP header.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var qname:QName;

    /**
     * Internal use only. The internal datatype as determined from
     * the WSDL schema that should be used to encode the content.
     * @private
     */
    public var xmlType:QName;

    /**
     * Specifies whether the header must be understood by the endpoint. If
     * the header is handled but must be understood the endpoint should
     * return a SOAP fault.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var mustUnderstand:Boolean;
    
    /**
     * Specifies the URI for the role that this header is intended in a 
     * potential chain of endpoints processing a SOAP request. If defined, 
     * this value is used to specify the <code>actor</code> for the SOAP 
     * header.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var role:String;

    /**
     * @private
     */
    public function toString():String
    {
        return qname + ", " + content + ", " + role; 
    }
}

}
