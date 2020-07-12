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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.core.DispatcherBead;

	/**
	 * The DividedContainerModel holds the information necessary for the DividedContainer
	 * to size and layout its children as well as to respond to changes in
	 * those sizes made by the DividedContainerDividers.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DividedContainerModel extends DispatcherBead implements IBeadModel
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DividedContainerModel()
		{
		}

		private var _pairAdjustments:Array = [0];

		/**
		 * An array of integers indicating the size change for a pair
		 * of children in the DividedContainer. There are the same number
		 * elements in this array as their are separators.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get pairAdjustments():Array
		{
			return _pairAdjustments;
		}
		public function set pairAdjustments(value:Array):void
		{
			_pairAdjustments = value;
		}

		/**
		 * Modifies a specific pairAdjustment indicated by an index and
		 * by the amount given.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function addPairAdjustment(amount:Number, index:int):void
		{
			_pairAdjustments[index] += amount;
			dispatchEvent(new Event("pairAdjustmentChanged"));
		}
	}
}
