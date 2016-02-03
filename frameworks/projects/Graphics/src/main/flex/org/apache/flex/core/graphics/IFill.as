/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.flex.core.graphics
{
    COMPILE::AS3
    {
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }

	public interface IFill
	{
        COMPILE::AS3
		function begin(s:GraphicShape,targetBounds:Rectangle, targetOrigin:Point):void;
        COMPILE::AS3
		function end(s:GraphicShape):void;
        COMPILE::JS
        function addFillAttrib(s:GraphicShape):String;
	}
}