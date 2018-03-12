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
package org.apache.royale.core
{
	
    /**
     *  The CSSClassList class is used to construct a list of class names to be applied.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.2
     * 
     */
	public class CSSClassList
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.2
         */
		public function CSSClassList()
		{
		}

        private var _list:Array;
		
        /**
         *  Adds a className to the list of classes.
         *  It only adds a name once.
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.2
         */
		public function add(className:String):void
		{
            if(!_list)
                _list = [];
            if(_list.indexOf(className) == -1)
                _list.push(className);
		}

        /**
         *  Removes a className to the list of classes
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.2
         */
		public function remove(className:String):void
		{
            if(_list)
            {
                var idx:int = _list.indexOf(className);
                if(idx != -1)
                    _list.splice(idx,1);
            }
		}

        /**
         *  returns the concatenated string of the class list
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 0.9.2
         */
		public function compute():String
		{
            return _list ? _list.join(" ") + " " : "";
		}
	}
}

