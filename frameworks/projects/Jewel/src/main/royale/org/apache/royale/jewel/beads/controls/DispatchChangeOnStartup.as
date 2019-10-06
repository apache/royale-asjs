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
package org.apache.royale.jewel.beads.controls
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.ISelectionModel;

	/**
	 *  The DispatchChangeOnStartup bead class is a specialty bead that can be used
	 *  with components that implements ISelectionModel and uses dataProvider
	 *  to dispatch a CHANGE event when the component is initialized
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DispatchChangeOnStartup implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DispatchChangeOnStartup()
		{
		}


		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(_strand).addEventListener('beadsAdded', listenToModel);
		}

		/**
		 *  listen for the startup selectionChanged Event that occurs when dataprovider is assigned
		 *  and there is a preselected index, fire a change event
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function listenToModel(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener('beadsAdded', listenToModel);
			const model:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			if (model) {
				IEventDispatcher(model).addEventListener('selectionChanged', onChange);
			}
		}

		private function onChange(event:Event):void{
			const model:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			IEventDispatcher(model).removeEventListener('selectionChanged', onChange);
			IEventDispatcher(_strand).dispatchEvent(new Event('change'));

		}
	}
}
