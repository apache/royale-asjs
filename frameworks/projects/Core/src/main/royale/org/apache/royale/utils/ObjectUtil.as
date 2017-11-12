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
package org.apache.royale.utils
{
    /**
	 *  The ObjectUtil class contains static utility methods for analyzing and manipulating Objects.
	 *  You do not create instances of ObjectUtil;
	 *  instead you call methods such as 
	 *  the <code>ObjectUtil.toString(var)</code> method.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 *  @productversion Royale 0.0
	 */
	public class ObjectUtil
	{
		public function ObjectUtil()
		{
			throw new Error("ObjectUtil should not be instantiated.");
		}

        /**
         * Count the properties in an object.
         * @param obj Object to count the properties of
         * @return The number of properties in the specified object. If the specified object is null, this is 0.
         */
        public static function numProperties( obj:Object ):int
        {
            var count:int = 0;
            
            for each ( var prop:Object in obj )
            {
                count++;
            }
            
            return count;
        }
         
        /**
         * Check if an object has any properties
         * @param obj Object to check for properties
         * @return If the specified object has any properties. If the specified object is null, this is false.
         */
        public static function hasProperties( obj:Object ):Boolean
        {
            for each ( var prop:Object in obj )
            {
                return true;
            }
            
            return false;
        }
        
        /**
         * Check if the properties of an object are all the same
         * @param obj Object whose properties should be checked
         * @param type Type to check the object's properties against
         * @return If all of the properties of the specified object are of the specified type
         */
        public static function isUniformPropertyType( obj:Object, type:Class ):Boolean
        {
            for each ( var prop:Object in obj )
            {
                if ( !( prop is type ) )
                {
                    return false;
                }
            }
            
            return true;
        }
        
        /**
         * Copy an object
         * @param obj Object to copy
         * @param into (optional) Object to copy into. If null, a new object is created.
         * @return A one-level deep copy of the object or null if the argument is null
         */
        public static function shallowCopy( obj:Object, into:Object=null ):Object
        {
            if ( into == null )
            {
                into = {};
            }
            if ( obj != null )
            {
                for ( var o:* in obj )
                {
                    into[o] = obj[o];
                }
            }
            return into;
        }
        
        
        
        /**
         * Convert the object to an array. Note that the order of the array is undefined.
         * @param obj Object to convert
         * @return An array with all of the properties of the given object or null if the given object is null
         */
        public static function toArray( obj:Object ):Array
        {
            if ( obj == null )
            {
                return null;
            }
            else
            {
                var ret:Array = [];
                
                for each ( var prop:Object in obj )
                {
                    ret.push( prop );
                }
                
                return ret;
            }
        }
        
        /**
         * Convert the object to a string of form: PROP: VAL&PROP: VAL where: PROP is a property VAL is its corresponding value & is the specified optional delimiter
         * This method is named with underscore "_" since toString is in use
         * @param obj Object to convert
         * @param delimiter (optional) Delimiter of property/value pairs
         * @return An string of all property/value pairs delimited by the given string or null if the input object or delimiter is null.
         */
        public static function _toString( obj:Object=null, delimiter:String = "\n" ):String
        {
            if ( obj == null || delimiter == null )
            {
                return "";
            }
            else
            {
                var ret:Array = [];
                
                for ( var s:Object in obj )
                {
                    ret.push( s + ": " + obj[s] );
                }
                
                return ret.join( delimiter );
            }
        }
        public static function addNonEnumerableProperty(obj:Object,name:String,value:*):void
        {

            COMPILE::JS
            {
                Object.defineProperty(obj, name, { "value": value, "enumerable": false });
            }

            COMPILE::SWF
            {
                obj[name] = value;
                obj.setPropertyIsEnumerable(name,value);
            }
        }

    }
}
