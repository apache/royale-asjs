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
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStyledUIBase;
	import org.apache.royale.html.beads.IPaddings;
	import org.apache.royale.html.beads.layouts.Paddings;
	import org.apache.royale.jewel.beads.models.ListPresentationModel;
	import org.apache.royale.jewel.beads.models.TabBarPresentationModel;
	import org.apache.royale.jewel.itemRenderers.TabBarButtonItemRenderer;

	/**
	 *  The TabBarItemRendererInitializer class initializes item renderers
     *  in TabBar component.
	 *  
	 *  By Default this works the same as ListItemRendererInitializer, but create a placeholder
	 *  for it.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class TabBarItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function TabBarItemRendererInitializer()
		{
		}
        
		override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
			super.setupVisualsForItemRenderer(ir);

			// if layout is vertical make button width = 100% so all buttons grow to fill all available space
			var strandLayout:IBead = _strand.getBeadByType(IBeadLayout);
			
			// if(strandLayout is SimpleVerticalLayout)
			if((_strand as IStyledUIBase).containsClass("vertical"))
			{
				TabBarButtonItemRenderer(ir).percentWidth = 100;
			}

			//indicatorToOppositeSide
			if((presentationModel as TabBarPresentationModel).indicatorToOppositeSide)
			{
				TabBarButtonItemRenderer(ir).addClass("indicator-opposite-side");
			}
		}
		
		/**
		 * padding in tabbar buttons always must to be applied to content (span)
		 * not to the button itself, since we have an indicator that can be
		 * restricted to content or take all available button space.
		 */
		override public function setPaddings(ir:IStrand):void {
			var tir:TabBarButtonItemRenderer = ir as TabBarButtonItemRenderer;
			var paddings:Paddings = tir.getBeadByType(IPaddings) as Paddings;

			if(!paddings)
			{
				paddings = new Paddings();
				// always set at least L & R paddings
				paddings.paddingLeft = DEFAULT_PADDING_LR;
				paddings.paddingRight = DEFAULT_PADDING_LR;
				if(!(tir.height > ListPresentationModel.DEFAULT_ROW_HEIGHT)) 
				{
					paddings.paddingTop = DEFAULT_PADDING_TB;
					paddings.paddingBottom = DEFAULT_PADDING_TB;
				}
				ir.addBead(paddings)
			}
		}

		public static const DEFAULT_PADDING_LR:Number = 24;
		public static const DEFAULT_PADDING_TB:Number = 12;
	}
}
