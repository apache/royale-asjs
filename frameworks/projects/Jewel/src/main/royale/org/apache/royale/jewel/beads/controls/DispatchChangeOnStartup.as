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
	import org.apache.royale.jewel.beads.models.IJewelSelectionModel;

	/**
	 *  The DispatchChangeOnStartup bead class is a specialty bead that can be used
	 *  with components that implements IJewelSelectionModel and uses dataProvider 
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
			IEventDispatcher(_strand).addEventListener('beadsAdded', onBeadsAdded);
		}


		/**
		 *  adjust the way the model behaves for dispatching change events
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function onBeadsAdded(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener('beadsAdded', onBeadsAdded);
			const model:IJewelSelectionModel = _strand.getBeadByType(IJewelSelectionModel) as IJewelSelectionModel;
			if (model) {
				IEventDispatcher(model).addEventListener('dataProviderChanged', onChange);
				IEventDispatcher(model).addEventListener('selectedItemChanged', onChange);
                IEventDispatcher(model).addEventListener('selectedIndexChanged', onChange);
			} else {
				//for now
				throw new Error('DispatchChangeOnStartup bead is not yet compatible with the component it is being applied to');
			}
		}

		private var _sawDataProviderChange:Boolean;
		private function onChange(event:Event):void{
			if (event.type == 'dataProviderChanged') {
				_sawDataProviderChange = true;
				return;
			}
			//event here is normal change event
			if (!_sawDataProviderChange) {
				//wait for a change event after dataProviderChange? needs review, maybe not
				return;
			}
			const model:IJewelSelectionModel = _strand.getBeadByType(IJewelSelectionModel) as IJewelSelectionModel;
			IEventDispatcher(model).removeEventListener('dataProviderChanged', onChange);
            IEventDispatcher(model).removeEventListener('selectedItemChanged', onChange);
            IEventDispatcher(model).removeEventListener('selectedIndexChanged', onChange);

            IEventDispatcher(_strand).dispatchEvent(new Event("change"));
		}
	}
}
