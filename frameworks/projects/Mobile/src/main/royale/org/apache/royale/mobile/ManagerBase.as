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
package org.apache.royale.mobile
{
    import org.apache.royale.core.IChild;
	import org.apache.royale.core.IChrome;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	COMPILE::JS
	{
			import org.apache.royale.core.WrappedHTMLElement;
	}
	
	/**
	 *  The ManagerBase is a base class for mobile display managers such as StackedViewManager
	 *  and TabbedViewManager. This class encapsulates the features common to all view
	 *  managers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ManagerBase extends UIBase
	{
		/**
		 * Constructor.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function ManagerBase()
		{
			super();
            typeNames = 'ManagerBase';
			
			_contentArea = new UIBase();
			
			COMPILE::SWF {
				addEventListener("initComplete", handleInitComplete);
				addEventListener("sizeChanged", handleInitComplete);
				addEventListener("widthChanged", handleInitComplete);
				addEventListener("heightChanged", handleInitComplete);
			}
			
			COMPILE::JS {
				createElement();
			}
			
			super.addElement(_contentArea,false);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			super.createElement();
			
			_contentArea.positioner.style['width'] = '100%';
			_contentArea.positioner.style['height'] = '100%';
			
			return element;
		}
		
		private function handleInitComplete(event:Event):void
		{
			_contentArea.setWidthAndHeight(width, height, true);
			// todo: listen for changes to this item
			
			var num:Number = UIBase(_contentArea).numElements;
			for (var i:int = 0; i < num; i++) {
				var child:UIBase = UIBase(_contentArea).getElementAt(i) as UIBase;
				child.setWidthAndHeight(width, height);
			}
		}
		
		private var _contentArea:UIBase;
		
		/**
		 * The contentArea of a view manager is where the child elements are placed. Areas outside
		 * of the contentArea are chrome (identified by implementing IChrome).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get contentArea():UIBase
		{
			return _contentArea;
		}
		
		/**
		 * Adds elements to the view manager. If an element implements IChrome it is placed
		 * in the chrome area otherwise it is placed in the contentArea.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean=true):void
		{
			if (c is IChrome) {
				super.addElementAt(c,0,dispatchEvent);
			}
			else {
				_contentArea.addElement(c, dispatchEvent);
//				(c as UIBase).setWidthAndHeight(_contentArea.width, _contentArea.height, false);
//				(c as UIBase).width = _contentArea.width;
//				(c as UIBase).height = _contentArea.height;
			}
		}
		
		/**
		 * @private.
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean=true):void
		{
			if (c is IChrome) {
				super.addElementAt(c, index, dispatchEvent);
			}
			else {
				_contentArea.addElement(c, dispatchEvent);
			}
		}
		
		/**
		 * @private
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean=true):void
		{
			if (c is IChrome) {
				super.removeElement(c, dispatchEvent);
			}
			else {
				_contentArea.removeElement(c, dispatchEvent);
			}
		}
		
		/**
		 * @private
		 */
		override public function getElementAt(index:int):IChild
		{
			return _contentArea.getElementAt(index);
		}
		
		/**
		 * @private
		 */
		override public function getElementIndex(c:IChild):int
		{
			return _contentArea.getElementIndex(c);
		}
		
		/**
		 * @private
		 */
		override public function get numElements():int
		{
			return _contentArea.numElements;
		}
	}
}
