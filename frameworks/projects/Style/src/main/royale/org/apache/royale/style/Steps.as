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
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
	}

	import org.apache.royale.core.IChild;

	public class Steps extends Group
	{
		public function Steps()
		{
			super();
		}

		private var _vertical:Boolean = false;

		public function get vertical():Boolean
		{
			return _vertical;
		}

		public function set vertical(value:Boolean):void
		{
			if (value != _vertical)
			{
				_vertical = value;
				if (skin) skin.update();
				propagateVertical();
			}
		}

		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			// Set vertical before super.addElement() so the Step's skin
			// initializes with the correct orientation on first render.
			var step:Step = c as Step;
			if (step)
				step.vertical = _vertical;
			super.addElement(c, dispatchEvent);
		}

		private function propagateVertical():void
		{
			for (var i:int = 0; i < numElements; i++)
			{
				var step:Step = getElementAt(i) as Step;
				if (step)
					step.vertical = _vertical;
			}
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			addElementToWrapper(this, 'ol');
			element.setAttribute("role", "list");
			return element;
		}

		override public function getWrapperStyle():String
		{
			return 'steps';
		}
	}
}
