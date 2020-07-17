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
package org.apache.royale.jewel.itemRenderers
{	
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.jewel.beads.itemRenderers.TableItemRendererInitializer;
	import org.apache.royale.jewel.itemRenderers.TableItemRenderer;

	/**
	 *  Note: This is just an experiment. Better use TableAlternateRowColor 
	 *  
	 *  The TableItemRendererInitializer class initializes item renderers
     *  in Table component.
	 *  
	 *  By Default this works the same as ListItemRendererInitializer, but create a placeholder
	 *  for it.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class AlternateRowColorTableItemRendererInitializer extends TableItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function AlternateRowColorTableItemRendererInitializer()
		{
		}

       /**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
        override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
        {
			var tir:TableItemRenderer = ir as TableItemRenderer;

            if (tir && ownerView)
                tir.itemRendererOwnerView = ownerView;

			var oddIndex:Boolean = tir.rowIndex % 2;
            (ir as UIBase).style = "background: rgb(" + (oddIndex ? "241, 248, 253" : "255, 255, 255") + ");";
		}
	}
}
