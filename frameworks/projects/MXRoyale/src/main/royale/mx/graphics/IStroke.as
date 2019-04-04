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
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Rectangle;
    import mx.display.Graphics;
    public interface IStroke
    {
        function apply(s:Graphics, targetBounds:Rectangle = null, targetOrigin:Point = null):void;
        
        //----------------------------------
        //  weight
        //----------------------------------
        
        /**
         *  The line weight, in pixels.
         *  For many chart lines, the default value is 1 pixel.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        function get weight():Number;
        
        /**
         *  @private
         */
        function set weight(value:Number):void;

    }
}
