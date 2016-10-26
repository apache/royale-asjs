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
	import org.apache.flex.core.IContentView;
	import org.apache.flex.core.UIBase;
    import org.apache.flex.events.Event;
	
    /**
     *  The ContainerContentArea class implements the contentView for
     *  a Container.  Container's don't always parent their children directly as
     *  that makes it harder to handle scrolling.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ContainerContentArea extends UIBase implements IContentView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ContainerContentArea()
		{
			super();
            addEventListener("layoutNeeded", forwardEventHandler);
		}
        
        private function forwardEventHandler(event:Event):void
        {
            if (parent)
                parent.dispatchEvent(event);
        }
		
		/**
		 *  @copy org.apache.flex.core.IItemRendererParent#removeAllElements()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function removeAllElements():void
		{
			COMPILE::SWF
			{
				removeChildren(0);					
			}
			COMPILE::JS
			{
				while (element.hasChildNodes()) 
				{
					element.removeChild(element.lastChild);
				}
			}
		}
	}
}
