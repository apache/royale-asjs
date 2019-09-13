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
 * This internal utility class is used by XMLDecoder, to store some properties
 * relevant to the current context, such as which is the current element from
 * an XMLList of values, which elements were deserialized by <any> definitions, etc.
 *
 * @private
 */
public class DecodingContext
{
    public function DecodingContext() {}

    public var index:int = 0;

    public var hasContextSiblings:Boolean = false;

    public var anyIndex:int = -1;

    public var laxSequence:Boolean = false;
}

}