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

package mx.rpc.soap.types
{
    
import mx.rpc.soap.SOAPDecoder;
import mx.rpc.soap.SOAPEncoder;
import mx.rpc.xml.ContentProxy;
import mx.utils.object_proxy;
import mx.utils.ObjectProxy;

use namespace object_proxy;

[ExcludeClass]

/**
 * Marshalls between an Apache SOAP Document type and ActionScript XML.
 * @private
 */
public class ApacheDocumentType implements ICustomSOAPType
{
    public function ApacheDocumentType()
    {
        super();
    }

    public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null):void
    {
    	encoder.setValue(parent, value);
    }

    public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null):void
    {
        decoder.setValue(parent, name, XML(value).elements());
    }
       
}
}