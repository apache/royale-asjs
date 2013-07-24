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
package org.apache.flex.html.staticControls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IChrome;
	import org.apache.flex.core.IContainer;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	
    [Event(name="change", type="org.apache.flex.events.Event")]
    
	[DefaultProperty("mxmlContent")]
	public class Container extends UIBase implements IContainer
	{
		public function Container()
		{
			super();
			actualParent = this;
		}
		
		public var mxmlContent:Array;

		private var actualParent:DisplayObjectContainer;
		
		public function setActualParent(parent:DisplayObjectContainer):void
		{
			actualParent = parent;	
		}
		
        override public function getElementIndex(c:Object):int
        {
            if (c is IUIBase)
                return actualParent.getChildIndex(IUIBase(c).element as DisplayObject);
            else
                return actualParent.getChildIndex(c as DisplayObject);
        }

        override public function addElement(c:Object):void
        {
            if (c is IUIBase)
            {
				if (c is IChrome ) {
					addChild(IUIBase(c).element as DisplayObject);
					IUIBase(c).addedToParent();
				}
				else {
                	actualParent.addChild(IUIBase(c).element as DisplayObject);
                	IUIBase(c).addedToParent();
				}
            }
            else {
				if (c is IChrome) {
					addChild(c as DisplayObject);
				}
				else {
					actualParent.addChild(c as DisplayObject);
				}
			}
        }
        
        override public function addElementAt(c:Object, index:int):void
        {
            if (c is IUIBase)
            {
				if (c is IChrome) {
					addChildAt(IUIBase(c).element as DisplayObject, index);
					IUIBase(c).addedToParent();
				}
				else {
                	actualParent.addChildAt(IUIBase(c).element as DisplayObject, index);
                	IUIBase(c).addedToParent();
				}
            }
            else {
				if (c is IChrome) {
					addChildAt(c as DisplayObject, index);
				} else {
                	actualParent.addChildAt(c as DisplayObject, index);
				}
			}
        }
        
        override public function removeElement(c:Object):void
        {
            if (c is IUIBase)
                actualParent.removeChild(IUIBase(c).element as DisplayObject);
            else
                actualParent.removeChild(c as DisplayObject);
        }
        
        public function getChildren():Array
		{
			var children:Array = [];
			var n:int = actualParent.numChildren;
			for (var i:int = 0; i < n; i++)
				children.push(actualParent.getChildAt(i));
			return children;
		}

		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
	}
}