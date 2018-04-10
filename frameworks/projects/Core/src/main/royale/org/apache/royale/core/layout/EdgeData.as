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
package org.apache.royale.core.layout
{

	/**
	 *  The EdgeData class is a utility class for holding four border and or padding of
	 *  a component.  We don't use a Rectangle because Rectangle likes wants a width
     *  instead of a right value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class EdgeData
	{
	    public function EdgeData()
	    {
	    }
	    
		private var _left:Number;
        private var _top:Number;
        private var _right:Number;
        private var _bottom:Number;

		public function get left():Number
		{
			return _left;
		}
		public function set left(value:Number):void
		{
            _left = value;
		}
		public function get top():Number
		{
			return _top;
		}
		public function set top(value:Number):void
		{
            _top = value;
		}
	    public function get right():Number
	    {
	        return _right;
	    }
	    public function set right(value:Number):void
	    {
            _right = value;
	    }
	    
	    public function get bottom():Number
	    {
	        return _bottom;
	    }
	    public function set bottom(value:Number):void
	    {
            _bottom = value;
	    }
        
	}


}
