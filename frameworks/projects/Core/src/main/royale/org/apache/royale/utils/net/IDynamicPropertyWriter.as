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
		import flash.net.IDynamicPropertyWriter;
		import flash.net.IDynamicPropertyOutput;
	}
	
	
	COMPILE::JS
    /**
     * This interface controls the serialization of dynamic properties of dynamic objects.
	 * This interface is used with the IDynamicPropertyOutput interface to control the serialization
	 * of dynamic properties of dynamic objects. To use this interface, assign an object that implements
	 * the IDynamicPropertyWriter interface to the AMFObjectEncoding.dynamicPropertyWriter property.
     */
    public interface IDynamicPropertyWriter
    {
	
		/**
         * Writes the name and value of an IDynamicPropertyOutput object to an object with dynamic properties.
		 * If ObjectEncoding.dynamicPropertyWriter is set, this method is invoked for each object with dynamic properties.
         *
		 * @param name  The name of the property. You can use this parameter either to specify the name of an existing property of the dynamic object or to create a new property.
		 * @param value The value to write to the specified property.
		 */
		function writeDynamicProperties(obj:Object, output:IDynamicPropertyOutput):void
    }
	
	
	COMPILE::SWF
	/**
	 * This interface controls the serialization of dynamic properties of dynamic objects.
	 * This interface is used with the IDynamicPropertyOutput interface to control the serialization
	 * of dynamic properties of dynamic objects. To use this interface, assign an object that implements
	 * the IDynamicPropertyWriter interface to the AMFObjectEncoding.dynamicPropertyWriter property.
	 */
	public interface IDynamicPropertyWriter extends flash.net.IDynamicPropertyWriter
	{
	
	}

}
