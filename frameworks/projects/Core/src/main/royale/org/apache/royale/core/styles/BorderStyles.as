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
package org.apache.royale.core.styles
{

	/**
	 *  The BorderStyles class is a utility class for getting the
     *  3 main border styles (width, color, style)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BorderStyles
	{
	    public function BorderStyles()
	    {
	    }
	    
        private var _style:String;

        public function get style():String
        {
            return _style;
        }
        public function set style(value:String):void
        {
            _style = value;
        }
        
        private var _color:uint;
        
        public function get color():uint
        {
            return _color;
        }
        public function set color(value:uint):void
        {
            _color = value;
        }

        private var _width:Number;
        
        public function get width():Number
        {
            return _width;
        }
        public function set width(value:Number):void
        {
            _width = value;
        }

	}


}
