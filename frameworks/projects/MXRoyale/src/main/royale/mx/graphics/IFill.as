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

package mx.graphics
{
   
	import mx.display.Graphics;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
    
	public interface IFill
	{
        /**
         *  Starts the fill.
         *  
         *  @param target The target Graphics object that is being filled.
         *
         *  @param targetBounds The Rectangle object that defines the size of the fill
         *  inside the <code>target</code>.
         *  If the dimensions of the Rectangle are larger than the dimensions
         *  of the <code>target</code>, the fill is clipped.
         *  If the dimensions of the Rectangle are smaller than the dimensions
         *  of the <code>target</code>, the fill expands to fill the entire
         *  <code>target</code>.
         * 
         *  @param targetOrigin The Point that defines the origin (0,0) of the shape in the 
         *  coordinate system of target. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void;
        
        /**
         *  Ends the fill.
         *  
         *  @param target The Graphics object that is being filled. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function end(target:Graphics):void;
       
	}
}
