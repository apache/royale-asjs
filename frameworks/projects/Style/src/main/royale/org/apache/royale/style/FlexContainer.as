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
package org.apache.royale.style
{
	
	import org.apache.royale.style.support.ContentContainerBase;

	/**
	 *  The FlexContainer class is a container with CSS flex display enabled.
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	
	public class FlexContainer extends ContentContainerBase
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function FlexContainer()
		{
			displayType = "flex";
			super();
		}

		private var _vertical:Boolean = false;
		
		/**
		 *  Whether the main axis is vertical.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get vertical():Boolean
		{
			return _vertical;
		}
		public function set vertical(value:Boolean):void
		{
			_vertical = value;
			computeDirection();
		}
		
		private var _reverse:Boolean;
		
		/**
		 *  Whether the current flex direction is reversed.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get reverse():Boolean
		{
			return _reverse;
		}
		public function set reverse(value:Boolean):void
		{
			_reverse = value;
			computeDirection();
		}
		private function computeDirection():void{
			var direction:String = vertical ? "column" : "row";
			if(reverse){
				direction += "-reverse";
			}
			setStyle("flexDirection",direction);
		}
		
		private var _wrap:Boolean;
		
		/**
		 *  Whether items should wrap onto multiple lines.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get wrap():Boolean
		{
			return _wrap;
		}
		public function set wrap(value:Boolean):void
		{
			_wrap = value;
			if(value){
				_reverseWrap = false;
			}
			setWrap();
		}
		
		private var _reverseWrap:Boolean;
		
		/**
		 *  Whether wrapping should use reverse order.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get reverseWrap():Boolean
		{
			return _reverseWrap;
		}
		public function set reverseWrap(value:Boolean):void
		{
			_reverseWrap = value;
			if(value){
				_wrap = false;
			}
			setWrap();
		}
		
		private function setWrap():void{
			var wrapVal:String;
			if(_wrap){
				wrapVal = "wrap";
			} else if(_reverseWrap){
				wrapVal = "wrap-reverse";
			} else {
				wrapVal = "nowrap";
			}
			setStyle("flexWrap",wrapVal);
		}

	}
}