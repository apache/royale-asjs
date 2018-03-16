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
[RemoteClass(alias='ASDocClass')]
public class ASDocClass
{
    public static const key:String = "baseClassname:string;description:string;events:object;members:object;qname:string;tags:object;type:string";

    private var _baseInterfaceNames:Array;
    [Bindable("__NoChangeEvent__")]
    public function get baseInterfaceNames():Array
    {
        return _baseInterfaceNames;
    }
    public function set baseInterfaceNames(__v__:Array):void
    {
        _baseInterfaceNames = __v__;
    }
    
    private var _baseClassname:String;
    [Bindable("__NoChangeEvent__")]
    public function get baseClassname():String
    {
        return _baseClassname;
    }
    public function set baseClassname(__v__:String):void
    {
        _baseClassname = __v__;
    }

    private var _description:String;
    [Bindable("__NoChangeEvent__")]
    public function get description():String
    {
        return _description;
    }
    public function set description(__v__:String):void
    {
        _description = __v__;
    }

    private var _members:Array;
    [Bindable("__NoChangeEvent__")]
    public function get members():Array
    {
        return _members;
    }
    public function set members(__v__:Array):void
    {
        _members = __v__;
    }

    private var _tags:Array;
    [Bindable("__NoChangeEvent__")]
    public function get tags():Array
    {
        return _tags;
    }
    public function set tags(__v__:Array):void
    {
        _tags = __v__;
    }

    private var _type:String;
    [Bindable("__NoChangeEvent__")]
    public function get type():String
    {
        return _type;
    }
    public function set type(__v__:String):void
    {
        _type = __v__;
    }

    private var _qname:String;
    [Bindable("__NoChangeEvent__")]
    public function get qname():String
    {
        return _qname;
    }
    public function set qname(__v__:String):void
    {
        _qname = __v__;
    }

    private var _events:Array;
    [Bindable("__NoChangeEvent__")]
    public function get events():Array
    {
        return _events;
    }
    public function set events(__v__:Array):void
    {
        _events = __v__;
    }

}
}
