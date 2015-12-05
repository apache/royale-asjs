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
package org.apache.flex.createjs.core
{
    COMPILE::AS3
    {
        import flash.display.DisplayObject;            
    }
	
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.utils.MXMLDataInterpreter;
	
	[DefaultProperty("mxmlContent")]
	public class ViewBase extends UIBase implements IParent
	{
		public function ViewBase()
		{
			super();
		}
		
		public function initUI(model:Object):void
		{
			_applicationModel = model;
			dispatchEvent(new Event("modelChanged"));
            /* AJH needed?
			MXMLDataInterpreter.generateMXMLProperties(this, MXMLProperties);
            */
			MXMLDataInterpreter.generateMXMLInstances(this, this, MXMLDescriptor);
		}
		
		public function get MXMLDescriptor():Array
		{
			return null;
		}
		
        /*
		public function get MXMLProperties():Array
		{
			return null;
		}
		*/
        
		public var mxmlContent:Array;
		
		private var _applicationModel:Object;
		
		[Bindable("modelChanged")]
		public function get applicationModel():Object
		{
			return _applicationModel;
		}
        
        COMPILE::AS3
        public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            addChild(c as DisplayObject);
        }

        COMPILE::AS3
        public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            addChildAt(c as DisplayObject, index);
        }
        
        COMPILE::AS3
        public function getElementAt(index:int):Object
        {
            return getChildAt(index);
        }
        
        COMPILE::AS3
        public function getElementIndex(c:Object):int
        {
            return getChildIndex(c as DisplayObject);
        }
        
        COMPILE::AS3
        public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            removeChild(c as DisplayObject);
        }
        
        COMPILE::AS3
        public function get numElements():int
        {
            return numChildren;
        }

	}
}
