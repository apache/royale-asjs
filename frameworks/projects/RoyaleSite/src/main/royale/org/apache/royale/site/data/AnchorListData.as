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
package org.apache.royale.site.data
{	
	
    [DefaultProperty("htmlText")]
    
	/**
	 * The AnchorListData is used as data for a list of anchors,
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AnchorListData
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AnchorListData()
		{
			super();
		}
		
        private var _htmlText:String;
        
        /**
         * the html content.
         */
        public function get htmlText():String
        {
            return _htmlText;
        }
        public function set htmlText(value:String):void
        {
            _htmlText = value;
        }
        
        private var _href:String;
        
        /**
         * the href.
         */
        public function get href():String
        {
            return _href;
        }
        public function set href(value:String):void
        {
            _href = value;
        }
	}
}
