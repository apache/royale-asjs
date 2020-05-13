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
package org.apache.royale.core
{
    import org.apache.royale.html.supportClasses.StyledMXMLStatesItemRenderer;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IOwnerViewItemRenderer;
    import org.apache.royale.utils.IClassSelectorListSupport;
    import org.apache.royale.utils.IEmphasis;
	
	/**
	 *  The StyledMXMLItemRenderer class is the base class for itemRenderers that are MXML-based
	 *  and provides support for ClassSelectorList.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class StyledMXMLItemRenderer extends StyledMXMLStatesItemRenderer implements IClassSelectorListSupport, IEmphasis, IOwnerViewItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function StyledMXMLItemRenderer()
		{
			super();
            typeNames = "";
		}

        private var _itemRendererOwnerView:IItemRendererOwnerView;
        /**
         *  The parent container for the itemRenderer instance.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get itemRendererOwnerView():IItemRendererOwnerView
        {
            return _itemRendererOwnerView;
        }
        public function set itemRendererOwnerView(value:IItemRendererOwnerView):void
        {
            _itemRendererOwnerView = value;
        }
        
        /**
		 *  The method called when added to a parent. The StyledItemRenderer class uses
		 *  this opportunity to assign emphasis from the strand if possible, otherwise defaults
		 *  to PRIMARY.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			if (itemRendererOwnerView && itemRendererOwnerView.host is IEmphasis && (itemRendererOwnerView.host as IEmphasis).emphasis)
			{
				emphasis = (itemRendererOwnerView.host as IEmphasis).emphasis;
			} else
			{
				emphasis = StyledUIBase.PRIMARY;
			}
		}
	}
}
