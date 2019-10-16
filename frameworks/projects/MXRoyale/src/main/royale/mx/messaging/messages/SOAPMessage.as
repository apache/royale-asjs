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

package mx.messaging.messages
{

[RemoteClass(alias="flex.messaging.messages.SOAPMessage")]

/**
 *  SOAPMessages are similar to HTTPRequestMessages. However,
 *  they always contain a SOAP XML envelope request body
 *  that will always be sent using HTTP POST.
 *  They also allow a SOAP action to be specified.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class SOAPMessage extends HTTPRequestMessage
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------

    /**
     *  The HTTP header that stores the SOAP action for the SOAPMessage.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const SOAP_ACTION_HEADER:String = "SOAPAction";    
    
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructs an uninitialized SOAPMessage.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function SOAPMessage()
    {
        super();
        method = "POST";
        contentType = CONTENT_TYPE_SOAP_XML;
    }

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  Provides access to the name of the remote method/operation that
     *  will be called.
     *
     *  @return Returns the name of the remote method/operation that 
     *  will be called.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function getSOAPAction():String
    {
        return (httpHeaders != null) ? httpHeaders[SOAP_ACTION_HEADER] : null;
    }

    /**
     *  @private
     */
    public function setSOAPAction(value:String):void
    {
        if (value != null)
        {
            if (value.indexOf('"') < 0)
            {
                var str:String = '"';
                str += value;
                str += '"';
                value = str.toString();
            }

            if (httpHeaders == null)
                httpHeaders = {};

            httpHeaders[SOAP_ACTION_HEADER] = value;
        }
    }

}

}
