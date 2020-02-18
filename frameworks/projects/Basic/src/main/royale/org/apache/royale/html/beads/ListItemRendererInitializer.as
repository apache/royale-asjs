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
	import org.apache.royale.core.IItemRendererOwnerView;
	
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.ILabelFieldItemRenderer;
    import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithPresentationModel;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;

	/**
	 *  The ListItemRendererInitializer class initializes item renderers
     *  in list classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ListItemRendererInitializer extends IndexedItemRendererInitializer implements IIndexedItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ListItemRendererInitializer()
		{
		}
		
        protected var presentationModel:IListPresentationModel;
        
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		override public function set strand(value:IStrand):void
		{	
			super.strand = value;
            presentationModel = (_strand as IStrandWithPresentationModel).presentationModel as IListPresentationModel;            
		}
		        
        override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
            var style:SimpleCSSStyles = new SimpleCSSStyles();
            style.marginBottom = presentationModel.separatorThickness;
            UIBase(ir).style = style;
            UIBase(ir).height = presentationModel.rowHeight;
            UIBase(ir).percentWidth = 100;
		}

	}
}
