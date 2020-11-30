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

package spark.components.beads
{
    import spark.core.IViewport;

    /**
     *  @private
     *  The viewport that loads a Spark Skin.
     */
    public class SparkSkinWithClipAndEnableScrollingViewport extends SparkSkinScrollingViewport
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function SparkSkinWithClipAndEnableScrollingViewport()
        {
            super();
        }

        /**
         * Subclasses override this method to change scrolling behavior
         */
        COMPILE::JS
        override protected function setScrollStyle():void
        {
            var viewPort:IViewport = contentArea as IViewport;
            if (viewPort != null)
            {
                //Make sure that initial state of clipAndEnableScrolling is preserved
                if (!viewPort.clipAndEnableScrolling)
                {
                    contentArea.element.style.overflow = "visible";
                    return;
                }
            }

            contentArea.element.style.overflow = "auto";
        }
    }
}
