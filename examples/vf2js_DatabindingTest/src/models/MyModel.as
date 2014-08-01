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
package models
{

import flash.events.Event;
import flash.events.EventDispatcher;
import mx.collections.ArrayCollection;

public class MyModel extends EventDispatcher
{
    
    //--------------------------------------------------------------------------
    //
    //   Constructor 
    //
    //--------------------------------------------------------------------------
    
    public function MyModel()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //   Properties 
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    // allData 
    //--------------------------------------
    
    private var _allData:String = "";
    
    [Bindable("responseDataChanged")]
    public function get allData():String
    {
        if (_allData == "" && _responseData != null)
        {
            for (var p:String in _responseData)
            {
                _allData += p + ": " + _responseData[p] + "\n";
            }
        }
        return _allData;
    }
    
    //--------------------------------------
    // requestedField 
    //--------------------------------------
    
    private var _requestedField:String = "Ask";
    
    [Bindable("requestedFieldChanged")]
    public function get requestedField():String
    {
        return _requestedField;
    }
    
    public function set requestedField(value:String):void
    {
        if (value != _requestedField)
        {
            _requestedField = value;
            dispatchEvent(new Event("requestedFieldChanged"));
            if (_responseData)
            {
                dispatchEvent(new Event("responseTextChanged"));
            }
        }
    }
    
    //--------------------------------------
    // responseData 
    //--------------------------------------
    
    private var _responseData:Object;
    
    [Bindable("responseDataChanged")]
    public function get responseData():Object
    {
        return _responseData;
    }
    
    public function set responseData(value:Object):void
    {
        if (value != _responseData)
        {
            _responseData = value;
            _allData = "";
            dispatchEvent(new Event("responseDataChanged"));
            dispatchEvent(new Event("responseTextChanged"));
        }
    }
    
    //--------------------------------------
    // responseText 
    //--------------------------------------
    
    private var _responseText:String;
    
    [Bindable("responseTextChanged")]
    public function get responseText():String
    {
        if (_responseData == null)
        {
            return "";
        }
        if (_responseData == "No Data")
        {
            return _responseData as String;
        }
        var s:String = _responseData[_requestedField];
        if (s == null)
        {
            if (_requestedField == "Ask")
            {
                s = _responseData["Bid"];
            }
        }
        return s;
    }
    
    //--------------------------------------
    // stockSymbol 
    //--------------------------------------
    
    private var _stockSymbol:String;
    
    [Bindable(event = "stockSymbolChanged")]
    public function get stockSymbol():String
    {
        return _stockSymbol;
    }
    
    public function set stockSymbol(value:String):void
    {
        if (_stockSymbol !== value)
        {
            _stockSymbol = value;
            dispatchEvent(new Event("stockSymbolChanged"));
        }
    }
    
    //--------------------------------------
    // strings 
    //--------------------------------------
    
    private var _strings:ArrayCollection = new ArrayCollection([ "AAPL", "ADBE",
            "GOOG", "MSFT", "YHOO" ]);
    
    public function get strings():ArrayCollection
    {
        return _strings;
    }
}

}
