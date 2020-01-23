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
	COMPILE::JS
	{
	import org.apache.royale.geom.Point;
	import org.apache.royale.jewel.supportClasses.ResponsiveSizes;
	import org.apache.royale.jewel.supportClasses.util.positionInsideBoundingClientRect;
	import org.apache.royale.utils.PointUtils;
	}
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.TextInput;
	import org.apache.royale.jewel.beads.controls.combobox.IComboBoxView;
	import org.apache.royale.jewel.beads.models.IJewelSelectionModel;
	import org.apache.royale.jewel.supportClasses.combobox.ComboBoxPopUp;
	import org.apache.royale.utils.UIUtils;

	/**
	 *  The ComboBoxView class creates the visual elements of the org.apache.royale.jewel.ComboBox
	 *  component. The job of the view bead is to put together the parts of the ComboBox such as the TextInput
	 *  control and org.apache.royale.jewel.Button to trigger the pop-up.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ComboBoxView extends BeadViewBase implements IComboBoxView
	{
		public function ComboBoxView()
		{
			super();
		}

		private var _textinput:TextInput;
		/**
		 *  The TextInput component of the ComboBox.
		 *
		 *  @copy org.apache.royale.jewel.beads.controls.combobox.IComboBoxView#textinput
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get textinput():Object
		{
			return _textinput;
		}

		private var _button:Button;
		/**
		 *  The Button component of the ComboBox.
		 *
		 *  @copy org.apache.royale.jewel.beads.controls.combobox.IComboBoxView#button
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get button():Object
		{
			return _button;
		}

		private var _comboPopUp:ComboBoxPopUp;
		private var _list:List;

		/**
		 *  The pop-up list component of the ComboBox.
		 *
		 *  @copy org.apache.royale.jewel.beads.controls.combobox.IComboBoxView#popup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get popup():Object
		{
			return _comboPopUp;
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 * @royaleignorecoercion org.apache.royale.core.StyledUIBase
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			var host:StyledUIBase = _strand as StyledUIBase;

			_textinput = new TextInput();
            /*COMPILE::JS {
                _textinput.element.addEventListener('blur', handleFocusOut);
            }*/

			_button = new Button();
			COMPILE::JS {
                _button.element.setAttribute('tabindex', -1);
			}
			_button.text = '\u25BC';

			initSize();

			host.addElement(_textinput);
			host.addElement(_button);

			model = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;

			if (model is IJewelSelectionModel) {
				//do this here as well as in the controller,
				//to cover possible variation in the order of bead instantiation
				//this avoids the need to redispatch new event clones at the component level in the controller
                IJewelSelectionModel(model).dispatcher = IEventDispatcher(value);
			}
			model.addEventListener("selectionChanged", handleItemChange);
			model.addEventListener("dataProviderChanged", itemChangeAction);

			IEventDispatcher(_strand).addEventListener("sizeChanged", handleSizeChange);
		}

		private var model:IComboBoxModel;

		private var _popUpClass:Class;
		/**
		 *  Returns whether or not the pop-up is visible.
		 *
		 *  @copy org.apache.royale.jewel.beads.controls.combobox.IComboBoxView#popUpVisible
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get popUpVisible():Boolean
		{
			return _comboPopUp != null;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function set popUpVisible(value:Boolean):void
		{
			if (value) {
				if (_comboPopUp == null) {
                    if(!_popUpClass)
                    {
                        _popUpClass = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
                    }
                    _comboPopUp = new _popUpClass() as ComboBoxPopUp;
                    _comboPopUp.model = model;

                    var popupHost:IPopUpHost = UIUtils.findPopUpHost(_strand as IUIBase);
                    popupHost.popUpParent.addElement(_comboPopUp);

                    // popup is ComboBoxPopUp that fills 100% of browser window-> We want the internal List inside its view to adjust height
                    _list = (_comboPopUp.view as ComboBoxPopUpView).list;
                    // _list.model = _comboPopUp.model;

                    COMPILE::JS
                    {
					// Fix temporary: when soft keyboard opens in ios devices browser is not resized, so popup gets under the keyboard
					// this fixes the issue on iPad for now, but we need some better and more reliable way of doing this
					// if(BrowserInfo.current().formFactor == "iPad")
					// {
					// 	var fromTop:Number = _textinput.element.getBoundingClientRect().top;
					// 	if(fromTop < 720)
					// 	{
					// 		_comboPopUp.positioner.style["padding-bottom"] =  "310px";
					// 	}
					// }

					window.addEventListener('resize', autoResizeHandler, false);
                    }
                    setTimeout(prepareForPopUp,  300);

                    autoResizeHandler();
				}
			}
			else if(_comboPopUp != null) {
				UIUtils.removePopUp(_comboPopUp);
				COMPILE::JS
				{
				document.body.classList.remove("viewport");
				window.removeEventListener('resize', autoResizeHandler, false);
				}
				_comboPopUp = null;
			}
		}

		private function prepareForPopUp():void
        {
			COMPILE::JS
			{
				//check here for non-null in case popUpVisible was toggled off before timeout runs
				if (_comboPopUp != null) {
                    _comboPopUp.element.classList.add("open");
                    //avoid scroll in html
                    document.body.classList.add("viewport");
				}
			}
		}

        /**
		 * @private
		 */
		protected function handleSizeChange(event:Event):void
		{
			sizeChangeAction();
		}

		/**
		 * @private
		 */
		protected function handleItemChange(event:Event):void
		{
			itemChangeAction();
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 */
		protected function itemChangeAction(event:Event = null):void
		{
			var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
			_textinput.text = getLabelFromData(model, model.selectedItem);
		}

		/**
		 * Size the component at start up
		 *
		 * @private
		 */
		protected function initSize():void
		{
			_button.width = 39;

			if(host.width == 0 || host.width < 89)
			{
				var w:Number = host.width == 0 ? 200 : 89;
				_textinput.width = w - _button.width;
				host.width = _textinput.width + _button.width;
			} else
			{
				_textinput.width = host.width - _button.width;
			}

			_textinput.percentWidth = 100;
		}

		/**
		 * Manages the resize of the component
		 *
		 * @private
		 */
		protected function sizeChangeAction():void
		{
			host.width = _textinput.width + _button.width;
		}

		/**
		 *  Adapt the popup list to the right position taking into account
		 *  if we are in DESKTOP/TABLET screen size or in PHONE screen size
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function autoResizeHandler(event:Event = null):void
        {
			COMPILE::JS
			{
				var outerWidth:Number = document.body.getBoundingClientRect().width;
				// handle potential scrolls offsets
				var top:Number = (window.pageYOffset || document.documentElement.scrollTop)  - (document.documentElement.clientTop || 0);

				// Desktop width size
				if(outerWidth >= ResponsiveSizes.TABLET_BREAKPOINT)
				{
					//popup width needs to be set before position inside bounding client to work ok
					_list.width = _textinput.width + _button.width;

					var origin:Point = new Point(0, button.y + button.height - top);
					var relocated:Point = positionInsideBoundingClientRect(_strand, _list, origin);
					var point:Point = PointUtils.localToGlobal(origin, _strand);
					
					// by default list appear below textinput

					// if there's no enough space below, reposition above input
					if(relocated.y < point.y)
					{
						var origin2:Point = new Point(0, button.y - _list.height - top);
						var relocated2:Point = positionInsideBoundingClientRect(_strand, _list, origin2);
						_list.y = relocated2.y;
					
						//if start to cover input...
						if(_list.y == 0)
						{
							// ... reposition to the left or to right side (so we still can see the input)
							_list.x = (relocated.x + _list.width + 1 >= outerWidth) ? relocated.x - _list.width : _list.x = relocated.x + _list.width;
						}
						else
						{
							// otherwise left in the same vertical as input
							_list.x = relocated.x;
						}
					}
					else
					{
						_list.y = relocated.y;
						_list.x = relocated.x;
					}
				}
				else
				{
					_list.positioner.style["left"] = "50%";
					_list.positioner.style["top"] = "calc(100% - 10px)";
					// _list.positioner.style["width"] = "initial";
				}
			}
		}
	}
}
