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
package org.apache.royale.jewel.beads.views
{
	COMPILE::SWF
	{
	import flash.utils.setTimeout;
    }
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.jewel.PopUp;
    import org.apache.royale.jewel.supportClasses.popup.PopUpContent;
    import org.apache.royale.utils.UIUtils;
    import org.apache.royale.utils.loadBeadFromValuesManager;
    import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The PopUpView class is a bead for PopUp that creates the dialog
	 *  that holds the real component. This class also handles the pop-up
	 *  mechanics.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class PopUpView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function PopUpView()
		{
		}

		/**
		 * the content to be instantiated inside the popup.
		 * Instead of setup this property, it can be declared through
		 * CSS using IPopUP royale bead css selector.
		 * 
		 * this property is a proxy from the one in the strand
		 */
		public function get content():UIBase
		{
            return getHost().content;
		}
		public function set content(value:UIBase):void
		{
            getHost().content = value;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function getHost():PopUp
		{
			return _strand as PopUp;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}
		
		private var _popUp:PopUpContent;
		/**
		 *  The pop-up component that will hold the real content
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function get popUp():PopUpContent
		{
			return _popUp;
		}

		private var _showingPopup:Boolean;
		private var _popUpVisible:Boolean;
		/**
		 *  This property is true if the pop-up selection list is currently visible.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function get popUpVisible():Boolean
		{
			return _popUpVisible;
		}
		public function set popUpVisible(value:Boolean):void
		{
			// prevent resursive calls
			// setting _popUp.selectedDate below triggers a change event
			// which tries to close the popup causing a recursive call.
			// There might be a better way to resolve this problem, but this works for now...
			if(_showingPopup)
				return;
			if (value != _popUpVisible)
			{
				_showingPopup = true;
				_popUpVisible = value;
				if (value)
				{
					//create the backdrop
					_popUp = new PopUpContent();
					showPopUp();
				}
				else
				{
					hidePopUp();
					_popUp = null;
				}
			}
			_showingPopup = false;
		}

		private function showPopUp():void
		{
			UIUtils.addPopUp(_popUp, getHost());
			// viewBead.popUp is StyledUIBase that fills 100% of browser window, then we display the "iPopUp content" inside
			
			// rq = requestAnimationFrame(prepareForPopUp); // not work in Chrome/Firefox, while works in Safari, IE11, setInterval/Timer as well doesn't work right in Firefox
			setTimeout(prepareForPopUp,  300);		
		}

		private function hidePopUp():void
		{
			UIUtils.removePopUp(_popUp);
			COMPILE::JS
			{
			document.body.classList.remove("viewport");
			// window.removeEventListener('resize', autoResizeHandler, false);
			}
		}

		// COMPILE::JS
		// private var rq:int;

		private function prepareForPopUp():void
        {
			if(_popUp) {
				if(!content)
				{
					content = loadBeadFromValuesManager(UIBase, "iPopUpContent", _strand) as UIBase;
				}

				// this internal event is used in PopUpMouseController to attach listeners to content
				sendStrandEvent(_strand, "showingPopUp");
				
				_popUp.addElement(content as IChild);
				_popUp.addClass("open");

				COMPILE::JS
				{
				//avoid scroll in html
				document.body.classList.add("viewport");
				//cancelAnimationFrame(rq);
				}
			}
		}
	}
}
