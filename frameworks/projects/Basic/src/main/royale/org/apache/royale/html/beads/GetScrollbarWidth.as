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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	COMPILE::JS 
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	
    /**
     *  The GetScrollbarWidth class detects the browser's default
	 *  scrollbar width. This can be useful when changing the viewport
	 *  width to avoid it being obstructed by the scrollbar.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
	public class GetScrollbarWidth implements IBead
	{
		private var _scrollbarWidth:Number;

		public function GetScrollbarWidth()
		{
		}
		
        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
		public function set strand (value:IStrand):void
		{
			COMPILE::JS 
			{	
				var outerDiv:WrappedHTMLElement = document.createElement("div") as WrappedHTMLElement;
				document.body.appendChild(outerDiv);
				outerDiv.style.overflow = "scroll";
				outerDiv.style.width = "50px";
				var innerDiv:WrappedHTMLElement = document.createElement("div") as WrappedHTMLElement;
				innerDiv.style.width = "100%";
				outerDiv.appendChild(innerDiv);
				_scrollbarWidth = outerDiv.offsetWidth - innerDiv.offsetWidth;
				document.body.removeChild(outerDiv);
			}
		}
		
		public function get scrollbarWidth():Number
		{
			return _scrollbarWidth;
		}
	}
}

