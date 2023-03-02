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
package org.apache.royale.jewel.beads.controls.list
{
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.itemRenderers.ListItemRenderer;
	
	/**
	 *  The ListAutoSelectFirstIndex bead is a specialty bead that can be used with
	 *  Jewel List control to auto select the first index after the dataProvider is changed
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.11
	 */
	public class ListAutoSelectFirstIndex implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		public function ListAutoSelectFirstIndex()
		{
		}

		protected var _strand:List;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value as List;
            _strand.addEventListener("dataProviderChanged", dataProviderChangedHandler);
		}

        private function dataProviderChangedHandler(event:Event):void
        {
            if (_strand.dataProvider != null && _strand.dataProvider.length > 0)
                (_strand.getElementAt(1) as ListItemRenderer).dispatchEvent(new Event("click"));
        }
	}
}