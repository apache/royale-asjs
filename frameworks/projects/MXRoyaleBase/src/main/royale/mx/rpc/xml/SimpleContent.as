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

[ExcludeClass]

/**
 * This internal utility class is used by XMLDecoder. The class is basically
 * a dynamic version any simple type such as Number, String, Boolean so 
 * that other properties can be attached to it as annotations.
 *
 * @private
 */
internal dynamic class SimpleContent
{
    // FIXME: Should this be in a custom namespace?
    public var value:*;

    public function SimpleContent(val:*)
    {
        super();
        value = val;
    }

    public function toString():String
    {
        var object:Object = value as Object;
        return object == null ? null : object.toString();
    }

    COMPILE::SWF
    public function valueOf():Object
    {
        return value as Object;
    }
}

}