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
package org.apache.royale.jewel.beads.itemRenderers
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.jewel.beads.controls.ToolTip;

    /**
     *  The ToolTipRemovalWhenItemRemoved class can be used in renderers that
     *  can be removed and uses ToolTip, to ensure the tooltip popup is removed
     *  with the item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class ToolTipRemovalWhenItemRemoved implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function ToolTipRemovalWhenItemRemoved()
		{
		}

		private var _strand:IStrand;
        private var host:IUIBase;
		
        /**
         *  listen to "itemRemoved" event dispatched from the List
         *  
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;

            var view:IBeadView = (_strand as IItemRenderer).itemRendererParent as IBeadView;
            host = view.host as IUIBase;
            IEventDispatcher(host).addEventListener("itemRemoved", handleItemRemoved);
		}

        /**
         * check if the renderer (item) is the current and in that case ensure remove listener and tip.
         */
        protected function handleItemRemoved(event:ItemRemovedEvent):void
        {
            if(event.item == this)
            {
                IEventDispatcher(host).removeEventListener("itemRemoved", handleItemRemoved);
                if(tooltip)
                {
                    tooltip.removeTip();
                }
            }
        }

        private var _tooltip:ToolTip = null;
        /**
         *  The ToolTip that manages the tip popup to be removed
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function get tooltip():ToolTip
		{
			return _tooltip;
		}

        /**
         *  @private
         */
		public function set tooltip(value:ToolTip):void
		{
			if (value != _tooltip)
			{
                _tooltip = value;
			}
		}
	}
}
