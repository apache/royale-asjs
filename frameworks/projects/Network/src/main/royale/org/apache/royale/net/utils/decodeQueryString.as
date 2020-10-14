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
package org.apache.royale.net.utils
{
   

    /**
     *  Decode URL variables. 
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function decodeQueryString(queryString:String, dest:Object=null, stopAtError:Boolean=true):Boolean
    {
        if (!dest) dest = {};
        if(!queryString || !queryString.length)
            return dest;
        var pairs:Array = queryString.split('&');
        var l:uint = pairs.length;
        var hadErrors:Boolean;
        for (var i:uint=0;i<l;i++) {
            var pair:Array = String(pairs[i]).split('=');
            if (pair.length == 1) {
                hadErrors = true;
                if (stopAtError) {
                    break;
                } else {
                    continue;
                }
            }
            var field:String = decodeURIComponent(pair[0]);
            var value:String = pair[1];
            //javascript does not decode '+' correctly
            value = decodeURIComponent(value.replace(/\+/g, '%20'));
            dest[field] = value;
        }
    
        return !hadErrors;
    }
		

}
