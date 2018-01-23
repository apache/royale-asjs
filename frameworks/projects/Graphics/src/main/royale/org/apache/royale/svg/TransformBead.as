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
package org.apache.royale.svg
{
	import org.apache.royale.core.TransformBeadBase;
	import org.apache.royale.geom.Matrix;

	public class TransformBead extends TransformBeadBase
	{
		/**
		 * @royaleignorecoercion HTMLElement
		 */
		COMPILE::JS
		override public function transform():void
		{
			if (!transformModel || !transformModel.matrix)
			{
				return;
			}			
			var element:org.apache.royale.core.WrappedHTMLElement = host.transformElement;
			(element.parentNode as HTMLElement).setAttribute("overflow", "visible");
			(element.parentNode as HTMLElement).setAttribute("pointer-events", "none");
			element.setAttribute("pointer-events", "visiblePainted");
			var fjsm:Matrix = transformModel.matrix;
			var matrixArray:Array = [fjsm.a , fjsm.b, fjsm.c, fjsm.d, fjsm.tx, fjsm.ty];
			var transformStr:String = "matrix(" + matrixArray.join(",") + ")";
			element.setAttribute("transform", transformStr);
		}

	}
}
