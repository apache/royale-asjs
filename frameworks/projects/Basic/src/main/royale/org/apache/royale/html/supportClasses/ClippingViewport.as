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
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Size;

	COMPILE::JS
	{
		import org.apache.royale.core.IStrand;
	}
    COMPILE::SWF
    {
        import flash.geom.Rectangle;
    }

	/**
	 * The ClippingViewport extends the Viewport class and makes 
	 * sure that items extending outside the Container are hidden.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ClippingViewport extends Viewport implements IBead, IViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function ClippingViewport()
		{
		}

        /**
         * @royaleignorecoercion HTMLElement 
         */
        COMPILE::JS
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            (contentView.element as HTMLElement).style.overflow = 'hidden';
        }

        private var viewportWidth:Number;
        private var viewportHeight:Number;

        /**
         * @copy org.apache.royale.core.IViewport
         */
        override public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
        {
           super.layoutViewportBeforeContentLayout(width, height);
           viewportWidth = width;
           viewportHeight = height;
        }

        /**
         * @copy org.apache.royale.core.IViewport
         */
		override public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
            COMPILE::SWF
            {
	             //var contentSize:Size;
                do
                {
                    /*contentSize = */super.layoutViewportAfterContentLayout(contentSize);
                    if (isNaN(viewportHeight))
                        viewportHeight = contentSize.height;
                    if (isNaN(viewportWidth))
                        viewportWidth = contentSize.width;

                    var host:UIBase = UIBase(_strand);
                    var visibleWidth:Number;
                    var visibleHeight:Number;

                    var needsLayout:Boolean = false;
                    // resize content area
                    if (!isNaN(visibleWidth) || !isNaN(visibleHeight))
                    {
                        if (!isNaN(visibleWidth))
                            needsLayout = visibleWidth != contentView.width;
                        if (!isNaN(visibleHeight))
                            needsLayout = visibleHeight != contentView.height;
                        if (!isNaN(visibleWidth) && !isNaN(visibleHeight))
                            contentArea.setWidthAndHeight(visibleWidth, visibleHeight, false);
                        else if (!isNaN(visibleWidth))
                            contentArea.setWidth(visibleWidth, false);
                        else if (!isNaN(visibleHeight))
                            contentArea.setHeight(visibleHeight, false);
                    }
                    if (needsLayout)
                    {
                        var layout:IBeadLayout = host.getBeadByType(IBeadLayout) as IBeadLayout;
                        layout.layout();
                    }
                } while (needsLayout);

                var rect:Rectangle = new Rectangle(0, 0, viewportWidth,viewportHeight);
                contentArea.scrollRect = rect;

            }

		}

	}
}
