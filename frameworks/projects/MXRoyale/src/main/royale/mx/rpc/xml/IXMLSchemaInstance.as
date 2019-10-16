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

package mx.rpc.xml
{

/**
 * An ActionScript type should implement this interface when it needs to
 * instruct an XML Schema based encoder (such as the WebService SOAP client)
 * which concrete type definition to use while encoding instances of the type.
 * 
 * <p>Note that anonymous ActionScript objects can also specify a qualified type
 * by wrapping an object in an instance of mx.utils.ObjectProxy 
 * and setting the <code>object_proxy::type</code> property with the appropriate
 * QName.</p>
 * 
 * @see mx.utils.ObjectProxy
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IXMLSchemaInstance
{
    /**
     * When encoding ActionScript instances as XML the encoder may require
     * a type definition for the concrete implementation when the associated
     * XML Schema complexType is abstract. This property allows a typed
     * instance to specify the concrete implementation as a QName to represent
     * the <code>xsi:type</code>.
     * 
     * <p>
     * Note that <code>[Transient]</code> metadata can be applied to
     * implementations of this property to exclude it during object
     * serialization.
     * </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    function get xsiType():QName;

    function set xsiType(value:QName):void;
}

}