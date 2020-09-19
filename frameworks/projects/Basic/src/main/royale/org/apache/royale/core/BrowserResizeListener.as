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
package org.apache.royale.core
{
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.utils.sendStrandEvent;

    /**
     *  The BrowserResizeListener class listens for browser
     *  resizing and resizes the component accordingly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.10.0
     */
	public class BrowserResizeListener extends Bead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
		public function BrowserResizeListener()
		{
		}
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value;

            COMPILE::SWF
            {
                // TODO             
            }
            COMPILE::JS
            {
            window.addEventListener('resize', resizeHandler, false);
            }
        }
        
		/**
		 *  Make the strand send "sizeChanged" event when browser is resized
		 */
        private function resizeHandler(event:Event):void
        {
            sendStrandEvent(_strand, 'sizeChanged');
        }
	}
}
