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
package org.apache.royale.utils.net
{
	COMPILE::SWF{
		import flash.net.IDynamicPropertyOutput;
	}
	
	
	COMPILE::JS
    /**
     * This interface controls the serialization of dynamic properties of dynamic objects.
     * You use this interface with the IDynamicPropertyWriter interface to create an implementation for
     * configuring serialization of dynamic objects.
     */
    public interface IDynamicPropertyOutput
    {
	
		/**
         * Adds a dynamic property to the binary output of a serialized object.
         * When the object is subsequently read (using a method such as readObject),
         * it contains the new property. You can use this method to exclude properties
         * of dynamic objects from serialization; to write values to properties
         * of dynamic objects; or to create new properties for dynamic objects.
         *
		 * @param name  The name of the property. You can use this parameter either to specify the name of an existing property of the dynamic object or to create a new property.
		 * @param value The value to write to the specified property.
		 */
		function writeDynamicProperty(name:String, value:*):void
    }
	
	
	COMPILE::SWF
	/**
	 * This interface controls the serialization of dynamic properties of dynamic objects.
	 * You use this interface with the IDynamicPropertyWriter interface to create an implementation for
	 * configuring serialization of dynamic objects.
	 *
	 * This interface is a placeholder for SWF, and cannot be used to with native serialization, because the native
	 * class (e.g. ByteArray) that supports serialization does not implement this interface (and that cannot change)
	 */
	public interface IDynamicPropertyOutput extends flash.net.IDynamicPropertyOutput
	{
	

	}

}
