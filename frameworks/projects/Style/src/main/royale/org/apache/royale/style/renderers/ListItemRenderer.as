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
package org.apache.royale.style.renderers
{
	import org.apache.royale.style.DataItemRenderer;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.core.IParent;
	import org.apache.royale.style.Icon;
	import org.apache.royale.style.data.IListData;
	import org.apache.royale.style.elements.Img;

	public class ListItemRenderer extends ListItemRendererBase
	{
		public function ListItemRenderer()
		{
			super();
		}
		private var _listData:Object;

		[Bindable("__NoChangeEvent__")]

		/**
		 *  Additional data about the list structure the itemRenderer may
		 *  find useful.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 */
		public function get listData():Object
		{
			return _listData;
		}
		public function set listData(value:Object):void
		{
			_listData = value;
		}
		protected var firstElementPosition:Number = 0;
		protected function get iconParent():IParent
		{
			return this;
		}
		override public function set data(value:Object):void
		{
			super.data = value;
			setText(getLabelFromData(this, value));
			COMPILE::JS
			{
				var iconSelector:String = getIconSelector();
				if (iconSelector)
				{
					if (icon)
					{
						iconParent.removeElement(icon);
					}
					icon = new Icon(iconSelector);
					// TODO apply styles to icon
					iconParent.addElementAt(icon, firstElementPosition);
				}
				else if (icon)
				{
					icon.setStyle("display", "none");
				}

				var iconSrc:String = getImageIcon();
				if (iconSrc)
				{
					if (!imageIcon)
					{
						imageIcon = new Img();
						imageIcon.src = iconSrc;
						// TODO apply styles to imageIcon
						iconParent.addElementAt(imageIcon, firstElementPosition);
					}
					else
					{
						imageIcon.setStyle("display", null);
						imageIcon.src = iconSrc;
					}
				}
				else if (imageIcon)
				{
					imageIcon.setStyle("display", "none");
				}
			}
		}
		COMPILE::JS
		protected var textNode:Text;
		protected function setText(value:String):void
		{
			COMPILE::JS
			{
				if (textNode == null)
				{
					textNode = document.createTextNode('') as Text;
					element.appendChild(textNode);
				}

				textNode.nodeValue = value;
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.data.IListItem
		 */
		private function getIconSelector():String
		{
			if (data is IListData)
			{
				return (data as IListData).icon;
			}
			return data["icon"];
		}
		private function getImageIcon():String
		{
			if (data is IListData)
			{
				return (data as IListData).imageIcon;
			}
			return data["imageIcon"];
		}
		protected var icon:Icon;
		protected var imageIcon:Img;

	}
}