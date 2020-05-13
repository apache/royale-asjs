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
 * Parts are a flexible mechanism for describing the content of a message.
 * 
 * @private
 */
public class WSDLMessagePart
{
    public function WSDLMessagePart(name:QName, element:QName = null, type:QName = null)
    {
        super();

        _name = name;
        this.type = type;
        this.element = element;
    }


    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    public var type:QName;

    public var element:QName;

    public var definition:XML;

    public var optional:Boolean;

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * The unique name of this message part.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get name():QName
    {
        return _name;
    }

    private var _name:QName;
}

}