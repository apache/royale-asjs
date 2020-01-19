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
package org.apache.royale.html
{
	import org.apache.royale.html.Group;

    public class NodeElementBase extends Group
    {
        public function NodeElementBase()
        {
            super();

            typeNames = "";
        }

        COMPILE::SWF
        {
            private var _nodeValue:String;
        }
		public function get nodeValue():String
		{
            COMPILE::SWF
            {
                return _nodeValue;
            }
            COMPILE::JS
            {
    			return element.nodeValue;
            }
		}

		public function set nodeValue(value:String):void
		{
            COMPILE::SWF
            {
                _nodeValue = value;
            }
            COMPILE::JS
            {
    			element.nodeValue = value;
            }
			
		}

        public function get class():String
        {
            COMPILE::SWF
            {
                return "";
            }
            COMPILE::JS
            {
            	return element.getAttribute("class");
            }
        }

        public function set class(value:String):void
        {
            COMPILE::JS
            {
            	element.setAttribute("class",value);
            }
        }
        COMPILE::SWF
        protected var _attributes_:Object = {};
        public function setAttribute(name:String,value:String):void
        {
            COMPILE::JS
            {
            	element.setAttribute(name,value);
            }
            COMPILE::SWF
            {
                _attributes_[name] = value;
            }
            
        }
        public function getAttribute(name:String):String
        {
            COMPILE::JS
            {
            	return element.getAttribute(name);
            }
            COMPILE::SWF
            {
                return _attributes_[name];
            }
        }
    }
}