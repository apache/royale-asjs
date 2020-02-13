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
package org.apache.royale.charts.beads
{
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.Bead;
    import org.apache.royale.core.IBead;
	
	/**
	 *  The ChartSelectableItemRendererBead class implements the
	 *  ISelectableItemRenderer interface and just stores the state.
     *  Subclasses will draw. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ChartSelectableItemRendererBead extends Bead implements ISelectableItemRenderer
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ChartSelectableItemRendererBead()
		{
		}
		        
        private var _hovered:Boolean;
        
        /**
         *  Whether or not the itemRenderer is in a hovered state.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get hovered():Boolean
        {
            return _hovered;
        }
        public function set hovered(value:Boolean):void
        {
            _hovered = value;
        }
        
        private var _selected:Boolean;
        
        /**
         *  Whether or not the itemRenderer is in a selected state.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get selected():Boolean
        {
            return _selected;
        }
        public function set selected(value:Boolean):void
        {
            _selected = value;
        }
        
        private var _down:Boolean;
        
        /**
         *  Whether or not the itemRenderer is in a down (or pre-selected) state.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get down():Boolean
        {
            return _down;
        }
        public function set down(value:Boolean):void
        {
            _down = value;
        }

	}
}
