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
	
	COMPILE::JS
	/**
	 * @royaleignorecoercion SVGElement
	 */
	public function createGraphicsSVG(elementName:String, noPointerEvents:Boolean = true):SVGElement
	{
		var svgElement:SVGElement = document.createElementNS('http://www.w3.org/2000/svg', elementName) as SVGElement;
		//Graphics (emulation) has no inherent pointer-events because it is supposed to be visual only,
		//but elements inside 'defs' don't need this, so it is avoidable when not needed:
		if (noPointerEvents) svgElement.setAttribute('pointer-events', 'none');
		return svgElement;
	}
	
}


