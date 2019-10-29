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
package org.apache.royale.reflection
{
COMPILE::SWF
{
    import flash.utils.describeType;
}

    /**
     *  A utility method to check if an object is dynamic (can have non-sealed members added or deleted)
     *  Note that static class objects are always dynamic, as are Interface Objects
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function isDynamicObject(inspect:Object):Boolean
	{
        COMPILE::SWF
        {
			try
			{
				// this test for checking whether an object is dynamic or not is
				// pretty hacky, but it assumes that no-one actually has a
				// property defined called "wootHackwoot"
				var o:* = inspect["wootHackwoot"];
			}
			catch (e:Error)
			{
				// our object isn't an instance of a dynamic class
				return false;
			}
			return true;
        }
        COMPILE::JS
        {
            if (!inspect) return false;
			var constructor:Object = inspect.constructor;
			if (constructor === Object['constructor']) {
				//class or interface
				return true;
			}
            if (constructor) {
                //instance
                if (constructor === Object || constructor === Array || constructor == Map) return true;
				var prototype:Object = constructor.prototype;
                if (prototype && prototype.ROYALE_CLASS_INFO) {
					var name:Object = prototype.ROYALE_CLASS_INFO.names[0];
                    return name.qName == 'XML' || name.qName == "XMLList" || Boolean(prototype.ROYALE_CLASS_INFO.names[0].isDynamic);
                }
				//@todo this needs work in js... swf logic not applicable here:
				var dyncheck:Boolean = false;
				try {
		
					inspect["wootHackwoot"] = "wootHackwoot";
					if (inspect["wootHackwoot"] == "wootHackwoot") dyncheck=true;
					delete inspect["wootHackwoot"];
					
				} catch(e:Error) {}
				return dyncheck;
            } else return true
        }
    }
}
