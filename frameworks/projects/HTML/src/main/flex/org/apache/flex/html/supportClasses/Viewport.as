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
package org.apache.flex.html.supportClasses
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IContentView;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
    import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
    import org.apache.flex.geom.Rectangle;
    import org.apache.flex.geom.Size;
	import org.apache.flex.html.beads.models.ScrollBarModel;
    import org.apache.flex.utils.CSSContainerUtils;
	COMPILE::SWF
	{
		import flash.geom.Rectangle;
	}

    /**
     * A Viewport is the area of a Container set aside for displaying
     * content. If the content exceeds the visible area of the viewport
	 * it will be clipped or hidden.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
     */
	public class Viewport implements IBead, IViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.0
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
	     *  @productversion FlexJS 0.0
		 */
        public function get contentView():IUIBase
        {
            return contentArea;
        }

		protected var _strand:IStrand;

        /**
         * @flexjsignorecoercion Class
         */
		COMPILE::SWF
		public function set strand(value:IStrand):void
		{
			_strand = value;
            contentArea = _strand.getBeadByType(IContentView) as UIBase;
            if (!contentArea)
            {
                var c:Class = ValuesManager.valuesImpl.getValue(_strand, 'iContentView') as Class;
                contentArea = new c() as UIBase;
            }
		}
		
		/**
		 * @flexjsignorecoercion Class
		 */
		COMPILE::JS
		public function set strand(value:IStrand):void
		{
			_strand = value;
			contentArea = value as UIBase;
			contentArea.element.style.overflow = "hidden";
		}

        /**
         * @copy org.apache.flex.core.IViewport#setPosition()
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.0
         */
        public function setPosition(x:Number, y:Number):void
        {
			COMPILE::SWF {
            	contentArea.x = x;
            	contentArea.y = y;
			}
        }

        /**
         * @copy org.apache.flex.core.IViewport#layoutViewportBeforeContentLayout()
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.0
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
         * @copy org.apache.flex.core.IViewport#layoutViewportAfterContentLayout()
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.0
         */
		public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
			COMPILE::SWF {
				var hostWidth:Number = UIBase(_strand).width;
				var hostHeight:Number = UIBase(_strand).height;
				
				var rect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, hostWidth, hostHeight);
				contentArea.$sprite.scrollRect = rect;
				
				return;
			}
		}

	}
}
