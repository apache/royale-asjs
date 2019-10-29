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
     *  A utility method to retrieve all members with a name that matches via the matcher argument
	 *  
     *  @param memberCollection the collection (an Array) of member definitions to check
	 *  @param matcher *must be* either a String or a Regexp instance to use for testing
	 *  @param collate an optional array to collate into, if passed externally
	 *  @param includeCustomNamespaces set to true if you wish to include members with custom namespaces. defaults to false.
	 *  
	 *  @returns an Array (the collate parameter if it was used, otherwise a new Array)
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 *  
	 *  @royaleignorecoercion RegExp
     */
    public function getMembersWithNameMatch(memberCollection:Array,  matcher:Object = null, collate:Array = null, includeCustomNamespaces:Boolean = false):Array
	{
        var ret:Array = collate ? collate : [];
		var regexp:RegExp;
		if (matcher is String) {
			regexp = new RegExp('^' + matcher + '$');
		} else {
			regexp = matcher as RegExp;
		}
		if (memberCollection) {
			for each(var item:MemberDefinitionBase in memberCollection) {
				if (item.uri && !includeCustomNamespaces) continue;
				if (!regexp || regexp.test(item.name)) ret.push(item);
			}
		}

		return ret;
    }
	
	
}
