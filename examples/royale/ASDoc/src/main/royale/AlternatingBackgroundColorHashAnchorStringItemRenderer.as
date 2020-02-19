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
package
{
import  org.apache.royale.core.IOwnerViewItemRenderer;
import  org.apache.royale.core.IItemRendererOwnerView;
import org.apache.royale.html.beads.AlternatingBackgroundColorSelectableItemRendererBead;
import org.apache.royale.events.Event;

	/**
	 *  The AlternatingBackgroundColorHashAnchorItemRenderer class displays data in string form using the data's toString()
	 *  function and alternates between two background colors.  This is the most simple implementation for immutable lists
	 *  and will not handle adding/removing renderers.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AlternatingBackgroundColorHashAnchorStringItemRenderer extends HashAnchorStringItemRenderer implements IOwnerViewItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AlternatingBackgroundColorHashAnchorStringItemRenderer()
		{
			addBead(new AlternatingBackgroundColorSelectableItemRendererBead());
		}
		
        [Bindable("dataChange")]
		override public function set data(value:Object):void
		{
			super.data = value;
			dispatchEvent(new Event("dataChange"));
		}

        private var _itemRendererOwnerView:IItemRendererOwnerView;
        
        /**
         *  The text of the renderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get itemRendererOwnerView():IItemRendererOwnerView
        {
            return _itemRendererOwnerView;
        }
        
        public function set itemRendererOwnerView(value:IItemRendererOwnerView):void
        {
            _itemRendererOwnerView = value;
        }

	}
}
