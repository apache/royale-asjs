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
     *  A utility method to retrieve members with a name that matches via the matcher QName argument
	 *  
     *  @param memberCollection the collection (an Array) of member definitions to check
	 *  @param matcher a QName to check against definitions. An undefined uri represents any namespace, a '*' represents any local name.
	 *  @param collate an optional array to collate into, if passed externally
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
    public function getMembersWithQNameMatch(memberCollection:Array, matcher:QName = null, collate:Array = null):Array
	{
        var ret:Array = collate ? collate : [];
		if (matcher == null) {
			matcher = new QName('*');
		}
		if (memberCollection) {
			for each(var item:MemberDefinitionBase in memberCollection) {
				if (!matcher.uri) {
					if (matcher.uri == '') {
						if (item.uri =='') {
							if (matcher.localName == '*' || matcher.localName == item.name) ret.push(item);
						}
					} else {
						//any uri
						if (matcher.localName == '*' || matcher.localName == item.name) ret.push(item);
					}
				} else {
					//specific uri
					if (matcher.uri == item.uri) {
						if (matcher.localName == '*' || matcher.localName == item.name) ret.push(item);
					}
				}
			}
		}

		return ret;
    }
	
	
}
