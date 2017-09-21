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
package {

import flash.display.DisplayObject;

[Mixin]
/**
 *  A hash table of tests not to run.
 */
public class ExcludeList 
{

	/**
	 *  Mixin callback that gets everything ready to go.
	 *  Table is of form: ScriptName$TestID: 1,
	 */
	public static function init(root:DisplayObject):void
	{
		UnitTester.excludeList = {
			CBTester$myButtonTest1: 1,
			CBTester$myTest2: 1
		};
	}

}

}
