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
	import org.apache.royale.core.StyledMXMLItemRenderer;
	import org.apache.royale.core.StyledUIBase;

	/**
	 *  The DataGridColumnListItemRendererInitializer class initializes item renderers
     *  in list classes and use the base class of many other initializers based on lists
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class DataGridColumnListItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function DataGridColumnListItemRendererInitializer()
		{
		}
		
        override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
			super.setupVisualsForItemRenderer(ir);

            if (presentationModel) {
				if(!presentationModel.variableRowHeight)
                	StyledUIBase(ir).height = presentationModel.rowHeight;
                //StyledUIBase(ir).height = presentationModel.rowHeight;
                
                if(ir is IAlignItemRenderer)
                {
                    (ir as IAlignItemRenderer).align = presentationModel.align;
                }
            }
            if (ir is StyledMXMLItemRenderer && ownerView)
			{
                (ir as StyledMXMLItemRenderer).itemRendererOwnerView = ownerView;
				if(StyledUIBase(_strand).emphasis != null)
				{
					(ir as StyledMXMLItemRenderer).emphasis = StyledUIBase(_strand).emphasis;
				}
			}
		}
	}
}
