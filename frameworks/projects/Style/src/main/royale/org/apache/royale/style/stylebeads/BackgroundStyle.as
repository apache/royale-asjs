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
package org.apache.royale.style.stylebeads
{

	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.background.BackgroundAttachment;
	import org.apache.royale.style.stylebeads.background.BackgroundColor;
	import org.apache.royale.style.stylebeads.background.BackgroundClip;
	import org.apache.royale.style.stylebeads.background.BackgroundImage;
	import org.apache.royale.style.stylebeads.background.BackgroundOrigin;
	import org.apache.royale.style.stylebeads.background.BackgroundPosition;
	import org.apache.royale.style.stylebeads.background.BackgroundRepeat;
	import org.apache.royale.style.stylebeads.background.BackgroundSize;

	public class BackgroundStyle extends CompositeStyle
	{
		public function BackgroundStyle()
		{
			super();
		}

		// private var _alpha:Number;
		// /**
		//  * The alpha value of the background, between 0 and 1.
		//  * 0 means fully transparent, 1 means fully opaque.
		//  * @langversion 3.0
		//  * @productversion Royale 0.9.13
		//  */
		// [Inspectable(category="General", defaultValue="1", minValue="0", maxValue="1")]
		// public function get alpha():Number
		// {
		// 	return _alpha;
		// }
		// public function set alpha(value:Number):void
		// {
		// 	_alpha = value;
		// }
		private var _attachment:String;
		/**
		 * Defines how the background image is attached to the component.
		 * The default value is "scroll", which means the background image will scroll with the content. 
		 * "fixed" means the background image will stay fixed in place, even when the content is scrolled. 
		 * "local" means the background image will scroll with the element's content, but not with the element itself. 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category = "General", enumeration = "scroll,fixed,local", defaultValue = "scroll")]
		public function get attachment():String
		{
			return _attachment;
		}

		public function set attachment(value:String):void
		{
			if(!attachmentStyle)
			{
				attachmentStyle = new BackgroundAttachment();
				addStyleBead(attachmentStyle);
			}
			attachmentStyle.value = _attachment = value;
		}
		private var attachmentStyle:BackgroundAttachment;
		private var _color:String;
		/**
		 * The background color of the component.
		 * This can be any valid color, but using color constants is recommended.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get color():String
		{
			return _color;
		}

		public function set color(value:String):void
		{
			if(!colorStyle)
			{
				colorStyle = new BackgroundColor();
				addStyleBead(colorStyle);
			}
			colorStyle.value = _color = value;
		}
		private var colorStyle:BackgroundColor;
		private var _clip:String;
		/**
		 * Defines the area of the background that is visible.
		 * "border-box" means the background extends to the outside edge of the border (but underneath the border in z-ordering).
		 * "padding-box" means the background extends to the outside edge of the padding (but underneath the padding in z-ordering).
		 * "content-box" means the background is painted within the content box.
		 * "text" means the background is painted only behind the text of the component, and not behind any padding or border.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[[Inspectable(category="General", enumeration="border-box,padding-box,content-box,text", defaultValue="border-box")]]
		public function get clip():String
		{
			return _clip;
		}

		public function set clip(value:String):void
		{
			_clip = value;
			if(!clipStyle)
			{
				clipStyle = new BackgroundClip();
				addStyleBead(clipStyle);
			}
			clipStyle.value = _clip;
		}
		private var clipStyle:BackgroundClip;
		//TODO gradient support
		// public var gradient:String;
		private var _image:String;
		/**
		 * The background image of the component.
		 * This can be any valid image URL or data URI.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			if(!imageStyle)
			{
				imageStyle = new BackgroundImage();
				addStyleBead(imageStyle);
			}
			imageStyle.value = _image = value;
		}
		private var imageStyle:BackgroundImage;
		private var _origin:String;
		/**
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="border-box,padding-box,content-box", defaultValue="")]
		public function get origin():String
		{
			return _origin;
		}
		public function set origin(value:String):void
		{
			if(!originStyle)
			{
				originStyle = new BackgroundOrigin();
				addStyleBead(originStyle);
			}
			originStyle.value = _origin = value;
		}
		private var originStyle:BackgroundOrigin;
		private var _position:String;
		/**
		 * Defines the position of the background image.
		 * This can be any valid CSS background-position value, such as "center", "top left", "50% 50%", etc.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function get position():String
		{
			return _position;
		}

		public function set position(value:String):void
		{
			if(!positionStyle)
			{
				positionStyle = new BackgroundPosition();
				addStyleBead(positionStyle);
			}
			positionStyle.value = _position = value;
		}
		private var positionStyle:BackgroundPosition;
		private var _repeat:String;
		/**
		 * Defines how the background image is repeated.
		 * "repeat" means the background image will be repeated both horizontally and vertically to fill the component.
		 * "repeat-x" means the background image will be repeated only horizontally.
		 * "repeat-y" means the background image will be repeated only vertically.
		 * "space" means the background image will be repeated as many times as will fit in the component, with space between the images.
		 * "round" means the background image will be repeated as many times as will fit in the component, and the images will be scaled to fit the space.
		 * "no-repeat" means the background image will not be repeated, and will only be shown once at the position defined by the position property.
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="repeat,repeat-x,repeat-y,space,round,no-repeat", defaultValue="")]
		public function get repeat():String
		{
			return _repeat;
		}

		public function set repeat(value:String):void
		{
			if(!repeatStyle)
			{
				repeatStyle = new BackgroundRepeat();
				addStyleBead(repeatStyle);
			}
			repeatStyle.value = _repeat = value;
		}
		private var repeatStyle:BackgroundRepeat;
		private var _size:String;
		/**
		 * Defines the size of the background image.
		 * "auto" means the background image will be shown at its intrinsic size.
		 * "cover" means the background image will be scaled to cover the entire component,
		 * while maintaining its aspect ratio. This may cause some cropping of the image.
		 * "contain" means the background image will be scaled to fit within the component,
		 * while maintaining its aspect ratio. This may cause some empty space within the component
		 * if the aspect ratio of the image does not match the aspect ratio of the component.
		 * 
		 * Any other valid CSS background-size value can also be used, such as "100px 50px", "50% auto", etc.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		[Inspectable(category="General", enumeration="auto,cover,contain", defaultValue="auto")]
		public function get size():String
		{
			return _size;
		}

		public function set size(value:String):void
		{
			if(!sizeStyle)
			{
				sizeStyle = new BackgroundSize();
				addStyleBead(sizeStyle);
			}
			sizeStyle.value = _size = value;
		}
		private var sizeStyle:BackgroundSize;
	}
}