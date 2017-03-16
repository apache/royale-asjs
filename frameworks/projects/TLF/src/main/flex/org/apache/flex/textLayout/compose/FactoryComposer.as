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
package org.apache.flex.textLayout.compose
{
	
	import org.apache.flex.textLayout.compose.utils.FactoryHelper;
	import org.apache.flex.textLayout.container.IContainerController;
	import org.apache.flex.textLayout.elements.IBackgroundManager;
	import org.apache.flex.textLayout.factory.TextLineFactoryBase;



	
	// [ExcludeClass]
	/** @private
     * FactoryDisplayComposer - overridable
	 */
	public class FactoryComposer extends StandardFlowComposer implements IFactoryComposer	{
		public function FactoryComposer()
		{ super(); }
		
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
		{ return new FactoryBackgroundManager(); }
	}
}

import org.apache.flex.textLayout.compose.ITextFlowLine;
import org.apache.flex.text.engine.ITextLine;

import org.apache.flex.textLayout.elements.BackgroundManager;


class FactoryBackgroundManager extends BackgroundManager
{
	
	public override function finalizeLine(line:ITextFlowLine):void
	{
		var textLine:ITextLine = line.getTextLine();
		
		var array:Array = _lineDict[textLine];
		if (array)
		{
			// attach the columnRect and the ITextLine to the first object in the Array
			var obj:Object = array[0];
			
			if (obj)	// check not needed?
				obj.columnRect = line.controller.columnState.getColumnAt(line.columnIndex);
		}
	}
}
