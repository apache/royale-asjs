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
package org.apache.royale.textLayout.edit.mementos {
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.debug.Debugging;

	public class BaseMemento
{
	protected var _textFlow:ITextFlow;
	
	public function BaseMemento(textFlow:ITextFlow)
	{ _textFlow = textFlow; }
	
	CONFIG::debug public function debugCheckTextFlow(s:String):void
	{
		trace(s);
		var saveDebugCheckTextFlow:Boolean = Debugging.debugCheckTextFlow;
		var saveVerbose:Boolean = Debugging.verbose;
		Debugging.debugCheckTextFlow = true;
		Debugging.verbose = true;
		try
		{
			_textFlow.debugCheckTextFlow(false);
		}
		finally
		{
			Debugging.debugCheckTextFlow = saveDebugCheckTextFlow;
			Debugging.verbose = saveVerbose;
		}
	}
	
}

}
