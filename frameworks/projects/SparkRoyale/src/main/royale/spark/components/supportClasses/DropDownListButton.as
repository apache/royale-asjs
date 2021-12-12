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

package spark.components.supportClasses
{
	import spark.components.Button;
	COMPILE::JS
	{
		import org.apache.royale.svg.elements.Svg;
		import org.apache.royale.svg.elements.ClipPath;
		import org.apache.royale.svg.elements.Text;
		import org.apache.royale.svg.elements.Rect;
		import org.apache.royale.svg.elements.Path;
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.svg.elements.Svg;
		import org.apache.royale.svg.elements.ClipPath;
		import org.apache.royale.svg.GraphicShape;
	}
	
	/**
	 */ 
	public class DropDownListButton extends Button
	{
		
		private static var instanceCounter:int = 0;
		
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function DropDownListButton()
		{
			instanceId = instanceCounter.toString();
			instanceCounter++;
			super();
		}
		
		private var instanceId:String;
		
		override public function setActualSize(w:Number, h:Number):void
		{
			super.setActualSize(w, h);
			COMPILE::JS
			{
				updateSkin(w, h);
			}
		}
        
		COMPILE::JS
		override public function set label(value:String):void
		{
			super.label = value;
			updateSkin(width, height);
		}
        
		COMPILE::JS
		private function updateSkin(w:Number, h:Number):void
		{
			if (h < 4) return;
			text.element.textContent = label;
			svg.width = w;
			svg.element.style.width = w + "px";
			svg.height = h;
			svg.element.style.height = h + "px";
			rect.x = w - 26;
			rect.height = h - 4;
			var d:String = 'M' + (w - 21) + ',5 L ' + (w - 13) + ',5 L ' +
				(w - 17) + ',12 L ' + (w - 21) + ',5';
			path.element.setAttribute("d",d);
			// element.innerHTML = '<svg width="' + w + 'px" height="' +
			// 	h + 'px" xmlns="http://www.w3.org/2000/svg"><clipPath id="' + clipid + '"><rect x="0" y="0" height="' + h + 
			// 	'px" width="' + (w - 29) + 'px"/></clipPath><text y="3px" clip-path="url(#' + clipid + ')">' +
			// 	label + '</text><style><![CDATA[' +
			// 	'text{ dominant-baseline: hanging;' +
			// 	/*    font: 12px Verdana, Helvetica, Arial, sans-serif;*/
			// 	'}]]></style><rect x="' +
			// 	(w - 26) + 'px" width="1px" height="' + (h - 4) + 'px"/><path d="M' +
			// 	(w - 21) + ',5 L ' + (w - 13) + ',5 L ' +
			// 	(w - 17) + ',12 L ' + (w - 21) + ',5"</path></svg>';    
				
		}

		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			svg = new Svg();
			clipPath = new ClipPath();
			var clipid:String = "txtClip" + instanceId;
			clipPath.id = clipid;
			clipRect = new Rect();
			clipRect.x = 0;
			clipRect.y = 0;
			clipPath.addElement(clipRect);
			svg.addElement(clipPath);
			text = new Text();
			text.y = 3;
			text.element.setAttribute("clip-path",'url(#' + clipid + ')');
			svg.addElement(text)
			var style:SVGStyleElement = new SVGStyleElement();
			style.innerHTML = '<![CDATA[' +
				'text{ dominant-baseline: hanging;' +
				/*    font: 12px Verdana, Helvetica, Arial, sans-serif;*/
				'}]]>';
			svg.element.appendChild(style);
			rect = new Rect();
			rect.width = 1;
			svg.addElement(rect);
			path = new Path();
			svg.addElement(path);
			return elem;
		}
		COMPILE::JS
		private var svg:Svg;
		COMPILE::JS
		private var clipPath:ClipPath;
		COMPILE::JS
		private var clipRect:Rect;
		COMPILE::JS
		private var text:Text;
		COMPILE::JS
		private var rect:Rect;
		COMPILE::JS
		private var path:Path;
		//style

		/**
		 * svg
		 *   clipPath
		 *    rect
		 *   text
		 *   style
		 *   rect
		 *   path
		 */

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function get measuredHeight():Number
		{
			return 21; // maybe measure font someday if fontSize is large
		}

	}
}