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
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IIndexedItemRenderer;
    import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
COMPILE::SWF {
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
}
COMPILE::JS {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.events.BrowserEvent;
	import goog.events.Event;
	import goog.events.EventType;
	import goog.events;
}    
    import org.apache.royale.html.beads.controllers.ItemRendererMouseController;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.utils.sendEvent;
	import mx.controls.treeClasses.TreeItemRenderer;
	    
	/**
	 *  The TreeItemRendererMouseController class handles mouse events for item renderers
     *  in tree classes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TreeItemRendererMouseController extends ItemRendererMouseController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TreeItemRendererMouseController()
		{
		}
				
		/**
		 * @private
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		COMPILE::JS
		override protected function handleMouseClick(event:BrowserEvent):void
		{
			var target:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (target)
			{
				if (target is TreeItemRenderer)
				{
					var expandIcon:IUIBase = (target as TreeItemRenderer).disclosureIcon;
					if (event.target == expandIcon)
					{
						var expandEvent:ItemClickedEvent = new ItemClickedEvent("itemExpanded");
						expandEvent.data = target.data;
						expandEvent.index = target.index;
						sendEvent(target,expandEvent);
						return;
					}
				}
				var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
				newEvent.data = target.data;
				newEvent.index = target.index;

				sendEvent(target,newEvent);
			}
		}
		        
	}
}
