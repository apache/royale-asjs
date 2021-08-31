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
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IOwnerViewItemRenderer;
	import org.apache.royale.core.ISelectable;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.ButtonBar;
	import org.apache.royale.jewel.beads.views.ButtonBarView;

	/**
	 *  The ButtonBarItemRendererInitializer class initializes item renderers
     *  in ButtonBar component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class ButtonBarItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function ButtonBarItemRendererInitializer()
		{
		}
        
        override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
			// we're not using custom paddings here, since renderer is jewel button

			if (presentationModel) {
                if(!presentationModel.variableRowHeight)
                	StyledUIBase(ir).height = presentationModel.rowHeight;
				//StyledUIBase(ir).minHeight = presentationModel.rowHeight;
                
                if(ir is IAlignItemRenderer)
                {
                    (ir as IAlignItemRenderer).align = presentationModel.align;
                }
            }
			if (ir is IOwnerViewItemRenderer && ownerView)
                (ir as IOwnerViewItemRenderer).itemRendererOwnerView = ownerView;
			if (ir is Button && ownerView)
				styleBasedOnIndex(ir);
		}

		public function styleBasedOnIndex(ir:IIndexedItemRenderer):void
		{
			var buttonBar:ButtonBar = ((ir as IOwnerViewItemRenderer).itemRendererOwnerView as ButtonBarView).buttonBar;
			if(buttonBar.emphasis != null)
			{
				StyledUIBase(ir).emphasis = buttonBar.emphasis;
			}
			
			if(ir.index == 0)
			{
				StyledUIBase(ir).addClass("first");
			}
			
			if(ir.index == buttonBar.dataProvider.length - 1 )
			{
				StyledUIBase(ir).addClass("last");
			}
			
			if(ir.index != 0 && ir.index != buttonBar.dataProvider.length - 1 )
			{
				StyledUIBase(ir).addClass("middle");
			}

			if (ir is ISelectable && buttonBar.selectedIndex == ir.index)
			{
				ISelectable(ir).selected = true;
			}
		}
	}
}
