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
    public interface IStroke
    {
        COMPILE::SWF
        function apply(s:IGraphicShape):void;
        
        COMPILE::JS
        function get weight():Number;
        
        COMPILE::JS
        function addStrokeAttrib(s:IGraphicShape):String;

        function get lineCap():String;
        function set lineCap(val:String):void;
        function get lineJoin():String;
        function set lineJoin(val:String):void;
        function get miterLimit():Number;
        function set miterLimit(val:Number):void;
        function get lineDash():Array;
        function set lineDash(val:Array):void;

    }
}
