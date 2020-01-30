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

package org.apache.royale.display
{
	import org.apache.royale.core.UIBase;
	
	COMPILE::SWF{
		import flash.display.Graphics;
	}
	COMPILE::JS{
		import org.apache.royale.display.js.createGraphicsSVG;
	}
	
	public class UIGraphicsBase extends UIBase implements IGraphicsTarget{
		
		
		COMPILE::SWF{
			public function get graphicsRenderTarget():flash.display.Graphics{
				return graphics;
			}
		}
		
		COMPILE::JS{
			
			private var _svg:SVGSVGElement;
			
			/**
			 * @royaleignorecoercion SVGSVGElement
			 */
			public function get graphicsRenderTarget():SVGSVGElement{
				if (!_svg) {
					_svg = createGraphicsSVG('svg') as SVGSVGElement;
					_svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
					_svg.style.overflow = 'visible'; //it is hidden by default
					if (element.childNodes.length) {
						element.insertBefore(_svg, element.childNodes[0]);
					} else element.appendChild(_svg);
				}
				return _svg;
			}
			
		}
	
	}
}


