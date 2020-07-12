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
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.ISelectable;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.array.rangeCheck;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.core.DispatcherBead;

	/**
	 * The change event is dispatched whenever the selection changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
    [Event(name="change", type="org.apache.royale.events.Event")]
	
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
	public class SingleSelectionContainerBead extends DispatcherBead
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
		
		/**
     * @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 */
		private function get host():IParentIUIBase
		{
			return _strand as IParentIUIBase;
		}
		
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			_elements = [];
			listenOnStrand("childrenAdded",handleItemAdded);
			listenOnStrand("childrenRemoved",handleItemRemoved);
			addListenersToChildren();
		}
		/**
     * @royaleemitcoercion org.apache.royale.core.ISelectable
		 * 
     * @royaleignorecoercion org.apache.royale.core.IParent
     * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function addListenersToChildren():void
		{
			var parent:IParent = _strand as IParent;
			var numElements:int = parent.numElements;
			_elements = [];
			for(var i:int = 0; i < numElements ; i++)
			{
				var elem:ISelectable = parent.getElementAt(i) as ISelectable;
				if(elem)
				{
					(elem as IEventDispatcher).addEventListener("change",handleChange);
					_elements.push(elem);
				}
			}
			normalizeSelection();
		}

		private var _selectedIndex:int = -1;
		/**
		 *  The index of the currently selected item. Changing this value
		 *  also changes the selectedItem property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		[Bindable("change")]
        public function get selectedIndex():int
		{
			return rangeCheck(_selectedIndex,_elements) ? _selectedIndex : -1;
		}
		public function set selectedIndex(value:int):void
		{
			// The selectedIndex can be set before it's added to the strand (i.e. in mxml)
			if(!_elements)
			{
				_selectedIndex = value;
				return;
			}
			assert(!_selectionRequired || rangeCheck(value,_elements), "When selectionRequired is true, a valid index must be set");
			assert(value < _elements.length,"index is out of range");
			if(value < 0)
			{
				_selectedIndex = -1;
				normalizeSelection();
			}
			else if(value != _selectedIndex)
			{
				var elem:ISelectable = _elements[value];
				elem.selected = true;
			}
		}

		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		[Bindable("change")]
		public function get selectedItem():ISelectable
		{
			// var selection:ISelectable;
			// if(rangeCheck(_selectedIndex,_elements))
			// 	return _elements[_selectedIndex];
			
			// normalizeSelection();
			return rangeCheck(_selectedIndex,_elements) ? _elements[_selectedIndex] : null;
			
		}
		public function set selectedItem(value:ISelectable):void
		{
			var idx:int = _elements.indexOf(value);
			assert(idx != -1,"The specified element is not valid");
			if(idx != _selectedIndex)
				value.selected = true;
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

		private var _elements:Array;

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
			_selectedIndex = -1;
			var component:IParentIUIBase = event.target as IParentIUIBase;
			var elem:ISelectable = component as ISelectable;
			var isSelected:Boolean = elem.selected;
			var parent:IParent = _strand as IParent;
			var numElements:int = _elements.length;
			for(var i:int = 0; i < numElements ; i++)
			{
				elem = _elements[i] as ISelectable;
				if(elem)
				{
					if(elem == component)
					{
						if(selectionRequired)
							elem.selected = true;
						if(elem.selected)
							_selectedIndex = i;
					}
					else if(isSelected)
						elem.selected = false;
				}
			}
			_handlingChange = false;
			dispatchEvent(new Event("change"));
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function handleItemAdded(ev:ValueEvent):void
		{
			if(ev.value)
			{
				var elem:ISelectable = ev.value as ISelectable;
				if(elem)
				{
					(elem as IEventDispatcher).addEventListener("change",handleChange);
					normalizeElements();
					if(elem.selected)
						selectedItem = elem;
					else
						normalizeSelection();
				}
			}
			else
				addListenersToChildren();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function handleItemRemoved(ev:ValueEvent):void
		{
			(ev.value as IEventDispatcher).removeEventListener("change",handleChange);
			normalizeElements();
			normalizeSelection();
		}

		private function normalizeElements():void
		{
			var i:int;
			_elements = [];
			COMPILE::SWF
			{

			}

			COMPILE::JS
			{
				// optimized so we don't have to get an array each step of the loop.
				var internalChildren:Array = host.internalChildren();
				for(i = 0; i < internalChildren.length; i++){
					if(internalChildren[i] is ISelectable)
						_elements.push(internalChildren[i]);
				}

			}
		}

		private function normalizeSelection():void
		{
			var idx:int = -1;
			var i:int;
			var elem:ISelectable;
			for(i=0;i<_elements.length;i++)
			{
				elem = _elements[i];
				if(idx != -1)
					elem.selected = false;
				else if(elem.selected)
				{
					idx = _selectedIndex = i;
				}
			}
			if(idx == -1 && _selectionRequired && _elements.length)
			{
				if(rangeCheck(_selectedIndex,_elements))
				{
					elem = _elements[_selectedIndex];
					elem.selected = true;
				}
				else
					selectedIndex = 0;
			}
		}
		
	}
}
