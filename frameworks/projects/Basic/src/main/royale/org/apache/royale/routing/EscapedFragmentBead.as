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
package org.apache.royale.routing
{
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
	
	/**
	 *  The EscapedFragmentBead class handles a special URL parameter that
     *  Google Search Crawlers use to verify search results.  This
     *  technique is deprecated so use of this bead should be
     *  obsolete by 2nd quarter 2018.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */

	public class EscapedFragmentBead extends URLParameterBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function EscapedFragmentBead()
		{
		}
		
        // supposedly, Google's crawler sends a hash bang fragment with this
        // as the url param to verify that the page really did want the
        // hash bang fragment indexed.  If the contents returned is the same
        // as the hash bang then the page is indexed.
        // https://webmasters.googleblog.com/2017/12/rendering-ajax-crawling-pages.html
        private static const token:String = "?_escaped_fragment_="
            
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
            COMPILE::JS
            {
                if (location.search.indexOf(token) != -1)
                    dispatchEvent(new Event("ready"));
            }
            COMPILE::SWF
            {
                //TODO (aharui) SWF impl
            }
		}
		
		override public function get urlParameters():String
		{
			COMPILE::JS
			{
				var s:String = location.search;
                var c:int = s.indexOf(token);
                if (c != -1)
                    s = s.substring(c + token.length);
                return s;
			}
			COMPILE::SWF
			{
				return null; //TODO (aharui) SWF impl
			}
		}		
	}
}
