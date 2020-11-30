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
package org.apache.royale.html.supportClasses
{
	COMPILE::SWF
	{
	import flash.geom.Rectangle;
	import org.apache.royale.geom.Rectangle;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.geom.Size;


    /**
     * A Viewport is the area of a Container set aside for displaying
     * content. If the content exceeds the visible area of the viewport
	 * it will be clipped or hidden.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
     */
	public class Viewport extends EventDispatcher implements IBead, IViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function Viewport()
		{
		}

		protected var contentArea:UIBase;

		/**
		 * Get the actual parent of the container's content.
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
        public function get contentView():IUIBase
        {
            return contentArea;
        }

		protected var _strand:IStrand;

        /**
         * @royaleignorecoercion Class
         */
		COMPILE::SWF
		public function set strand(value:IStrand):void
		{
			_strand = value;
			var c:Class = ValuesManager.valuesImpl.getValue(value, "iContentView") as Class;
			if (c)
			{
				contentArea = new c() as UIBase;
			}
		}
		
		/**
		 * @royaleignorecoercion Class
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var f:Class = ValuesManager.valuesImpl.getValue(value, "iContentView");
			if (f)
			{
				contentArea = new f() as UIBase;
			}
			
			if (!contentArea)
				contentArea = value as UIBase;
			setScrollStyle();
		}
		/**
		 * Subclasses override this method to change scrolling behavior
		 */
		COMPILE::JS
		protected function setScrollStyle():void
		{
			contentArea.element.style.overflow = "hidden";
		}

        /**
         * @copy org.apache.royale.core.IViewport#setPosition()
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
         */
        public function setPosition(x:Number, y:Number):void
        {
			COMPILE::SWF {
            	contentArea.x = x;
            	contentArea.y = y;
			}
        }

        /**
         * @copy org.apache.royale.core.IViewport#layoutViewportBeforeContentLayout()
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
         */
		public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
		{
			COMPILE::SWF {
			if (!isNaN(width))
                contentArea.width = width;
            if (!isNaN(height))
                contentArea.height = height;
			}
		}

        /**
         * @copy org.apache.royale.core.IViewport#layoutViewportAfterContentLayout()
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
         */
		public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
			COMPILE::SWF {
				var hostWidth:Number = UIBase(_strand).width;
				var hostHeight:Number = UIBase(_strand).height;
				
				var rect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, hostWidth, hostHeight);
				contentArea.scrollRect = rect;
				
				return;
			}
		}

	}
}
