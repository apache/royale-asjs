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
package org.apache.royale.html.test
{
	import org.apache.royale.html.Group;
	import org.apache.royale.html.Label;
	import org.apache.royale.html.beads.VerticalAlignChildren;
	import org.apache.royale.html.beads.layouts.HorizontalLayoutWithPaddingAndGap;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.html.test.models.UITestVO;
	import org.apache.royale.events.Event;


	[ExcludeClass]
	/**
	 * @private
	 */
	public class UITestItemRenderer extends DataItemRenderer
	{
		public function UITestItemRenderer()
		{
			super();
			this.typeNames = "UITestItemRenderer";
		}

		private var container:Group;
		private var icon:Label;
		private var label:Label;

		override public function addedToParent():void
		{
			super.addedToParent();

			container = new Group();
			var layout:HorizontalLayoutWithPaddingAndGap = new HorizontalLayoutWithPaddingAndGap();
			layout.gap = 8;
			layout.paddingTop = 4;
			layout.paddingBottom = 4;
			layout.paddingLeft = 8;
			layout.paddingRight = 8;
			container.addBead(layout);
			var align:VerticalAlignChildren = new VerticalAlignChildren();
			align.alignment = "middle";
			container.addBead(align);
			addElement(container);
			
			icon = new Label();
			container.addElement(icon);

			label = new Label();
			container.addElement(label);
		}

		private var _awaitingResult:Boolean;
		override public function set data(value:Object):void
		{
			if (_awaitingResult) {
				UITestVO(data).removeEventListener('ready', onResult);
				_awaitingResult = false;
			}
			super.data = value;

			var item:UITestVO = UITestVO(value);
			if(item.ignored)
			{
				icon.text = "⚪";
			}
			else if(item.failure)
			{
				icon.text = "🔴";
			}
			else if(item.active)
			{
				icon.text = "🟡"
				_awaitingResult = true;
				item.addEventListener('ready', onResult);
			}
			else
			{
				icon.text = "🟢";
			}
			label.text = item.description;
		}

		private function onResult(event:Event):void{
			var item:UITestVO = UITestVO(event.target);
			this.data = item;
		}
	}
}
