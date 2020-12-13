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
package spark.components.beads
{	
	import spark.events.RendererExistenceEvent;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.core.IItemRenderer;
	import mx.core.IVisualElement;


	/**
	 *  The DataContainerView provides the visual elements for the DataContainer.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class DataContainerView extends org.apache.royale.html.beads.DataContainerView
	{
		public function DataContainerView()
		{
			super();
		}
		
		override protected function dispatchItemAdded(renderer:IItemRenderer):void
		{
			super.dispatchItemAdded(renderer);
		    var newEvent:RendererExistenceEvent = new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, false, false, renderer as IVisualElement);
		    sendStrandEvent(_strand,newEvent);
		}

	}
}
