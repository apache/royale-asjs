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
package org.apache.royale.test.runners
{
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.VariableDefinition;
	import org.apache.royale.reflection.describeType;
	import org.apache.royale.reflection.getDefinitionByName;
	import org.apache.royale.reflection.getQualifiedClassName;

	/**
	 * A runner for test suites.
	 * 
	 * <p>Test suites should be annotated with <code>[Suite]</code> and
	 * <code>[RunWith("org.apache.royale.test.runners.SuiteRunner")]</code>
	 * metadata. To add test classes to the suite, define a public variable for
	 * each class, using the class as the variable type. You may also add other
	 * suite classes in the same way.</p>
	 */
	public class SuiteRunner extends ParentRunner implements ITestRunner
	{
		/**
		 * Constructor.
		 */
		public function SuiteRunner(suite:Class = null)
		{
			super();
			if(!suite)
			{
				throw new Error("Suite class must not be null.");
			}
			_suite = suite;
		}

		/**
		 * @private
		 */
		private var _suite:Class = null;

		/**
		 * @private
		 */
		override public function get description():String
		{
			return getQualifiedClassName(_suite);
		}

		/**
		 * @private
		 */
		override protected function collectChildren(result:Vector.<Class>):void
		{
			if(!_suite)
			{
				return;
			}

			var typeDefinition:TypeDefinition = describeType(_suite);

			var variables:Array = typeDefinition.variables;
			var length:int = variables.length;
			for(var i:int = 0; i < length; i++)
			{
				var variable:VariableDefinition = variables[i];
				var variableType:TypeDefinition = variable.type;
				if(!variableType)
				{
					continue;
				}
				var classRef:Object = getDefinitionByName(variableType.qualifiedName);
				if(!classRef)
				{
					continue;
				}
				result.push(classRef);
			}
		}
	}
}