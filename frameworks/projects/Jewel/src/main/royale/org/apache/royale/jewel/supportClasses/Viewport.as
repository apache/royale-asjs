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
package org.apache.royale.jewel.supportClasses
{
	COMPILE::JS
	{
	import org.apache.royale.core.IContentView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	}
	import org.apache.royale.html.supportClasses.Viewport;

    /**
     * A Viewport is the area of a Container set aside for displaying
     * content. If the content exceeds the visible area of the viewport
	 * it will be clipped or hidden.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
     */
	public class Viewport extends org.apache.royale.html.supportClasses.Viewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.3
		 */
		public function Viewport()
		{
            super();
		}

        /**
		 * @royaleignorecoercion Class
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			contentArea = loadBeadFromValuesManager(IContentView, "iContentView", _strand) as UIBase;
			
			if (!contentArea)
				contentArea = value as UIBase;
			
			// contentArea.element.style.overflow = "hidden";
            contentArea.element.classList.add("viewport");
		}
    }
}