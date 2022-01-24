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
	
	import org.apache.royale.utils.array.arraysMatch;

	/**
	 *  Checks whether objects of any type match.
	 *  If deep is true, it will recursively check objects.
	 *  level is used to prevent an endless loop with circular references.
	 *  Maximum level of nesting is 100
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 *  @royaleignorecoercion Array
	 *  @royaleignorecoercion Date
	 *  @royalesuppressexport
	 */
	public function objectsMatch(first:*, second:*, deep:Boolean=false,level:int=0):Boolean
	{
		if(level > _MAX_LEVEL_)
			return false;

		if(first == null || second == null)
			return first === second;
		
		
		COMPILE::SWF
		{
			if(first is Array)
			{
				if(!(second is Array))
					return false;
				
				return arraysMatch(first as Array,second as Array, deep, level+1);
			}
			
			//TODO Vectors
			//TODO XML
			if(first is String || first is int || first is uint || first is Number || first is Boolean || first is Class)
			{
				return first === second;
			}
			else if (first is Date)
			{
				if(!(second is Date))
					return false;
				
				return (first as Date).getTime() == (second as Date).getTime();
			}
			//TODO make sure that all object properties match
			for(var x:String in first)
			{
				if(deep)
				{
					if(!objectsMatch(first[x], second[x], deep, level+1))
						return false;
				}
				else if(first[x] !== second[x])
					return false;

			}
			return true;

		}
		COMPILE::JS
		{
			var firstType:String = typeof first;
			var secondType:String = typeof second;
			if(firstType != secondType)
				return false;

			if(firstType == 'object' && secondType == 'object')
			{

				// treat all array-like objects as arrays
				if(first.constructor.name.indexOf("Array") != -1 &&
					first.constructor.name.indexOf("Array") != -1 &&
					first.propertyIsEnumerable("length") &&
					second.propertyIsEnumerable("length"))
				{
					return arraysMatch(first as Array, second as Array, deep, level+1);
				}
				// TODO Vectors that are not compiled as Arrays

				// TODO XML
				if (first is Date)
				{
					if(!(second is Date))
						return false;
					
					return (first as Date).getTime() == (second as Date).getTime();
				}

				var firstKeys:Array = Object.keys(first);
				var secondKeys:Array = Object.keys(second);
				if(!arraysMatch(firstKeys,secondKeys))
					return false;

				for(var x:String in first)
				{
					if(deep)
					{
						if(!objectsMatch(first[x],second[x],deep,level+1))
							return false;
					}
					else
					{
						if(first[x] !== second[x])
							return false;
					}
				}
				return true;
			}
			else
				return first === second;

		}
	}
}

internal const _MAX_LEVEL_:int = 100;
