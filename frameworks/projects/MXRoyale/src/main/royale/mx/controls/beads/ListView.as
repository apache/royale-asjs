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
	import mx.core.UIComponent;

	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.*;
	import org.apache.royale.html.supportClasses.DataItemRenderer;



	/**
	 *  The ListView class creates the visual elements of the mx.controls.List
	 *  component. A List consists of the area to display the data (in the dataGroup), any
	 *  scrollbars, and so forth.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class ListView extends org.apache.royale.html.beads.ListView
	{
		public function ListView()
		{
			super();
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			host.addEventListener("widthChanged", onHostWidthChange);

		}


		protected function onHostWidthChange(e:Event):void{
			updateAllItemRenderers();
		}

		/**
		 * @private
		 *
		 * @param ir the renderer to update
		 *
		 * @royaleignorecoercion mx.core.UIComponent
		 */
		override protected function updateItemRenderer(ir:IItemRenderer):void{
			var renderer:DataItemRenderer = ir as DataItemRenderer;
			if (renderer) {
				super.updateItemRenderer(renderer)
			} else {
				(ir as UIComponent).setWidth(host.width);
			}
		}


	}
}
