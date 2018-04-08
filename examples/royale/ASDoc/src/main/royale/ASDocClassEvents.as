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
[RemoteClass(alias='ASDocClassEvents')]
public class ASDocClassEvents
{
    public static const key:String = "description:string;qname:string;tags:object;type:string";

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

    private var _shortDescription:String;
    [Bindable("__NoChangeEvent__")]
    public function get shortDescription():String
    {
        return _shortDescription;
    }
    public function set shortDescription(__v__:String):void
    {
        _shortDescription = __v__;
    }
    
    private var _attributes:Array;
    [Bindable("__NoChangeEvent__")]
    public function get attributes():Array
    {
        return _attributes;
    }
    public function set attributes(__v__:Array):void
    {
        _attributes = __v__;
    }
    
    private var _typehref:String;
    [Bindable("__NoChangeEvent__")]
    public function get typehref():String
    {
        return _typehref;
    }
    public function set typehref(__v__:String):void
    {
        _typehref = __v__;
    }
    
    private var _ownerhref:String;
    [Bindable("__NoChangeEvent__")]
    public function get ownerhref():String
    {
        return _ownerhref;
    }
    public function set ownerhref(__v__:String):void
    {
        _ownerhref = __v__;
    }

    private var _platforms:Array;
    [Bindable("__NoChangeEvent__")]
    public function get platforms():Array
    {
        return _platforms;
    }
    public function set platforms(__v__:Array):void
    {
        _platforms = __v__;
    }

}
}
