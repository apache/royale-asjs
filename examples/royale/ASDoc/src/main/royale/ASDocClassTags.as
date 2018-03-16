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
package
{
[RemoteClass(alias='ASDocClassTags')]
public class ASDocClassTags
{
    public static const key:String = "tagName:string;values:object";

    private var _tagName:String;
    [Bindable("__NoChangeEvent__")]
    public function get tagName():String
    {
        return _tagName;
    }
    public function set tagName(__v__:String):void
    {
        _tagName = __v__;
    }

    private var _values:Array;
    [Bindable("__NoChangeEvent__")]
    public function get values():Array
    {
        return _values;
    }
    public function set values(__v__:Array):void
    {
        _values = __v__;
    }

}
}
