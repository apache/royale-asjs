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
	}
	import org.apache.royale.events.Event;

	[Event(name="openChanged", type="org.apache.royale.events.Event")]

	public class Modal extends Group
	{
		public function Modal()
		{
			super();
		}

		private var _open:Boolean = false;

		public function get open():Boolean
		{
			return _open;
		}

		public function set open(value:Boolean):void
		{
			if (value != _open)
			{
				_open = value;
				COMPILE::JS
				{
					if (element)
					{
						var dialog:HTMLDialogElement = element as HTMLDialogElement;
						if (value)
							dialog.showModal();
						else
							dialog.close();
					}
				}
				dispatchEvent(new Event("openChanged"));
			}
		}

		private var _easyDismiss:Boolean = false;

		public function set easyDismiss(value:Boolean):void
		{
			_easyDismiss = value;
		}

		override protected function getTag():String
		{
			return "dialog";
		}

		override public function getWrapperStyle():String
		{
			return 'modal';
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();

			element.addEventListener("close", handleDialogClose);
			element.addEventListener("click", handleDialogClick);

			return elem;
		}

		COMPILE::JS
		private function handleDialogClose(event:Object):void
		{
			if (_open)
			{
				_open = false;
				dispatchEvent(new Event("openChanged"));
			}
		}

		COMPILE::JS
		private function handleDialogClick(event:Object):void
		{
			if (_easyDismiss && event.target === element)
			{
				(element as HTMLDialogElement).close();
			}
		}
	}
}
