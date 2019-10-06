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
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 *  The KeepComboPopupWithinParentBounds can be used with ComboBox to make sure its popup does not
	 *  overflow its parent bounds.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 9.6
	 */
	public class KeepComboPopupWithinParentBounds implements IBead
	{
		public function KeepComboPopupWithinParentBounds()
		{
		}
		
		private var _strand:IStrand;
		
		protected var viewBead:IComboBoxView;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			var popupHost:IPopUpHost = UIUtils.findPopUpHost(_strand as IUIBase);
			(popupHost.popUpParent as IEventDispatcher).addEventListener("childrenAdded", childrenAddedHandler);
		}
		
		private function childrenAddedHandler(event:ValueEvent):void
		{
			if (viewBead == null) {
				viewBead = loadBeadFromValuesManager(IComboBoxView, "iBeadView", _strand) as IComboBoxView;
			}
			if (event.value == viewBead.popUp)
			{
				movePopUp();
			}
		}

		protected function movePopUp():void
		{
			var popup:IUIBase = viewBead.popUp as IUIBase;
			var button:IUIBase = viewBead.popupButton as IUIBase;
			var popupParent:IUIBase = popup.parent as IUIBase;
			// fix bottom right corner
			var innerWidth:Number;
			var innerHeight:Number;
			COMPILE::JS
			{
				innerWidth = window.innerWidth;
				innerHeight = window.innerHeight;
			}
			var isRightOutOfBounds:Boolean = popup.x + popup.width > popupParent.width;
			var isBottomOutOfBounds:Boolean = popup.y + popup.height > popupParent.height;
			if (!isBottomOutOfBounds && !isRightOutOfBounds)
			{
				return;
			}
			var origin:Point = new Point(0, button.y);
			var relocated:Point = PointUtils.localToGlobal(origin,_strand);
			if (isRightOutOfBounds)
			{
				popup.x = relocated.x - popup.width + (_strand as IUIBase).width;
			}
			if (isBottomOutOfBounds)
			{
				popup.y = relocated.y - popup.height;
			}
			// currently, the default is to go down and rignt so the above should be enough
			// when that changes we can modify or extends this bead
		}
	}
}
