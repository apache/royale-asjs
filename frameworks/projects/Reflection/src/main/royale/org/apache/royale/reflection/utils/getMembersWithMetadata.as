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
     *  A utility method to retrieve all members with a single metadata tag name (String) 
	 *  or one of various tag names (an Array of Strings)
	 *  It will return variables, accessors or methods (by default) that have the specified metadata (assuming it is included in the build)
	 *  
     *  @param fromDefinition the definition to retrieve the member definitions from
	 *  @param tagsOrTag either a String or and Array of Strings to search for
	 *  @param includeStatics true if static members should be searched. Defaults to false, so only instance members are searched
	 *  @param memberTypes a bitwise combination of MemberTypes constants to restrict returned items
	 *  to VARIABLES, ACCESSORS, METHODS or specific combinations thereof, defaults to VARIABLES | ACCESSORS | METHODS
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function getMembersWithMetadata(fromDefinition:TypeDefinition, tagsOrTag:Object, includeStatics:Boolean = false, memberTypes:uint = 7):Array
	{
        var ret:Array = [];
		if (!fromDefinition) return ret;
		var search:Array = tagsOrTag is Array ? tagsOrTag as Array : [tagsOrTag+''];
		if (includeStatics) {
			if ((memberTypes & MemberTypes.VARIABLES) !=0) filterForMetaTags(fromDefinition.staticVariables, search, ret);
			if ((memberTypes & MemberTypes.ACCESSORS) !=0) filterForMetaTags(fromDefinition.staticAccessors, search, ret);
			if ((memberTypes & MemberTypes.METHODS) !=0) filterForMetaTags(fromDefinition.staticMethods, search, ret);
		}
		if ((memberTypes & MemberTypes.VARIABLES) !=0) filterForMetaTags(fromDefinition.variables, search, ret);
		if ((memberTypes & MemberTypes.ACCESSORS) !=0) filterForMetaTags(fromDefinition.accessors, search, ret);
		if ((memberTypes & MemberTypes.METHODS) !=0) filterForMetaTags(fromDefinition.methods, search, ret);
		return ret;
    }
	
	
}
