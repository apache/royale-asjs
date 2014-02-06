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
package org.apache.flex.core
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;

    /**
     *  The PopUpManager ensures that children that implement the
     *  IPopUp interface are layered over the other children.  Unlike
     *  the Flex SDK, where the PopUpManager had APIs that you had to
     *  use to add popups to the display list, this PopUpManager
     *  monitors the children in a container.  It assumes that no
     *  other container will obscure the container it is monitoring.
     *  A more sophisticated PopUpManager could handle such a 
     *  scenario, but most folks don't have overlapping top-level
     *  "windows" in their user interfaces any more so a simpler
     *  implementation will suffice for most applications.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class PopUpManager implements IDocument
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function PopUpManager()
		{
		}

        private var document:DisplayObjectContainer;
        
        /**
         *  @copy org.apache.flex.core.IDocument#setDocument()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document as DisplayObjectContainer;
            this.document.addEventListener(Event.ADDED, addedHandler);
        }
        
        private function addedHandler(event:Event):void
        {
            if (event.target != document)
                return;

            var n:int = document.numChildren;
            var lastPopUp:int = n - 1;
            
            for (var i:int = n - 1; i >= 0; i--)
            {
                var child:DisplayObject = document.getChildAt(n);
                if (child is IPopUp)
                {
                    if (i < lastPopUp)
                    {
                        document.setChildIndex(child, lastPopUp);
                        lastPopUp--;
                    }
                }
            }
        }
	}
}