/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.display.js
{
	
	
	/**
	 * @royalesuppressexport
	 * Intended for internal emulation use only. non-reflectable
	 *
	 * This is an internal class for storing graphics content that is referenced elsewhere.
	 * It is not intended for direct display, but must be part of the DOM. Contents can be referenced elsewhere
	 * for actual display (such as svg 'use', for example).
	 */
	COMPILE::JS
	public class JSRuntimeGraphicsStore
	{
		private static var _instance:JSRuntimeGraphicsStore;
		public static function getInstance():JSRuntimeGraphicsStore{
			return _instance || (new JSRuntimeGraphicsStore());
		}
		
		public function JSRuntimeGraphicsStore(){
			if (_instance) throw new Error('singleton only');
			_instance = this;
			setupStorage();
		}
		
		private var storageRoot:HTMLDivElement;
		private var svgDefs:SVGElement;
		
		/**
		 * @royaleignorecoercion HTMLDivElement
		 * @royaleignorecoercion CSSStyleDeclaration
		 */
		private function setupStorage():void{
			storageRoot = document.createElement('div') as HTMLDivElement;
			var styles:CSSStyleDeclaration = storageRoot.style as CSSStyleDeclaration;
			styles.position = 'fixed';
			styles.visibility = 'hidden';
			styles.top = '5000px';
			styles.left = '5000px';
			styles.width = '0';
			styles.height = '0';
			styles.margin = '0';
			styles.padding = '0';
			styles.border = 'none';
			styles.userSelect = 'none';
			var svg:SVGElement = createGraphicsSVG('svg');
			svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
			svg.setAttribute('xmlns:html', 'http://www.w3.org/1999/xhtml');
			svg.setAttribute('xmlns:xlink','http://www.w3.org/1999/xlink');
			svgDefs = createGraphicsSVG('defs', false);
			svg.appendChild(svgDefs);
			storageRoot.appendChild(svg);
			//document.body.appendChild(storageRoot);
			//todo verify 'outside' body is OK here, otherwise revert to 'normal' line above:
			document.body.parentNode.appendChild(storageRoot);
		}
		
		/**
		* @royaleignorecoercion SVGImageElement
		*/
		public function addBitmapDataImpl(element:HTMLCanvasElement):SVGImageElement{
			storageRoot.appendChild(element);
			var imgElement:SVGImageElement =  createGraphicsSVG('image', false) as SVGImageElement;
			imgElement.setAttributeNS(null, 'id', 'impl-'+element.getAttributeNS(null, 'id'));
			//the following two are not needed on Chrome and Firefox, but are needed for IE11, Edge and Safari
			imgElement.setAttributeNS(null, 'width', element.getAttributeNS(null, 'width'));
			imgElement.setAttributeNS(null, 'height', element.getAttributeNS(null, 'height'));
			//the following two are not needed on Chrome, Firefox, IE11, or Edge but are needed for Safari
			imgElement.setAttributeNS(null, 'x', "0");
			imgElement.setAttributeNS(null, 'y', "0");
			svgDefs.appendChild(imgElement);
			return imgElement;
		}
		
		public function removeBitmapDataImpl(element:HTMLCanvasElement, imgElement:SVGImageElement):void{
			storageRoot.removeChild(element);
			svgDefs.removeChild(imgElement);
		}
		
		public function addGraphicsImpl(element:SVGElement):void{
			svgDefs.appendChild(element);
		}
		
		public function removeGraphicsImpl(element:SVGElement):void{
			svgDefs.removeChild(element);
		}
		
    }
	
}


