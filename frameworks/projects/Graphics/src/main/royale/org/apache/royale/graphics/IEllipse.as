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
	public interface IEllipse extends IGraphicShape
	{

		/**
		 * The horizontal radius of the ellipse.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.7
		 */
		function get rx():Number;
		function set rx(value:Number):void;
		/**
		 * The vertical radius of the ellipse.
		 * 
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.7
		 */
		function get ry():Number;
		function set ry(value:Number):void;
		/**
         *  Draw the ellipse. (The same behavior as the default draw() method, but requires specifying the x and y explicitly.)
         *  @param xp The x position of the top-left corner of the bounding box of the ellipse.
         *  @param yp The y position of the top-left corner of the bounding box of the ellipse.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.8
		 */
		function drawEllipse(xp:Number, yp:Number):void;
		
	}
}
