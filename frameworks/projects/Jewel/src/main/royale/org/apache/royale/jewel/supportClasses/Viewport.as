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
	import org.apache.royale.utils.loadBeadFromValuesManager;
	}
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.supportClasses.Viewport;

    /**
     *  A Viewport is the area of a Container set aside for displaying
     *  content. If the content exceeds the visible area of the viewport
	 *  it will be clipped or hidden.
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
			
			contentArea.addEventListener("initComplete", setScrollStyle);
		}
		
		/**
		 *  Subclasses override this method to change scrolling behavior.
		 *  
		 *  Since we can affect UIBase components (not only StyledUIBase)
		 *  (for example and html:Div or html:Pre)
		 *  we use className to set (we need to run computeFinalClassNames)
		 *  and classList to remove.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		COMPILE::JS
		override protected function setScrollStyle():void
		{
			contentArea.element.classList.add("viewport");

			if(_clipContent)
				contentArea.element.classList.add("clipped");
			else
				contentArea.element.classList.remove("clipped");
		}

		private var _clipContent:Boolean = true;
		/**
		 *  Whether to apply a clip mask if the positions and/or sizes of this container's children extend outside the borders of this container.
		 *  
		 *  If false, the children of this container remain visible when they are moved or sized outside the borders of this container.
		 *  If true, the children of this container are clipped.
		 *  
		 *  If clipContent is false, then scrolling is disabled for this container and scrollbars will not appear.
		 *  If clipContent is true, then scrollbars will usually appear when the container's children extend outside the border of the container. 
		 *  For additional control over the appearance of scrollbars, see horizontalScrollPolicy and verticalScrollPolicy.
		 *  
		 *  The default value is true.
		 */
		public function get clipContent():Boolean
		{
			return _clipContent;
		}
    	public function set clipContent(value:Boolean):void
		{
			if(_clipContent != value)
			{
				_clipContent = value;
				COMPILE::JS
				{
				if(contentArea)
					setScrollStyle();
				}
			}
		}
    }
}