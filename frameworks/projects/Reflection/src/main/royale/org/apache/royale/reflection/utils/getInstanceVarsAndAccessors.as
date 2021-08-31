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
	import org.apache.royale.reflection.*;
	
	
    /**
     *  A utility method to retrieve all exposed variable and accessor members
	 *  It will return variables, and readwrite-only accessors that are public by default, but
	 *  you can specific different options to retrieve other combinations.
	 *  
     *  @param fromDefinition the definition to retrieve the member definitions from
	 *  @param accessorFilter bitflag combination of MemberTypes.ACCESS_READ_WRITE (the default) or MemberTypes.READ_ONLY or MemberTypes.WRITE_ONLY. Set this to 0 (zero) to exclude all accessors.
 	 *  @param publicOnly true if only public namespaced members should be returned (the default)
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 *
	 *  @royaleignorecoercion org.apache.royale.reflection.AccessorDefinition
	 *  @royaleignorecoercion org.apache.royale.reflection.VariableDefinition
     */
    public function getInstanceVarsAndAccessors(fromDefinition:TypeDefinition, accessorFilter:uint = 4, publicOnly:Boolean=true):Array
	{
		var ret:Array = [];
		if (!fromDefinition) return ret;
		ret = ret.concat(fromDefinition.variables);
		var accessors:Array = accessorFilter ? fromDefinition.accessors : [];
		if (accessors.length && ((accessorFilter & 7) != 7)) {
			var l:uint = accessors.length;
			while(l--) {
				var access:String = AccessorDefinition(accessors[l]).access;
				var includeItem:Boolean = (access == 'readwrite' && (accessorFilter & MemberTypes.ACCESS_READ_WRITE)) ||
						(access == 'readonly' && (accessorFilter & MemberTypes.ACCESS_READ_ONLY)) ||
						(access == 'writeonly' && (accessorFilter & MemberTypes.ACCESS_WRITE_ONLY));
				if (!includeItem) {
					accessors.splice(l,1);
				}
			}
		}
		ret = ret.concat(accessors);

		if (publicOnly) {
			l = ret.length;
			while(l--) {
				var varDef:VariableDefinition = VariableDefinition(ret[l]);
				if (varDef.uri) ret.splice(l,1);
			}
		}

		return ret;
    }
	
	
}
