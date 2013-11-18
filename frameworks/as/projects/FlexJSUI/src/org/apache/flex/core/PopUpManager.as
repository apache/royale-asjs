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

	public class PopUpManager implements IDocument
	{
		public function PopUpManager()
		{
		}

        private var document:DisplayObjectContainer;
        
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