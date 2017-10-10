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
package samples.royalestore
{

[Bindable]
public class Product
{

    public var productId:int;
    public var name:String;
    public var description:String;
    public var price:Number;
    public var image:String;
    public var experience:String;
    public var blazeds:Boolean;
    public var mobile:Boolean;
    public var video:Boolean;
    public var highlight1:String;
    public var highlight2:String;
    public var qty:int;

    public function Product()
    {

    }

    public function fill(obj:Object):void
    {
        for (var i:String in obj)
        {
            this[i] = obj[i];
        }
    }

    [Bindable(event="propertyChange")]
    public function get featureString():String
    {
    	var str:String = "";
    	if (blazeds)
    		str += "BlazeDS";

		if (mobile)
		{
			if (str.length > 0)
				str += "\n";
			str += "Mobile";
		}

		if (video)
		{
			if (str.length > 0)
				str += "\n";
			str += "Video";
		}

		return str;
    }

}

}
