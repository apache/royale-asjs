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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.ISelectable;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 * Use SingleSelectionContainerBead is a bead which manages selection state of a component
	 * which contains a group of ISelectables. One such example would be a toggle button bar.
	 * 
	 * Only one of the elements can be selected at any one time.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class SingleSelectionContainerBead implements IBead
	{		
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function SingleSelectionContainerBead()
		{
			super();
		}
		
		protected var _strand:IStrand;
		
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			host.addEventListener("childrenAdded",handleItemAdded);
			host.addEventListener("childrenRemoved",handleItemRemoved);
			addListenersToChildren();
		}

		private function addListenersToChildren():void
		{
			var parent:IParent = _strand as IParent;
			var numElements:int = parent.numElements;
			for(var i:int = 0; i < numElements ; i++)
			{
				var elem:ISelectable = parent.getElementAt(i) as ISelectable;
				if(elem)
					(elem as IEventDispatcher).addEventListener("change",handleChange);
			}
		}

		/**
		 *  If selectionRequired is true, one element is always selected
		 *  and clicking on a selected element does not deselect it.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		private var _selectionRequired:Boolean = true;
		public function get selectionRequired():Boolean
		{
			return _selectionRequired;
		}

		public function set selectionRequired(value:Boolean):void
		{
			_selectionRequired = value;
		}

		private var _handlingChange:Boolean;
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function handleChange(event:Event):void
		{
			//prevent nested events
			if(_handlingChange)
				return;
			
			_handlingChange = true;
			var component:IUIBase = event.target as IUIBase;
			var parent:IParent = _strand as IParent;
			var numElements:int = parent.numElements;
			for(var i:int = 0; i < numElements ; i++)
			{
				var elem:ISelectable = parent.getElementAt(i) as ISelectable;
				if(elem)
				{
					if(elem == component)
					{
						if(selectionRequired)
							elem.selected = true;
					}
					else
						elem.selected = false;
				}
			}
			_handlingChange = false;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function handleItemAdded(ev:ValueEvent):void
		{
			if(ev.value)
				(ev.value as IEventDispatcher).addEventListener("change",handleChange);
			else
				addListenersToChildren();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function handleItemRemoved(ev:ValueEvent):void
		{
			(ev.value as IEventDispatcher).removeEventListener("change",handleChange);
		}
		
	}
}
