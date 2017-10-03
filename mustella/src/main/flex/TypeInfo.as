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
package {
    
COMPILE::SWF
{
    import flash.utils.Dictionary;
}
    
    /**
     *  Helper class useful for runtime object introspection.
     *  This object is generally cached by the TypeInfoCache
     *  and reused once constructed.  Right now we only care about
     *  base types and interfaces but the class could easily be 
     *  extended to properties and methods if desired.
     */
    public class TypeInfo
    {
        COMPILE::SWF
        private var baseTypes:Dictionary = new Dictionary();
        COMPILE::SWF
        private var interfaces:Dictionary = new Dictionary();
        public var className:String;
        
        /**
         * Constructor
         */
        public function TypeInfo(className:String):void
        {
            COMPILE::SWF
            {
            this.className = className;
            describeType(className);
            }
        }
        
        /** 
         * Initialization method used to populate the base types and the
         * implemented interfaces for our type.
         */
        COMPILE::SWF
        private function describeType(className:String):void
        {
            try
            {
                var definition:Object = flash.utils.getDefinitionByName(className);
            }
            catch(e:Error)
            { 
                return;
            }
            
            var typeInfo:XMLList = flash.utils.describeType(definition).child("factory");
            
            var types:XMLList = typeInfo.child("extendsClass").attribute("type");
            for each (var name:String in types)
                baseTypes[name] = true;
            
            var interfaces:XMLList = typeInfo.child("implementsInterface").attribute("type");
            for each (name in interfaces)
                this.interfaces[name] = true;
        }
        
        /**
         * Returns true if our type implements the given fully qualified interface.
         */
        COMPILE::SWF
        public function implementsInterface(interfaceName:String):Boolean
        {
           return (interfaces[interfaceName] == true) ? true : false;
        }
        
        /**
         * Returns true if our type is assignable to the type provided.
         */
        COMPILE::SWF
        public function isAssignableTo(typeName:String):Boolean
        {
           return (interfaces[typeName] == true || 
                   baseTypes[typeName]  == true ||
                   typeName == className) ? true : false;
        }
    }
}