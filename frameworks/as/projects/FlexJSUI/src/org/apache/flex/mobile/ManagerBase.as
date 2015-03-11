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
package org.apache.flex.mobile
{
	import org.apache.flex.core.IChrome;
	import org.apache.flex.core.UIBase;
	
	/**
	 *  The ManagerBase is a base class for mobile display managers such as StackedViewManager
	 *  and TabbedViewManager. This class encapsulates the features common to all view
	 *  managers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ManagerBase extends UIBase
	{
		/**
		 * Constructor.
	     *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.0
		 */
		public function ManagerBase()
		{
			super();
			
			_contentArea = new UIBase();
			super.addElement(_contentArea,false);
		}
		
		private var _contentArea:UIBase;
		
		/**
		 * The contentArea of a view manager is where the child elements are placed. Areas outside
		 * of the contentArea are chrome (identified by implementing IChrome).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
		 */
		override public function addElement(c:Object, dispatchEvent:Boolean=true):void
		{
			if (c is IChrome) {
				super.addElementAt(c,0,dispatchEvent);
			}
			else {
				(c as UIBase).width = _contentArea.width;
				(c as UIBase).height = _contentArea.height;
				_contentArea.addElement(c, dispatchEvent);
			}
		}
		
		/**
		 * @private.
		 */
		override public function addElementAt(c:Object, index:int, dispatchEvent:Boolean=true):void
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
		override public function removeElement(c:Object, dispatchEvent:Boolean=true):void
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
		override public function getElementAt(index:int):Object
		{
			return _contentArea.getElementAt(index);
		}
		
		/**
		 * @private
		 */
		override public function getElementIndex(c:Object):int
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