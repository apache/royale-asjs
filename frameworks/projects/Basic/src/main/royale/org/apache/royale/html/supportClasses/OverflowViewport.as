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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IContentView;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IViewportModel;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.geom.Size;
	COMPILE::SWF
	{
		import flash.geom.Rectangle;
	}

    /**
     * A OverflowViewport is the area of a Container set aside for displaying
     * content. If the content exceeds the visible area of the viewport
	 * it will show.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
     */
	public class OverflowViewport implements IBead, IViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function OverflowViewport()
		{
		}

		/**
		 * Get the actual parent of the container's content.
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
        public function get contentView():IUIBase
        {
            return _strand as IUIBase;
        }

		protected var _strand:IStrand;

		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS
			{
				(_strand as IUIBase).element.style.overflow = "visible";
			}
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
		}

	}
}
