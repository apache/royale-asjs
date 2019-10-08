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
	import org.apache.royale.reflection.MetaDataArgDefinition;
	import org.apache.royale.reflection.MetaDataDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.describeType;
	import org.apache.royale.reflection.getDefinitionByName;
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IRunNotifier;
	import org.apache.royale.test.runners.notification.Result;

	COMPILE::SWF
	{
		import flash.utils.setTimeout;
	}
	COMPILE::JS
	{
		import goog.global;
	}

	/**
	 * Provides a base implementation of a runner with children, and intended to
	 * be subclassed, similar to <code>SuiteRunner</code>.
	 * 
	 * @see org.apache.royale.test.runners.SuiteRunner
	 */
	public class ParentRunner implements ITestRunner
	{
		/**
		 * @private
		 * Hard reference to required dependency. Not actually used.
		 */
		private static var _suiteRunner:SuiteRunner;

		/**
		 * Constructor.
		 */
		public function ParentRunner(children:Vector.<Class> = null)
		{
			if(Object(this).constructor === ParentRunner)
			{
				throw new Error("Class ParentRunner is abstract");
			}
			_children = children;
		}

		/**
		 * @private
		 */
		protected var _children:Vector.<Class> = null;

		/**
		 * @private
		 */
		protected var _currentRunner:ITestRunner = null;

		/**
		 * @inheritDoc
		 */
		public function get description():String
		{
			throw new Error("AbstractClassError: get description not implemented by <" + this + ">");
		}

		/**
		 * @private
		 */
		protected var _result:Result = null;

		/**
		 * @private
		 */
		protected var _notifier:IRunNotifier = null;

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
		 * @private
		 */
		public function run(notifier:IRunNotifier):void
		{
			_failures = false;
			_stopRequested = false;
			_children = new <Class>[];
			_notifier = notifier;
			_result = new Result();
			_notifier.addListener(_result.createListener());
			_notifier.fireTestRunStarted(description);
			try
			{
				collectChildren(_children);
			}
			catch(error:Error)
			{
				_failures = true;
				notifier.fireTestFailure(new Failure(description + ".initializationError", error));
			}
			if(_children.length === 0)
			{
				_failures = true;
				notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("No children found")));
			}
			nextChild();
		}

		/**
		 * @private
		 */
		protected function nextChild():void
		{
			_currentRunner = null;
			if(_stopRequested)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description, new Error("Stop requested")));
				_children.length = 0;
			}
			if(_children.length == 0)
			{
				var notifier:IRunNotifier = _notifier;
				var result:Result = _result;
				_notifier = null;
				_result = null;
				notifier.fireTestRunFinished(result);
				notifier.removeListener(result.createListener());
				return;
			}
			COMPILE::JS
			{
				if("requestAnimationFrame" in goog.global)
				{
					goog.global["requestAnimationFrame"](createNextRunner);
				}
				else if("setImmediate" in goog.global)
				{
					goog.global["setImmediate"](createNextRunner);
				}
				else if("setTimeout" in goog.global)
				{
					goog.global["setTimeout"](createNextRunner, 0);
				}
				else
				{
					createNextRunner();
				}
			}
			COMPILE::SWF
			{
				setTimeout(createNextRunner, 0);
			}
		}

		/**
		 * @private
		 */
		protected function createNextRunner():void
		{
			//save this just in case it gets cleared later
			var notifier:IRunNotifier = _notifier;
			var child:Class = _children.pop();
			try
			{
				_currentRunner = createChildRunner(child);
				var childNotifier:ChildNotifier = new ChildNotifier(_notifier, nextChild);
				_currentRunner.run(childNotifier);
			}
			catch(error:Error)
			{
				_failures = true;
				notifier.fireTestFailure(new Failure(description, error));
				nextChild();
			}
		}

		/**
		 * Subclasses must override to collect all children for this parent
		 * runner.
		 */
		protected function collectChildren(result:Vector.<Class>):void
		{
			throw new Error("AbstractClassError: collectChildren() not implemented by <" + this + ">");
		}

		/**
		 * @private
		 */
		protected function createChildRunner(child:Class):ITestRunner
		{
			var typeDefinition:TypeDefinition = describeType(child);
			if(!typeDefinition)
			{
				throw new Error("Could not find type definition for child <" + child + "> in test suite <" + description + ">");
			}
			var runWithMetadata:Array = typeDefinition.retrieveMetaDataByName(TestMetadata.RUN_WITH);
			if(runWithMetadata.length > 0)
			{
				var RunWithClass:Class = verifyRunWith(typeDefinition);
				return new RunWithClass(child);
			}
			else
			{
				return new MetadataRunner(child);
			}
		}

		/**
		 * @private
		 */
		protected function verifyRunWith(typeDefinition:TypeDefinition):Class
		{
			if(!typeDefinition)
			{
				throw new Error("No test runner type has been specified");
			}
			var runWithMetadata:Array = typeDefinition.retrieveMetaDataByName(TestMetadata.RUN_WITH);
			if(runWithMetadata.length === 0)
			{
				throw new Error("Missing [RunWith] metadata on test runner: <" + typeDefinition.qualifiedName + ">");
			}
			var metadata:MetaDataDefinition = runWithMetadata[0];
			if(metadata.args.length !== 1)
			{
				throw new Error("Invalid class reference in [RunWith] metadata on test runner: <" + typeDefinition.qualifiedName + ">");
			}
			var arg:MetaDataArgDefinition = metadata.args[0];
			if(arg.key)
			{
				throw new Error("Unknown key <" + arg.key + "> in [RunWith] metadata on test runner: <" + typeDefinition.qualifiedName + ">");
			}
			var runWithClassName:String = arg.value;
			var RunWithClass:Class = getDefinitionByName(runWithClassName) as Class;
			if(!RunWithClass)
			{
				throw new Error("Could not find test runner: <" + runWithClassName + ">");
			}
			return RunWithClass;
		}
	}
}

import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.IRunNotifier;
import org.apache.royale.test.runners.notification.Result;

class ChildNotifier implements IRunNotifier
{
	public function ChildNotifier(parentNotifier:IRunNotifier, testRunFinishedCallback:Function)
	{
		_parentNotifier = parentNotifier;
		_testRunFinishedCallback = testRunFinishedCallback;
	}

	private var _parentNotifier:IRunNotifier
	private var _testRunFinishedCallback:Function
	
	public function fireTestStarted(description:String):void
	{
		_parentNotifier.fireTestStarted(description);
	}

	public function fireTestFinished(description:String):void
	{
		_parentNotifier.fireTestFinished(description);
	}

	public function fireTestFailure(failure:Failure):void
	{
		_parentNotifier.fireTestFailure(failure);
	}

	public function fireTestIgnored(description:String):void
	{
		_parentNotifier.fireTestIgnored(description);
	}

	public function fireTestRunStarted(description:String):void
	{
		//don't notify the parent
	}

	public function fireTestRunFinished(result:Result):void
	{
		//don't notify the parent
		_testRunFinishedCallback();
	}

	public function addListener(listener:IRunListener):void
	{
	}

	public function addFirstListener(listener:IRunListener):void
	{
	}

	public function removeListener(listener:IRunListener):void
	{
	}

	public function removeAllListeners():void
	{
	}
}