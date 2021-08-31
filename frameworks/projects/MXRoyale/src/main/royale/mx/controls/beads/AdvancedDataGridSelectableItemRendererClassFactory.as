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
    import org.apache.royale.core.IItemRenderer;   
    import org.apache.royale.core.SelectableItemRendererClassFactory;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.html.beads.controllers.ItemRendererMouseController;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;

	/**
	 *  The AdvancedDataGridItemRendererInitializer class initializes item renderers
     *  in tree classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AdvancedDataGridSelectableItemRendererClassFactory extends SelectableItemRendererClassFactory
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AdvancedDataGridSelectableItemRendererClassFactory()
		{
		}
				
        override public function createItemRenderer():IItemRenderer
        {
            var ir:IItemRenderer = super.createItemRenderer();
			ir["outerDocument"] = (_strand as AdvancedDataGridColumnList).grid.mxmlDocument;
			if (ir.getBeadByType(IBeadController) == null) {
				//add a default mouse controller for DropInRenderers that may not have a mousecontroller
				ir.addBead(new ItemRendererMouseController());
			}
			return ir;
        }		        
	}
}
