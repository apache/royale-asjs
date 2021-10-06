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

import mx.rpc.wsdl.WSDLOperation;
import mx.rpc.xml.SchemaConstants;
import mx.rpc.xml.IXMLEncoder;

[ExcludeClass]

/**
 * An ISOAPEncoder is used to create SOAP 1.1 formatted requests for a web
 * service operation. A WSDLOperation provides the definition of how a SOAP
 * request should be formatted and therefore must be set before a call is made to
 * encode().
 * 
 */
public interface ISOAPEncoder extends IXMLEncoder
{
    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * Determines whether the encoder should ignore whitespace when
     * constructing an XML representation of a SOAP request.
     * The default should be <code>true</code> and thus whitespace not preserved.
     * If an XML Schema type definition specifies a <code>whiteSpace</code>
     * restriction set to <code>preserve</code> then ignoreWhitespace must
     * first be set to false. Conversely, if a type <code>whiteSpace</code>
     * restriction is set to <code>replace</code> or <code>collapse</code> then
     * that setting will be honored even if ignoreWhitespace is set to <code>false</code>.
     */
    function get ignoreWhitespace():Boolean;
    function set ignoreWhitespace(value:Boolean):void;

    /**
     * A WSDLOperation defines the SOAP binding styles and specifies how to
     * encode a SOAP request.
     */
    function get wsdlOperation():WSDLOperation;
    function set wsdlOperation(value:WSDLOperation):void;

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * Creates a SOAP-encoded request to an operation from the given input
     * parameters and headers.
	 * 
	 * @param args values to be encoded in the body of the SOAP request.
	 * 
	 * @param headers header values to be encoded in the SOAP envelope.
     * 
     * @return SOAP-encoded XML representation of the passed in arguments and headers.
     */
    function encodeRequest(args:* = null, headers:Array = null):XML;
}

}