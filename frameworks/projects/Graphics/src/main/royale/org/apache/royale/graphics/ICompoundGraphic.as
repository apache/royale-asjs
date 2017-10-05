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

package org.apache.royale.graphics
{
	public interface ICompoundGraphic extends IGraphicShape
	{
        /**
         *  Clears all of the drawn path data.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         */
		function clear():void;
		function drawRect(x:Number, y:Number, width:Number, height:Number):void;
		function drawRoundRect(x:Number, y:Number, width:Number, height:Number, radiusX:Number, radiusY:Number = NaN):void;
		function drawRoundRectComplex(x:Number, y:Number,  width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void;
		function drawRoundRectComplex2(x:Number, y:Number, width:Number, height:Number, radiusX:Number, radiusY:Number,
			topLeftRadiusX:Number, topLeftRadiusY:Number,topRightRadiusX:Number, topRightRadiusY:Number,
			bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,bottomRightRadiusX:Number, bottomRightRadiusY:Number):void;
		function drawEllipse(x:Number, y:Number, width:Number, height:Number):void;
		function drawCircle(x:Number, y:Number, radius:Number):void;
		function drawStringPath(data:String):void;
		function drawPathCommands(data:PathBuilder):void;

		function drawText(value:String, x:Number, y:Number):Object;
		function get textFill():IFill;
		function set textFill(value:IFill):void;
		function get textStroke():IStroke;
		function set textStroke(value:IStroke):void;
	}
}
