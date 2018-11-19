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
package org.apache.royale.utils
{
    COMPILE::SWF
    {
        import flash.display.DisplayObject;
        import flash.geom.Point;
	    import flash.display.Stage;
    }

    import org.apache.royale.core.IUIBase;
    import org.apache.royale.geom.Point;

	/**
	 *  The PointUtils class is a collection of static functions that convert
     *  Points between coordinate spaces.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PointUtils
	{
		/**
		 * @private
		 */
		public function PointUtils()
		{
			throw new Error("PointUtils should not be instantiated.");
		}

		/**
		 *  Converts a point from global coordinates to local coordinates
		 *
		 *  @param point The point being converted.
		 *  @param local The component used as reference for the conversion.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
		 */
		public static function globalToLocal( pt:org.apache.royale.geom.Point, local:Object ):org.apache.royale.geom.Point
		{
            COMPILE::SWF
            {
                var fpt:flash.geom.Point = DisplayObject(local.$displayObject).globalToLocal(new flash.geom.Point(pt.x,pt.y));
                return new org.apache.royale.geom.Point(fpt.x, fpt.y);
            }
            COMPILE::JS
            {
                var x:Number = pt.x;
                var y:Number = pt.y;
                var element:HTMLElement = local.element as HTMLElement;
				if ( element.getBoundingClientRect ) {// TODO take scrollbar widths into account
					var rect:Object = element.getBoundingClientRect();
					x = x - rect.left - window.pageXOffset;//window.scrollX doesn't work on IE11
					y = y - rect.top - window.pageYOffset;//window.scrollY doesn't work on IE11
				} else { // for older browsers, but offsetParent is soon to be deprecated from chrome

                    do {
                        x -= element.offsetLeft;
                        y -= element.offsetTop;
                        if (local['parent'] !== undefined) {
                            local = local.parent;
                            element = local ? local.element as HTMLElement : null;
                        } else {
                            element = null;
                        }
                    }
                    while (element);
                }
                return new org.apache.royale.geom.Point(x, y);

            }
		}

        /**
         *  Converts a point from local coordinates to global coordinates
         *
         *  @param point The point being converted.
         *  @param local The component used as reference for the conversion.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
         */
        public static function localToGlobal( pt:org.apache.royale.geom.Point, local:Object ):org.apache.royale.geom.Point
        {
            COMPILE::SWF
            {
				if (local is Stage)
				{
					return pt;
				}
                var fpt:flash.geom.Point = DisplayObject(local.$displayObject).localToGlobal(new flash.geom.Point(pt.x,pt.y));
                return new org.apache.royale.geom.Point(fpt.x, fpt.y);
            }
            COMPILE::JS
            {
                var x:Number = pt.x;
                var y:Number = pt.y;
                var element:HTMLElement = local.element as HTMLElement;
                if ( element.getBoundingClientRect ) {// TODO take scrollbar widths into account
                	var rect:Object = element.getBoundingClientRect();
					x = rect.left + x + window.pageXOffset;//window.scrollX doesn't work on IE11
                	y = rect.top + y + window.pageYOffset;//window.scrollY doesn't work on IE11
                } else { // for older browsers, but offsetParent is soon to be deprecated from from chrome
	                do {
	                    x += element.offsetLeft;
	                    y += element.offsetTop;
	                    element = element.offsetParent as HTMLElement;
	                }
                	while (element);
				}
                return new org.apache.royale.geom.Point(x, y);
            }
        }
	}
}
