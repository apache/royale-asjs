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
package org.apache.royale.textLayout.events
{
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	
	// [ExcludeClass]
	/** The ElementEventDispatcher class adds a simple tracking counter for event listeners
	 * to the core EventDispatcher class. This variable is tlf_internal, so internal code
	 * can check quickly if an EventDispatcher has any listeners attached at all.
	 */
	
	public class FlowElementEventDispatcher extends EventDispatcher
	{
		/** @private
		 * Internal code can check this counter to quickly determine if there are any
		 * listeners attached to this dispatcher at all.
		 */
		public var _listenerCount:int = 0;
		
		/** @private
		 * The element used by this dispatcher
		 */
		public var _element:IFlowElement;
		
		/** @private 
		 * The constructor is the same as the supeclass constructor.
		 */
		public function FlowElementEventDispatcher(element:IFlowElement)
		{
			_element = element;
			super(null);
		}

//TODO Do we need these two methods? (They were causing a compiler error)		
		/** @private 
		 * The addEventListener() method increments a counter.
		 */
		// public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		// {
		// 	super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		// 	_listenerCount++;
		// 	if (_listenerCount == 1)
		// 	{
		// 		var tf:ITextFlow = _element.getTextFlow();
		// 		if (tf)
		// 			tf.incInteractiveObjectCount();
				
		// 		var pg:IParagraphElement = _element.getParagraph() ;
		// 		if (pg)
		// 			pg.incInteractiveChildrenCount() ;
		// 	}
		// 	_element.modelChanged(ModelChange.ELEMENT_MODIFIED,_element,0,_element.textLength);
		// }
		
		/** @private 
		 * The removeEventListener() method decrements a counter.
		 */
		// public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		// {
		// 	super.removeEventListener(type, listener, useCapture);
		// 	_listenerCount--;			
		// 	if (_listenerCount == 0)
		// 	{
		// 		var tf:ITextFlow = _element.getTextFlow();
		// 		if (tf)
		// 			tf.decInteractiveObjectCount();
		// 		var pg:IParagraphElement = _element.getParagraph() ;
		// 		if (pg)
		// 			pg.decInteractiveChildrenCount() ;
		// 	}
		// 	_element.modelChanged(ModelChange.ELEMENT_MODIFIED,_element,0,_element.textLength);
		// }
	}
}
