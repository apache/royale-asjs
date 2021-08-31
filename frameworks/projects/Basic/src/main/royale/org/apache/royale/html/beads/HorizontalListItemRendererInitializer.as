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
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.html.IListPresentationModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithPresentationModel;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;

	/**
	 *  The ListItemRendererInitializer class initializes item renderers
	 *  in list classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class HorizontalListItemRendererInitializer extends IndexedItemRendererInitializer implements IIndexedItemRendererInitializer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function HorizontalListItemRendererInitializer() 
		{
		}
		
		protected var presentationModel:IListPresentationModel;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithPresentationModel
		 *  @royaleignorecoercion org.apache.royale.html.IListPresentationModel
		 */
		override public function set strand(value:IStrand):void
		{	
			super.strand = value;
			presentationModel = (_strand as IStrandWithPresentationModel).presentationModel as IListPresentationModel;			
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		override protected function setupVisualsForItemRenderer(ir:IIndexedItemRenderer):void
		{
			var style:SimpleCSSStyles = new SimpleCSSStyles();
			style.marginBottom = presentationModel.separatorThickness;
			(ir as UIBase).style = style;
			(ir as UIBase).height = presentationModel.rowHeight;
		}

	}
}
