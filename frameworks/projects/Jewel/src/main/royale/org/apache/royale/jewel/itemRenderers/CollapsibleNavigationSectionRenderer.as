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
package org.apache.royale.jewel.itemRenderers
{
	COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.core.StyledMXMLItemRenderer;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.elements.A;
	import org.apache.royale.jewel.Navigation;
	import org.apache.royale.jewel.beads.layouts.VerticalLayout;
	import org.apache.royale.jewel.supportClasses.INavigationRenderer;
	import org.apache.royale.utils.ClassSelectorList;
	import org.apache.royale.utils.MXMLDataInterpreter;
	
	[Event(name='sectionClick',type='org.apache.royale.events.Event')]
	/**
	 *  The NavigationLinkItemRenderer defines the basic Item Renderer for a Jewel 
     *  Navigation List Component. It handles Objects with "label" and "href" data.
	 *  Extend this (you can do it in MXML) to support more data like for example: icon data.
	 * 
	 *  Note: This render creates a sub list, so we add in this class a concrete layout (VerticalLayout). So don't try
	 *  to change layout (adding via CSS, mxml beads, etc...). For layout the renderer parts, use a container (i.e: HGroup, VGroup,...)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class CollapsibleNavigationSectionRenderer extends StyledMXMLItemRenderer implements INavigationRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function CollapsibleNavigationSectionRenderer()
		{
			super();
			typeNames = "jewel navigationgroup";
			
			navLinkClassSelector = new ClassSelectorList(sectionNavItem);
			navLinkClassSelector.addNames("jewel navigationlink");
			navLinkClassSelector.add("selectable");

			open = false;
			addEventListener('click', onSectionNav);
		}
		
		private function onSectionNav(event:Event):void{
			var navTarget:Object = event.target;

			// this check should be smarter, check sectionNavItem and its childs
			if (event.target == sectionNavItem || event.target.parent == sectionNavItem || event.target.parent.parent == sectionNavItem) {
				if(children != null) {
					event.stopImmediatePropagation();
				} else {
					// avoid change event 2 times
					return;
				}
				navTarget = this;
				//make 'this' the event.target
				dispatchEvent(new Event('sectionClick'));
			}
			if (retainHover) {
				if ('hovered' in navTarget) {
					navTarget.hovered = true;
				}
			}

			// avoid double change in submenu items
			event.stopImmediatePropagation();
		}
		
		public function getSelectedSubmenuItem():Object {
			if (childNavigation) return childNavigation.selectedItem;
			return null;
		}

		private var navLinkClassSelector:ClassSelectorList;

		private var _text:String = "";
        /**
         *  The text of the navigation link
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		[Bindable('dataChange')]
		public function get text():String
		{
            return _text;
		}
		public function set text(value:String):void
		{
             _text = value;
		}
		
		private var _open:Boolean = false;
		/**
		 *  The expanded state of this navigation link
		 *  Whether or not its subMenu is visible
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		[Bindable('dataChange')]
		public function get open():Boolean
		{
			return _open;
		}
		private var _inData:Boolean;
		public function set open(value:Boolean):void
		{
			if (_open != value){
				_open = value;
				if (childNavigation) {
					COMPILE::JS
					{
					if (value) {
						childNavigation.element.style.height = childNavigation.element.scrollHeight + "px";
						
					} else {
						childNavigation.element.style.height = 0;
					}
					}
				}
				if (!_inData) dispatchEvent(new Event('dataChange'));
			}
		}
		
		/**
		* override in subclasses as a simple way to configure the nested content field
		*/
		public function get submenuField():String{
			return 'subMenu';
		}
		//override in subclass
		public function onChange(selectedItem:Object):void{
		
		}
		
		private function _onChange(event:Event):void{
			onChange(childNavigation.selectedItem);
		}
		
		
		private var children:IArrayList;
		protected var childNavigation:Navigation;

		private function processChildren():void{
			if (!childNavigation) {
				childNavigation = new Navigation();
				childNavigation.addEventListener('change', _onChange);
				childNavigation.className = childNavClassName;
				super.addElement(childNavigation);
				if (!_open) 
				{
				COMPILE::JS
				{
				childNavigation.element.style.height = 0;
				}
				}
			}
			childNavigation.dataProvider = children;
		}
		
		private var sectionNavItem:A;
		
		COMPILE::JS
		private var textNode:Text;

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *
		 *  @royaleignorecoercion org.apache.royale.collections.IArrayList
		 */
		override public function set data(value:Object):void
		{
			if(value == null) {
				_text = null;
				open = false;
				//super.data setter will dispatch dataChange
				super.data = value;
				return;
			}
			
			if (labelField)
			{
				_text = String(value[labelField]);
            }
			else if(value.label !== undefined)
			{
				_text = String(value.label);
			}
			else
			{
				_text = String(value);
			}
			// text = getLabelFromData(this, value);

			COMPILE::JS
			{
			if(textNode != null)
			{
				textNode.nodeValue = text;
			}	
			}
			
			if (submenuField in value && value[submenuField] is IArrayList){
				children = value[submenuField] as IArrayList;
				processChildren();
			} else {
				children = null;
				processChildren();
				addClass("no-submenu");
			}
			
			//super.data dispatches the dataChange
			_inData = true;
			super.data = value;
			_inData = false;
		}
		
		private var _mxmlProperties:Array ;
		
		/**
		 * @private
		 */
		override public function generateMXMLAttributes(data:Array):void
		{
			_mxmlProperties = data;
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			//skip the super class implementation and do our own.
			MXMLDataInterpreter.generateMXMLProperties(this, _mxmlProperties);
			//change the parent to not be 'this' for the mxmlContent items:
			MXMLDataInterpreter.generateMXMLInstances(this, sectionNavItem, MXMLDescriptor);
			MXMLDescriptor.length = 0;
			super.addedToParent();
			addLayoutBead();
		}

		public function addLayoutBead():void {
			var parentLayout:VerticalLayout = new VerticalLayout();
			parentLayout.itemsVerticalAlign = "itemsCentered";
			addBead(parentLayout);
		}
		
		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var nav:WrappedHTMLElement = addElementToWrapper(this, 'nav');
			sectionNavItem = new A();
			// sectionNavItem.href = href;
			if(MXMLDescriptor == null)
			{
				textNode = document.createTextNode('') as Text;
				sectionNavItem.element.appendChild(textNode)
			}
			addElement(sectionNavItem);
			processChildren();
			
            return nav;
        }
		
		private var _childNavClassName:String =  "navigation-section-group";
		//can override in subclass if needed - used to target the lower level items via css
		public function get childNavClassName():String{
			return _childNavClassName;
		}
		
		private var _retainHover:Boolean;
		//can override in subclass if needed - used to target the lower level items via css
		public function get retainHover():Boolean{
			return _retainHover;
		}
		
	}
}
