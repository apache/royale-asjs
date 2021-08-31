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
package org.apache.royale.reflection.utils
{
	import org.apache.royale.reflection.TypeDefinition;
	
	
    /**
     *  A utility method to check whether one definition represents the same type (Class or Interface) as another
	 *
	 *  This check is useful in situations where TypeDefinition.useCache is false
	 *  
     *  @param type1 TypeDefinition the first definition
	 *  @param type2 TypeDefinition the second definition
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 *
	 *  @royaleignorecoercion org.apache.royale.reflection.TypeDefinition
	 *  @royalesuppressexport
     */
    public function isSameType(type1:TypeDefinition, type2:TypeDefinition):Boolean
	{
		if (!type1 || !type2) throw new Error('both arguments must be non-null');

		//if caching is not enabled, then it is possible that there could be two separate instances representing the same type
		return (type1 == type2 || type1.qualifiedName == type2.qualifiedName);

    }
	
	
}
