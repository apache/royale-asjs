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
package org.apache.royale.utils.array
{

	import org.apache.royale.utils.object.objectsMatch;

	/**
	 *  Checks that all items in an array match.
	 *  If deep is true, it will recursively compare properties of all items.
	 *  level is used to track the level of nesting to prevent an endless loop
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 *  @royalesuppressexport
	 */
	public function arraysMatch(first:Array,second:Array,deep:Boolean=false,level:int=0):Boolean
	{
		if(first.length != second.length)
			return false;
		
		var len:int = first.length;
		for(var i:int=0; i<len; i++)
		{
			if(deep)
			{
				if(!objectsMatch(first[i], second[i], deep, level+1))
					return false;

			}
			else if(first[i] !== second[i])
				return false;

		}
		return true;
	}
}