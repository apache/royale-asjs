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
package org.apache.royale.collections.converters
{
    import org.apache.royale.collections.converters.IItemConverter;
    
    /**
     *  The JSONItemConverter class parses a JSON structure
     *  into an ActionScript object.  Other variants
     *  would return a specific data class instance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class JSONItemConverter implements IItemConverter
	{
		public function convertItem(data:String):Object
        {
            if (data == "")
            {
                data = "{}";
            }
            else
            {
                var c:int = data.indexOf("{");
                if (c > 0)
                {
                    data = data.substring(c);
                }

                if (data.indexOf("}") == -1)
                {
                    data += "}";
                }
            }

            return JSON.parse(data);
        }
        
        /**
         *  Get a property from an object.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected function getProperty(obj:Object, propName:String):*
        {
            if (propName === 'this')
                return obj;
            
            return obj[propName];
        }
        
        /**
         *  Set a property on an object.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected function setProperty(obj:Object, propName:String, value:*):void
        {
            obj[propName] = value;
        }
	}
}
