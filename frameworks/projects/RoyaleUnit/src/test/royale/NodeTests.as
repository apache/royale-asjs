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
package
{
	import org.apache.royale.events.Event;
	import org.apache.royale.test.RoyaleUnitCore;
	import org.apache.royale.test.listeners.FailureListener;
	import org.apache.royale.test.listeners.TraceListener;

	import tests.RoyaleUnitSuite;

	public class NodeTests
	{
		public function NodeTests()
		{
			this._failureListener = new FailureListener();
			this._royaleUnit = new RoyaleUnitCore();
			this._royaleUnit.addListener(new TraceListener());
			this._royaleUnit.addListener(this._failureListener);
			this._royaleUnit.addEventListener(Event.COMPLETE, royaleUnit_completeHandler);
			this._royaleUnit.runClasses(
				RoyaleUnitSuite
			);
		}

		private var _royaleUnit:RoyaleUnitCore;
		private var _failureListener:FailureListener;

		private function royaleUnit_completeHandler(event:Event):void
		{
			var exitCode:int = 0;
			if(_failureListener.failed)
			{
				exitCode = 1;
			}
			process.exit(exitCode);
		}
	}
}