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
package org.apache.royale.utils.dbg
{
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import org.apache.royale.core.IChild;

	/**
	 *  The DOMPathUtil class is a tracks instances of display objects
     *  and provides a unique string for each one based on its position
     *  in the tree of display objects.  It is generally used for
     *  trace output.  If you think you need this for production applications
     *  you might want to re-think your design.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    COMPILE::SWF
	public class DOMPathUtil
	{
		/**
		 * @private
		 */
		public function DOMPathUtil()
		{
			throw new Error("DOMPathUtil should not be instantiated.");
		}
		
        private static var dict:Dictionary = new Dictionary(true);
        private static var counter:int = 0;
        
		/**
		 *  Returns a string for an object.  IF the object is parented, it
         *  creates a string based on the DOMPathUtil of the parent.
		 *  
         *  @param obj The object to generate a path/name for.
		 *  @return The unique name based on the parents.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static function getPath(obj:Object):String
		{
            if (obj == null) return "";
            
            var name:String = null;
            if (dict[obj] == null)
            {
                try {
                    name = obj.id;
                } catch (e:Error)
                {
                }
                if (name == null)
                {
                    name = getQualifiedClassName(obj);
                    var c:int = name.lastIndexOf(":");
                    if (c != -1)
                        name = name.substr(c + 1);
                    name += (counter++).toString();
                }
                dict[obj] = name;
            }
            name = dict[obj];
            
            if (obj is IChild)
            {
                name = getPath(IChild(obj).parent) + "/" + name;
            }
            return name;
		}
	}
}
