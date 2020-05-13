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
 * A portType lists a set of named operations and defines abstract interface or
 * "messages" used to interoperate with each operation.
 * 
 * @private
 */ 
public class WSDLPortType
{
    public function WSDLPortType(name:String)
    {
        super();
        _name = name;
        _operations = {};
    }


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     * The unique name for this portType.
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

    public function operations():Object
    {
        return _operations;
    }


    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------
    
    public function addOperation(operation:WSDLOperation):void
    {
        _operations[operation.name] = operation;
    }

    public function getOperation(name:String):WSDLOperation
    {
        return _operations[name];
    }

    private var _name:String;
    private var _operations:Object;
}

}
