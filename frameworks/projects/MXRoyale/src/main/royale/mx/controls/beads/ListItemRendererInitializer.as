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
package mx.controls.beads
{

	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.controls.listClasses.ListData;

	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.IOwnerViewItemRenderer;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IIndexedItemRendererInitializer;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IListDataItemRenderer;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModelView;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.html.beads.ListItemRendererInitializer;
    import mx.controls.treeClasses.TreeListData;

	import mx.core.UIComponent;

	import mx.controls.beads.controllers.ItemRendererMouseController;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	/**
	 *  The TreeItemRendererInitializer class initializes item renderers
     *  in tree classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ListItemRendererInitializer extends org.apache.royale.html.beads.ListItemRendererInitializer
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
				
		private var ownerView:IItemRendererOwnerView;


		protected function getDefaultController():IBeadController{
			return new ItemRendererMouseController();
		}
		
		override public function set strand(value:IStrand):void
		{	
			super.strand = value;
            ownerView = (value as IStrandWithModelView).view as IItemRendererOwnerView;
		}

		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 *  @royaleignorecoercion org.apache.royale.core.IOwnerViewItemRenderer
		 *  @royaleignorecoercion mx.controls.listClasses.IDropInListItemRenderer
		 */
		override public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
		{
            if (!dataProviderModel)
                return;

			if (!loadBeadFromValuesManager(IBeadController, 'iBeadController', ir)) {
				ir.addBead(getDefaultController());
			}

            super.initializeIndexedItemRenderer(ir, data, index);
            
			if (ir is IOwnerViewItemRenderer)
				(ir as IOwnerViewItemRenderer).itemRendererOwnerView = ownerView;

			if (ir is IDropInListItemRenderer) {
				(ir as IDropInListItemRenderer).listData = makeListData(data,'', index);
			}
        }


		/**
		 *
		 * @royaleignorecoercion mx.controls.listClasses.ListBase
		 */
		protected function makeListData(data:Object, uid:String,
										rowNum:int):BaseListData
		{
			var listBaseOwner:ListBase = _strand as ListBase;
			return new ListData(listBaseOwner.itemToLabel(data),null, labelField, uid, listBaseOwner, rowNum);
		}


		/**
		 *
		 * @royaleignorecoercion mx.core.UIComponent
		 */
		override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void{
			super.setupVisualsForItemRenderer(ir);
			adjustItemRendererForMX(ir);
		}
		/**
		 *
		 * @royaleignorecoercion mx.core.UIComponent
		 */
		protected function adjustItemRendererForMX(ir:IIndexedItemRenderer):void{
			COMPILE::JS
			{
				if (ir is UIComponent)
				{
					(ir as UIComponent).isAbsolute = false;
					//we are using a UIComponent as a renderer, but it is too late to rely on .isAbsolute = false
					//so swap it out here:
					(ir as UIComponent).element.style.position = 'relative';
					//instead of percentWidth - use actual width, which will trigger layout:
					if (ir.parent) {
						//(ir as UIComponent).setWidth((ir.parent as UIComponent).width);
						//we need to avoid the borders:
						(ir as UIComponent).setWidth((ir.parent as UIComponent).element.clientWidth);
					}
				}
			}
		}
        
	}
}
