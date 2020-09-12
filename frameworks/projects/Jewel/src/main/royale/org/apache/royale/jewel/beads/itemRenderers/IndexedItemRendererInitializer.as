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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.html.beads.IPaddings;
	import org.apache.royale.html.beads.IndexedItemRendererInitializer;
	import org.apache.royale.html.beads.layouts.Paddings;

	/**
	 *  The IndexedItemRendererInitializer class initializes jewel item renderers
     *  adding paddings and other needs.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class IndexedItemRendererInitializer extends org.apache.royale.html.beads.IndexedItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function IndexedItemRendererInitializer()
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
			setPaddings(ir);
		}
		
		/**
		 * set padding for this renderer.
		 * 
		 * try to retrieve paddings from the item renderer.
		 * If not exits create one with default padding setting
		 */
		public function setPaddings(ir:IStrand):void {
			var paddings:Paddings = StyledUIBase(ir).getBeadByType(IPaddings) as Paddings;
			
			if(!paddings)
			{
				paddings = new Paddings();
				paddings.padding = DEFAULT_PADDING;
				ir.addBead(paddings)
			}
		}

		public static const DEFAULT_PADDING:Number = 8;
	}
}
