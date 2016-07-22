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

package org.apache.flex.graphics
{
	public interface ICompoundGraphic extends IGraphicShape
	{
		function clear():void;
		function drawRect(x:Number, y:Number, width:Number, height:Number):void;
		function drawEllipse(x:Number, y:Number, width:Number, height:Number):void;
		function drawCircle(x:Number, y:Number, radius:Number):void;
		function drawPath(data:String):void;
		function drawText(value:String, x:Number, y:Number):Object;
		function get textColor():IFill;
		function set textColor(value:IFill):void;
	}
}