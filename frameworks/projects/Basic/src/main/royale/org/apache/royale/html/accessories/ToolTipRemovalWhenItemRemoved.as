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
package org.apache.royale.html.accessories
{
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IOwnerViewItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IToolTipBead;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRemovedEvent;

    /**
     *  The ToolTipRemovalWhenItemRemoved class can be used in lists that have 
     *  item tenderers that have tooltips.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class ToolTipRemovalWhenItemRemoved extends Bead
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
        override public function set strand(value:IStrand):void
        {
			super.strand = value;
			listenOnStrand("rendererInitizalized", rendererInitizalizedHandler);
		}

		protected function rendererInitizalizedHandler(event:Event):void
		{
			var eventDispatcher:IEventDispatcher = ((_strand as IOwnerViewItemRenderer).itemRendererOwnerView as IBeadView).host as IEventDispatcher;
			eventDispatcher.addEventListener("itemRemoved", handleItemRemoved);
        }
		
        protected function handleItemRemoved(event:ItemRemovedEvent):void
        {
            _tooltip.removeTip();
        }

        private var _tooltip:IToolTipBead;
        public function set tooltip(value:IToolTipBead):void
		{
			_tooltip = value;
		}
	}
}
