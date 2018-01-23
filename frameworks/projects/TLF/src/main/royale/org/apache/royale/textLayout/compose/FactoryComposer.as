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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.textLayout.factory.FactoryBackgroundManager;
	import org.apache.royale.textLayout.compose.utils.FactoryHelper;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.elements.IBackgroundManager;

	// [ExcludeClass]
	/** @private
	 * FactoryDisplayComposer - overridable
	 */
	public class FactoryComposer extends StandardFlowComposer implements IFactoryComposer
	{
		public function FactoryComposer()
		{
			super();
		}

		public override function callTheComposer(absoluteEndPosition:int, controllerEndIndex:int):IContainerController
		{
			// always do a full compose
			clearCompositionResults();

			var state:ISimpleCompose = FactoryHelper.staticComposer;
			state.composeTextFlow(textFlow, -1, -1);
			state.releaseAnyReferences();
			return getControllerAt(0);
		}

		/** Returns true if composition is necessary, false otherwise */
		protected override function preCompose():Boolean
		{
			return true;
		}

		/** @private */
		public override function createBackgroundManager():IBackgroundManager
		{
			return new FactoryBackgroundManager();
		}
	}
}
