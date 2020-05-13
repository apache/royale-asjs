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
	import org.apache.royale.core.IColorModel;
	import org.apache.royale.events.Event;

    /**
     *  The ArrayColorSelectionModel class is a color selection model for
     *  a dataProvider that is an array.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class ArrayColorSelectionModel extends ArraySelectionModel implements IColorModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function ArrayColorSelectionModel()
		{
			super();
			addEventListener("selectedItemChanged", dispatchChangeEvent);
			addEventListener("selectedIndexChanged", dispatchChangeEvent);
		}
		
		protected function dispatchChangeEvent(event:Event):void
		{
			dispatchEvent(new Event("change"));
		}
		
		public function get color():Number
		{
			return selectedItem == null ? NaN : Number(selectedItem);
		}
		public function set color(value:Number):void
		{
			selectedItem = value;
		}
		
	}
}
