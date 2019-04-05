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
	import org.apache.royale.reflection.MethodDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.describeType;
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IRunListener;
	import org.apache.royale.test.runners.notification.IRunNotifier;
	import org.apache.royale.test.runners.notification.Result;

	/**
	 * Runs a class containing methods marked with <code>[Test]</code> metadata.
	 * 
	 * <p>Also supports the following optional metadata:</p>
	 * 
	 * <ul>
	 * <li>Tests with <code>[Ignore]</code> metdata should be ignored (skipped).</li>
	 * <li>Methods with <code>[Before]</code> metadata are run before every individual test.</li>
	 * <li>Methods with <code>[After]</code> metadata are run after every individual test.</li>
	 * <li>Methods with <code>[BeforeClass]</code> metadata are run one time, before the first test.</li>
	 * <li>Methods with <code>[AfterClass]</code> metadata are run one time, after the final test.</li>
	 * </ul>
	 */
	public class MetadataRunner implements ITestRunner
	{
		/**
		 * Constructor.
		 */
		public function MetadataRunner(testClass:Class)
		{
			super();
			if(!testClass)
			{
				throw new Error("Test class must not be null.");
			}
			_testClass = testClass;
		}

		/**
		 * @private
		 */
		public function get description():String
		{
			return getQualifiedClassName(_testClass);
		}

		/**
		 * @private
		 */
		protected var _testClass:Class = null;

		/**
		 * @private
		 */
		protected var _failures:Boolean = false;

		/**
		 * @private
		 */
		protected var _stopRequested:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function pleaseStop():void
		{
			_stopRequested = true;
		}

		/**
		 * @inheritDoc
		 */
		public function run(notifier:IRunNotifier):void
		{
			_failures = false;
			_stopRequested = false;

			var result:Result = new Result();
			var listener:IRunListener = result.createListener();
			notifier.addListener(listener);

			notifier.fireTestRunStarted(description);
			if(_testClass)
			{
				runTestMethods(new _testClass(), notifier);
			}
			else
			{
				_failures = true;
				notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("No tests specified.")));
			}
			notifier.removeListener(listener);

			notifier.fireTestRunFinished(result);
		}

		/**
		 * @private
		 */
		protected function runTestMethods(target:Object, notifier:IRunNotifier):void
		{
			var beforeClass:Function = collectMethodWithMetadataTag(target, TestMetadata.BEFORE_CLASS);
			var afterClass:Function = collectMethodWithMetadataTag(target, TestMetadata.AFTER_CLASS);
			var before:Function = collectMethodWithMetadataTag(target, TestMetadata.BEFORE);
			var after:Function = collectMethodWithMetadataTag(target, TestMetadata.AFTER);
			var collectedTests:Vector.<TestInfo> = new <TestInfo>[];
			collectTests(target, collectedTests);
			var collectedCount:int = collectedTests.length;
			if(collectedCount === 0)
			{
				throw new Error("No methods found with [Test] metadata. Did you forget to include the -keep-as3-metadata compiler option?")
			}
			if(beforeClass !== null)
			{
				beforeClass.apply(target);
			}
			for(var i:int = 0; i < collectedCount; i++)
			{
				try
				{
					var test:TestInfo = collectedTests[i];
					if(test.ignore)
					{
						notifier.fireTestIgnored(test.description);
						continue;
					}
					notifier.fireTestStarted(test.description);
					if(before !== null)
					{
						before.apply(target);
					}
					test.reference.apply(target);
					if(after !== null)
					{
						after.apply(target);
					}
				}
				catch(error:Error)
				{
					_failures = true;
					notifier.fireTestFailure(new Failure(test.description, error));
				}
				notifier.fireTestFinished(test.description);
			}
			if(afterClass !== null)
			{
				afterClass.apply(target);
			}
		}

		/**
		 * @private
		 */
		protected function collectMethodWithMetadataTag(target:Object, tagName:String):Function
		{
			var typeDefinition:TypeDefinition = describeType(target);
			if(!typeDefinition)
			{
				return null;
			}
			var methods:Array = typeDefinition.methods;
			var length:int = methods.length;
			for(var i:int = 0; i < length; i++)
			{
				var method:MethodDefinition = methods[i];
				var metadata:Array = method.retrieveMetaDataByName(tagName);
				if(metadata.length > 0)
				{
					return target[method.name];
				}
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function collectTests(target:Object, result:Vector.<TestInfo>):void
		{
			var typeDefinition:TypeDefinition = describeType(target);
			if(!typeDefinition)
			{
				return;
			}

			var methods:Array = typeDefinition.methods;
			var length:int = methods.length;
			for(var i:int = 0; i < length; i++)
			{
				var method:MethodDefinition = methods[i];
				var testName:String = null;
				var testFunction:Function = null;
				var ignore:Boolean = false;

				var testMetadata:Array = method.retrieveMetaDataByName(TestMetadata.TEST);
				if(testMetadata.length > 0)
				{
					var qualifiedName:String = typeDefinition.qualifiedName;
					var qualifiedNameParts:Array = qualifiedName.split(".");
					var lastPart:String = qualifiedNameParts.pop();
					qualifiedName = qualifiedNameParts.join(".");
					if(qualifiedName.length > 0)
					{
						qualifiedName += "::";
					}
					qualifiedName += lastPart;
					testName = qualifiedName + "." + method.name;
					trace(testName);
					testFunction = target[method.name];
				}
				var ignoreMetadata:Array = method.retrieveMetaDataByName(TestMetadata.IGNORE);
				if(ignoreMetadata.length > 0)
				{
					ignore = true;
				}
				if(testName !== null)
				{
					result.push(new TestInfo(testName, testFunction, ignore));
				}
			}
		}
	}
}

class TestInfo
{
	public function TestInfo(name:String, reference:Function, ignore:Boolean)
	{
		this.description = name;
		this.reference = reference;
		this.ignore = ignore;
	}

	public var description:String;
	public var reference:Function;
	public var ignore:Boolean;
}