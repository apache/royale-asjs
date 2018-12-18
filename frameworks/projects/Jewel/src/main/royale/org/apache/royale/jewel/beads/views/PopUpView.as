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
		//import org.apache.royale.jewel.beads.views.TextInputView;
		import flash.text.TextFieldType;
		import flash.utils.setTimeout;
    }
	
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Point;
	import org.apache.royale.jewel.supportClasses.ResponsiveSizes;
	import org.apache.royale.jewel.supportClasses.util.positionInsideBoundingClientRect;
    import org.apache.royale.utils.UIUtils;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.jewel.PopUp;
    import org.apache.royale.utils.loadBeadFromValuesManager;
    import org.apache.royale.core.IPopUp;
    import org.apache.royale.core.IChild;

	/**
	 * The PopUpView class is a bead for DateField that creates the
	 * input and button controls. This class also handles the pop-up
	 * mechanics.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class PopUpView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function PopUpView()
		{
		}

		private var _content:UIBase;

		public function get content():UIBase
		{
			if(!_content){
				_content = loadBeadFromValuesManager(UIBase, "iPopUp", _strand) as UIBase;
				_content.className="jewel popupcontent";
			}

            return _content;
		}
		// public function set content(value:IPopUp):void
		// {
		// 	_content = value;
		// }
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function getHost():UIBase
		{
			return _strand as UIBase;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}
		
		private var _popUp:StyledUIBase;
		/**
		 *  The pop-up component that will hold the real content
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get popUp():StyledUIBase
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
		 *  @productversion Royale 0.9.4
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
					_popUp = new StyledUIBase();
					_popUp.className = "popup-content";
					_popUp.addElement(content as IChild);
					//_popUp.addEventListener("initComplete", handlePopUpInitComplete);
					
					var host:IPopUpHost = UIUtils.findPopUpHost(getHost()) as IPopUpHost;
					host.popUpParent.addElement(_popUp);
					// viewBead.popUp is StyledUIBase that fills 100% of browser window-> We want "iPopUp content" inside
					// daysTable = (popUp.view as DateChooserView).daysTable;
					//PopUp(_strand).content = (popUp.view as PopUpView).content

					// rq = requestAnimationFrame(prepareForPopUp); // not work in Chrome/Firefox, while works in Safari, IE11, setInterval/Timer as well doesn't work right in Firefox
					setTimeout(prepareForPopUp,  300);

					COMPILE::JS
					{
					window.addEventListener('resize', autoResizeHandler, false);
					}

					autoResizeHandler();
				}
				else
				{
					UIUtils.removePopUp(_popUp);
					COMPILE::JS
					{
					document.body.classList.remove("viewport");
					window.removeEventListener('resize', autoResizeHandler, false);
					}
					//_popUp.removeEventListener("initComplete", handlePopUpInitComplete);
					_popUp = null;
				}
			}
			_showingPopup = false;
		}

		// COMPILE::JS
		// private var rq:int;
		private function prepareForPopUp():void
        {
			_popUp.addClass("open");
			COMPILE::JS
			{
				//avoid scroll in html
				document.body.classList.add("viewport");
				//cancelAnimationFrame(rq);
			}
		}

		/**
		 *  When set to "auto" this resize handler monitors the width of the app window
		 *  and switch between fixed and float modes.
		 * 
		 *  Note:This could be done with media queries, but since it handles open/close
		 *  maybe this is the right way
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		private function autoResizeHandler(event:Event = null):void
        {
			COMPILE::JS
			{
				var outerWidth:Number = document.body.getBoundingClientRect().width;
				// handle potential scrolls offsets
				var top:Number = (window.pageYOffset || document.documentElement.scrollTop)  - (document.documentElement.clientTop || 0);
				
				var internalComponent:UIBase = content as UIBase;
				// Desktop width size
				if(outerWidth > ResponsiveSizes.DESKTOP_BREAKPOINT)
				{
					var origin:Point = new Point(0, top);//_button.y + _button.height - top);
					var relocated:Point = positionInsideBoundingClientRect(_strand, internalComponent, origin);
					internalComponent.x = relocated.x;
					internalComponent.y = relocated.y;
				}
				else
				{
					internalComponent.positioner.style.left = '50%';
					internalComponent.positioner.style.top = 'calc(100% - 10px)';
				}
			}
		}
	}
}
