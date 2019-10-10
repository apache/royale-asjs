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
package org.apache.royale.jewel.beads.controls.dropdownlist
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.DropDownList;
	import org.apache.royale.jewel.beads.models.IDropDownListModel;
	
	/**
	 *  The RequireSelection bead is a specialty bead that can be used with
	 *  any DropDownList control to force a data item always be selected in the control
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class RequireSelection implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function RequireSelection()
		{
		}
		
		private var ddl:DropDownList;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			ddl = value as DropDownList;
			ddl.addEventListener('selectionChanged', selectionChangeHandler);
			ddl.addEventListener('dataProviderChanged', selectionChangeHandler);

			if(needUpdate)
			{
				needUpdate = false;
				updateRequiredSelection();
			}
		}

		private var needUpdate:Boolean = false;

		/**
         *  @private
         *  Storage for the requireSelection property.
         */
        private var _requireSelection:Boolean = false;

        /**
         *  If <code>true</code>, a data item must always be selected in the control.
         *  If the value is <code>true</code>, the <code>selectedIndex</code> property 
         *  is always set to a value between 0 and (<code>dataProvider.length</code> - 1).
         * 
         * <p>The default value is <code>false</code> for most subclasses, except TabBar. In that case, the default is <code>true</code>.</p>
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function get requireSelection():Boolean
        {
            return _requireSelection;
        }

        /**
         *  @private
         */
        public function set requireSelection(value:Boolean):void
        {
            if (value != _requireSelection)
            {
                _requireSelection = value;
				updateRequiredSelection();
            }
        }

		private function updateRequiredSelection():void {
			if(ddl) {
				var ddModel:IDropDownListModel = ddl.model as IDropDownListModel;
				if (ddModel) {
					ddModel.offset = _requireSelection ? 0 : 1;
					forceSelection();
				}
			} else {
				needUpdate = true;
			}
		}

		private function selectionChangeHandler(event:Event):void
		{
			forceSelection();
		}

		private function forceSelection():void
		{
			if(_requireSelection && ddl.selectedIndex == -1)
			{
				if (!ddl.dataProvider || ddl.dataProvider.length == 0)
				{
					return;
				}

				ddl.selectedIndex = 0;
			}	
		}
	}
}
