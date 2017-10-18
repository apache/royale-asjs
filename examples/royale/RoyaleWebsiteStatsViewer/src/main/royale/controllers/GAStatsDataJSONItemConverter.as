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
package controllers
{
    import org.apache.royale.collections.converters.JSONItemConverter;
    
    public class GAStatsDataJSONItemConverter extends JSONItemConverter
    {
        public function GAStatsDataJSONItemConverter()
        {
            super();
        }
        
        override public function convertItem(data:String):Object
        {
			var obj:Object = {};
			var a:Array = data.split(",");
			var dateStr:String = a[0];
			var usersStr:String = a[1];
			obj.date = dateStr.substring(dateStr.indexOf("[") + 2 , dateStr.lastIndexOf('"'));
			obj.users = parseInt(usersStr.substring(usersStr.indexOf(' "') + 2, usersStr.lastIndexOf('"')));
			return obj;
        }
    }
}
