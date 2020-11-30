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
	}
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.core.IDateFormatter;
	import org.apache.royale.core.IFormatter;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.DateChooser;
	import org.apache.royale.jewel.DateField;
	import org.apache.royale.jewel.Table;
	import org.apache.royale.jewel.TextInput;
	import org.apache.royale.jewel.beads.controls.datefield.DateFieldMaskedTextInput;
	import org.apache.royale.jewel.beads.controls.textinput.MaxNumberCharacters;
	import org.apache.royale.jewel.beads.views.DateChooserView;
	import org.apache.royale.utils.UIUtils;

	/**
	 * The DateFieldView class is a bead for DateField that creates the
	 * input and button controls. This class also handles the pop-up
	 * mechanics.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DateFieldView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DateFieldView()
		{
		}

		private var _textInput:TextInput;
		private var _button:Button;

		/**
		 *  The TextButton that triggers the display of the DateChooser pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get menuButton():Button
		{
			return _button;
		}

		/**
		 *  The TextInput that displays the date selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get textInput():TextInput
		{
			return _textInput;
		}

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

			_textInput = new TextInput();
			
			getHost().addElement(_textInput);

			_button = new Button();
			
			COMPILE::JS {
                _button.element.setAttribute('tabindex', -1);
			}
			_button.text = "&darr;";
			getHost().addElement(_button);

			COMPILE::SWF {
				_button.x = _textInput.width;
				_button.y = _textInput.y;
				//var view:TextInputView = _strand.getBeadByType(IBeadView) as TextInputView;
				//if(view)
				//	view.textField.type = TextFieldType.DYNAMIC;
			}

			// COMPILE::JS
			// {
			// 	_textInput.element.setAttribute('readonly', 'true');
			// }

			initSize();

			getHost().addEventListener("initComplete",handleInitComplete);
		}

		public static const DEFAULT_BUTTON_WIDTH:Number = 38;
		public static const DEFAULT_WIDTH:Number = 162;

		/**
		 * Size the component at start up
		 *
		 * @private
		 */
		protected function initSize():void
		{
			_button.width = DEFAULT_BUTTON_WIDTH;

			var df:ILayoutChild = host as ILayoutChild;

			// if no width (neither px or %), set default width
			if(df.isWidthSizedToContent())
				df.width = DEFAULT_WIDTH;
			
			_textInput.percentWidth = 100;
		}

		private var model:IDateChooserModel;

		/**
		 * @royaleignorecoercion org.apache.royale.core.IDateFormatter
		 * @royaleignorecoercion org.apache.royale.jewel.DateField
		 */
		private function handleInitComplete(event:Event):void
		{
			model = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
			IEventDispatcher(model).addEventListener("selectedDateChanged", selectionChangeHandler);
			var mask:DateFieldMaskedTextInput = new DateFieldMaskedTextInput();
			_textInput.addBead(mask);
			
			var maxNumberCharacters:MaxNumberCharacters = new MaxNumberCharacters();
			maxNumberCharacters.maxlength = 10;
			_textInput.addBead(maxNumberCharacters);
			
			var formatter:IFormatter = _strand.getBeadByType(IFormatter) as IFormatter;
			var dateFormat:String = (_strand as DateField).dateFormat;
			if(dateFormat)
				(formatter as IDateFormatter).dateFormat = dateFormat;
				
			mask.formatter = formatter;
		}
		
		private function handlePopUpInitComplete(event:Event):void
		{
			getHost().dispatchEvent(new Event("dateChooserInitComplete"));
		}

		private var _popUp:DateChooser;

		/**
		 *  The pop-up component that holds the selection list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get popUp():DateChooser
		{
			return _popUp;
		}

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
		private var _showingPopup:Boolean;
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
					var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
					_popUp = new popUpClass() as DateChooser;
					
					_popUp.className = "datechooser-popup";
					_popUp.addEventListener("initComplete", handlePopUpInitComplete);
					
					_popUp.selectedDate = model.selectedDate;
					_popUp.model.dayNames = model.dayNames;
					_popUp.model.monthNames = model.monthNames;
					_popUp.model.firstDayOfWeek = model.firstDayOfWeek;

					var host:IPopUpHost = UIUtils.findPopUpHost(getHost()) as IPopUpHost;
					host.popUpParent.addElement(_popUp);
					// viewBead.popUp is DateChooser that fills 100% of browser window-> We want Table inside
					table = (popUp.view as DateChooserView).table;

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
					_popUp.removeEventListener("initComplete", handlePopUpInitComplete);
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
		 * @private
		 */
		private function selectionChangeHandler(event:Event = null):void
		{
			getHost().dispatchEvent(new Event("selectedDateChanged"));

			if(model.selectedDate == null)
			{
				if(_textInput.text.length == 10)
					_textInput.text = "";
			}
			else
			{
				var formatter:IFormatter = _strand.getBeadByType(IFormatter) as IFormatter;
				_textInput.text = formatter.format(model.selectedDate);
			}
		}

		private var table:Table;
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
				
				// Desktop width size
				if(outerWidth > ResponsiveSizes.DESKTOP_BREAKPOINT)
				{
					var origin:Point = new Point(0, _button.y + _button.height - top);
					var relocated:Point = positionInsideBoundingClientRect(_strand, table, origin);
					table.x = relocated.x;
					table.y = relocated.y;
				}
				else
				{
					table.positioner.style.left = '50%';
					table.positioner.style.top = 'calc(100% - 10px)';
				}
			}
		}
	}
}
