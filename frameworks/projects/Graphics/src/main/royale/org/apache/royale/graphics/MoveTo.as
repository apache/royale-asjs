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
    COMPILE::SWF
    {
        import flash.display.Graphics;
    }
    public class MoveTo implements IPathCommand
    {
        public function MoveTo(x:Number, y:Number)
        {
            _x = x;
            _y = y;
        }
        private var _x:Number;
        private var _y:Number;
        
        public function toString():String
        {
            return ["M",_x,_y].join(" ");
        }
        COMPILE::SWF
        public function execute(g:Graphics):void
        {
            g.moveTo(_x,_y);
        }
        COMPILE::JS
        public function execute(ctx:Object):void
        {
            //ctx should be a canvas context. Not sure what the type is.
            ctx.moveTo(_x,_y);
        }
        
    }
}
