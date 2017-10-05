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
	import org.apache.flex.textLayout.elements.ITextFlow;
	import org.apache.flex.textLayout.compose.ITextFlowLine;
	import org.apache.flex.text.engine.ITextLine;
	import org.apache.flex.textLayout.compose.ParcelList;
	import org.apache.flex.textLayout.container.IContainerController;
	import org.apache.flex.textLayout.compose.ISWFContext;

	public interface IComposer
	{
		function releaseAnyReferences():void;

		function composeTextFlow(textFlow:ITextFlow, composeToPosition:int, controllerEndIndex:int):int;

		function computeTextFlowLineMinimumLogicalTop(line:ITextFlowLine, textLine:ITextLine):Number;

		function get parcelList():ParcelList;

		function get startController():IContainerController;

		function get swfContext():ISWFContext;
	}
}
