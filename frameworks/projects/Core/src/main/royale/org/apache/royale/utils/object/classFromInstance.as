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
package org.apache.royale.utils.object
{
	COMPILE::SWF
	{
		import flash.utils.getDefinitionByName;
		import flash.utils.getQualifiedClassName;
	}
	/**
	 * Returns the class definition of an instance of any object.
	 * The class can be used for instantiation without having to know the class type
	 * or for calling static methods.
	 * The implementation is platform specific. This function hides those implementaiot details.
	 * 
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 * 
	 */
	public function classFromInstance(instance:Object):Class
	{
		COMPILE::SWF{
			return getDefinitionByName(getQualifiedClassName(instance)) as Class;
		}

		COMPILE::JS{
			return instance.constructor;
		}
		
	}
}