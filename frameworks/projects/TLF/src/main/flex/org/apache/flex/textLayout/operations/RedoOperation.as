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
package org.apache.royale.textLayout.operations {




	/** 
	 * The RedoOperation class encapsulates a redo operation.
	 *
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class RedoOperation extends FlowOperation
	{
		private var _operation:FlowOperation;	/** Operation to be undone - here so listeners on FlowOperationEvent can see. */
		
		/** 
		 * Creates a RedoOperation object.
		 * 
		 * @param operation	The operation to redo.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function RedoOperation(operation:FlowOperation)
		{ 
			super(operation.textFlow);
			_operation = operation;
		}


		/** 
		 * The operation to redo.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get operation():FlowOperation
		{
			return _operation;
		}
		public function set operation(value:FlowOperation):void
		{
			_operation = value;
		}
	}
}
