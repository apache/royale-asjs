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
package mx.text
{
	/**
	 *  This class holds text related styles
	 *  See: 
	 *  See: 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class TextFormat
	{
		
        public function TextFormat(font:String = null,
                                    size:Object = null,
                                    color:Object = null,
                                    bold:Object = null,
                                    italic:Object = null,
                                    underline:Object = null,
                                    align:String = null,
                                    leftMargin:Object = null,
                                    rightMargin:Object = null)
        {
            this.font = font;
            this.size = size;
            this.color = color;
            this.bold = bold;
            this.italic = italic;
            this.underline = underline;
            this.align = align;
            this.leftMargin = leftMargin;
            this.rightMargin = rightMargin;
        }

        public var align:String;
        public var bold:Object;
        public var color:Object;
        public var font:String;
        public var italic:Object;
        public var leading:Object;
        public var leftMargin:Object;
        public var rightMargin:Object;
        public var size:Object;
        public var underline:Object;
	}
}
