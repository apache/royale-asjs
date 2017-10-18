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
package org.apache.royale.utils.undo
{
	/** 
	* IOperation defines the interface for operations that can be undone and redone.
	*  
	*  @langversion 3.0
	*  @playerversion Flash 10.2
	*  @playerversion AIR 2.6
	*  @productversion Royale 0.0
	*/
	public interface IOperation
	{
		/** 
		* Reperforms the operation.
		* 
		* <p>The operation is also responsible for pushing itself onto the undo stack.</p>
		*  
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		function performRedo():void;
		/** 
		* Reverses the operation.
		* 
		* <p>The operation is also responsible for pushing itself onto the redo stack.</p> 
		* 
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
		function performUndo():void;
	}
}
