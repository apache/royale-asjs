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
package org.apache.royale.html.beads
{	
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.ContainerBase;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.Strand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.supportClasses.Border;
	import org.apache.royale.html.supportClasses.DataGroup;
	import org.apache.royale.html.beads.IListView;
    COMPILE::SWF {
        import org.apache.royale.geom.Size;
    }

	/**
	 *  The DataContainerView provides the visual elements for the DataContainer.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class VirtualDataContainerView extends DataContainerView implements IListView
	{
		public function VirtualDataContainerView()
		{
			super();
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			host.addEventListener("beadsAdded", beadsAddedHandler);
		}
		
        /**
         * @private
         */
        COMPILE::SWF
        override public function get resizableView():IUIBase
        {
            return _strand as IUIBase;
        }

        COMPILE::SWF
        override protected function calculateContentSize():Size
        {
            return _lastContentSize;
        }
        
        COMPILE::SWF
        private var _lastContentSize:Size;
        
        COMPILE::SWF
        public function set lastContentSize(value:Size):void
        {
            _lastContentSize = value;
        }
        
        /**
         * @copy org.apache.royale.core.IItemRendererOwnerView#removeAllItemRenderers()
         * @private
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        override public function removeAllItemRenderers():void
        {
            // don't remove the top and bottom spacer divs which should
            // be the first and last child
            while ((contentView as IParent).numElements > 2) {
                var child:IChild = (contentView as IParent).getElementAt(1);
                (contentView as IParent).removeElement(child);
            }
        }

	}
	
}
