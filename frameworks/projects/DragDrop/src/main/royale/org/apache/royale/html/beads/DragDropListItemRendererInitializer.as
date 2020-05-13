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
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ILabelFieldItemRenderer;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.ItemRendererOwnerViewBead;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;

	/**
	 *  The DragDropListItemRendererInitializer class initializes item renderers
     *  with a reference to the owning List.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DragDropListItemRendererInitializer extends ListItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DragDropListItemRendererInitializer()
		{
		}
		        
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 */
		override public function set strand(value:IStrand):void
		{	
            super.strand = value;
            ownerView = (value as IStrandWithModelView).view as IItemRendererOwnerView;
		}
		
        private var ownerView:IItemRendererOwnerView;
        
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		override public function initializeItemRenderer(ir:IItemRenderer, data:Object):void
		{
            super.initializeItemRenderer(ir, data);
            ir.addBead(new ItemRendererOwnerViewBead(ownerView));
        }
	}
}
