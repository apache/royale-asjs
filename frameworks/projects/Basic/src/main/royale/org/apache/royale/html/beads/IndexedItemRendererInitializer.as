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
	import org.apache.royale.core.ILabelFieldItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The IndexedItemRendererInitializer class initializes item renderers
	 *  in list classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class IndexedItemRendererInitializer extends Bead implements IIndexedItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function IndexedItemRendererInitializer()
		{
		}
		
		protected var dataProviderModel:IDataProviderModel;
		protected var labelField:String;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			labelField = dataProviderModel.labelField;			
		}
		
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.ILabelFieldItemRenderer
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		public function initializeItemRenderer(ir:IItemRenderer, data:Object):void
		{
			if (ir is ILabelFieldItemRenderer)
				(ir as ILabelFieldItemRenderer).labelField = labelField;
			
			setupVisualsForItemRenderer(ir as IIndexedItemRenderer);
		}
		
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
		 */
		public function initializeIndexedItemRenderer(ir:IIndexedItemRenderer, data:Object, index:int):void
		{
			ir.index = index;
			initializeItemRenderer(ir, data);
			sendStrandEvent(_strand, "rendererInitizalized");
		}
		
		protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
		{
		}

	}
}
