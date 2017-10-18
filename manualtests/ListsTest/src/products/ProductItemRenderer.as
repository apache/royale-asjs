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
package products
{	
	import org.apache.royale.html.Label;
	import org.apache.royale.html.Image;
	import org.apache.royale.html.supportClasses.DataItemRenderer;

	public class ProductItemRenderer extends DataItemRenderer
	{
		public function ProductItemRenderer()
		{
			super();
		}
		
		private var image:Image;
		private var title:Label;
		private var detail:Label;
		
		override public function addedToParent():void
		{
			super.addedToParent();
			
			// add an image and two labels
			image = new Image();
			addElement(image);
			
			title = new Label();
			addElement(title);
			
			detail = new Label();
			addElement(detail);
		}
		
		override public function get data():Object
		{
			return super.data;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			image.src = data.image;
			title.text = data.title;
			detail.text = data.detail;
		}
		
		override public function adjustSize():void
		{
			var cy:Number = this.height/2;
			
			image.x = 4;
			image.y = cy - 16;
			image.width = 32;
			image.height = 32;
			
			title.x = 40;
			title.y = cy - 16;
			
			detail.x = 40;
			detail.y = cy;
			
			updateRenderer();
		}
	}
}
