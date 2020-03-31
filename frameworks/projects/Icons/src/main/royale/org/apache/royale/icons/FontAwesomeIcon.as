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
package org.apache.royale.icons
{
    import org.apache.royale.utils.StringUtil;

    /**
     *  Icons can be used alone or in buttons and other controls 
     * 
     *  This class could be used with any icon family out there and with
     *  its text property
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public class FontAwesomeIcon extends FontIconBase
    {
        /**
         *  constructor.
         * 
         *  <inject_html>
	     *   <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	     *  </inject_html>
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function FontAwesomeIcon()
        {
            super();

            typeNames = "fonticon fa";
        }

        protected var _type:String;

        public function get type():String
        {
            return _type;
        }
		public function set type(value:String):void
		{
			COMPILE::JS
            {
            element.classList.remove(value);
            }

            _type = value;

            COMPILE::JS
            {
            element.classList.add(_type);
            }
		}
    }
}
