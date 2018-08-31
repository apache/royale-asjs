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
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IDateChooserModel;
    import org.apache.royale.core.IFormatBead;
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.jewel.Button;
    import org.apache.royale.jewel.DateChooser;
    import org.apache.royale.jewel.TextInput;
    import org.apache.royale.jewel.beads.controls.datefield.DateFieldMaskedTextInput;
    import org.apache.royale.jewel.beads.controls.textinput.MaxNumberCharacters;
    import org.apache.royale.utils.UIUtils;
	COMPILE::SWF
	{
		//import org.apache.royale.jewel.beads.views.TextInputView;
		import flash.text.TextFieldType;
		import flash.utils.setTimeout;
    }

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
			_textInput.addBead(new DateFieldMaskedTextInput());
			
			var maxNumberCharacters:MaxNumberCharacters = new MaxNumberCharacters();
			maxNumberCharacters.maxlength = 10;
			_textInput.addBead(maxNumberCharacters);
			
			getHost().addElement(_textInput);

			_button = new Button();
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

			getHost().addEventListener("initComplete",handleInitComplete);
		}

		private function handleInitComplete(event:Event):void
		{
			var formatter:IFormatBead = _strand.getBeadByType(IFormatBead) as IFormatBead;
			formatter.addEventListener("formatChanged",handleFormatChanged);

			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			IEventDispatcher(model).addEventListener("selectedDateChanged", selectionChangeHandler);
		}
		
		private function handlePopUpInitComplete(event:Event):void
		{
			getHost().dispatchEvent(new Event("dateChooserInitComplete"));
		}

		private function handleFormatChanged(event:Event):void
		{
			var formatter:IFormatBead = event.target as IFormatBead;
			_textInput.text = formatter.formattedString;
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
					if (!_popUp)
					{
						_popUp = new DateChooser();
					}

					_popUp.className = "datechooser-popup";
					_popUp.addEventListener("initComplete", handlePopUpInitComplete);

					var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
					_popUp.selectedDate = model.selectedDate;
					_popUp.model.dayNames = model.dayNames;
					_popUp.model.monthNames = model.monthNames;
					_popUp.model.firstDayOfWeek = model.firstDayOfWeek;


					var host:IPopUpHost = UIUtils.findPopUpHost(getHost()) as IPopUpHost;
					// var point:Point = new Point(_textInput.width, _button.height);
					// var p2:Point = PointUtils.localToGlobal(point, _strand);
					// var p3:Point = PointUtils.globalToLocal(p2, host);
					// _popUp.x = p3.x;
					// _popUp.y = p3.y;

					host.popUpParent.addElement(_popUp);
					
					
					// rq = requestAnimationFrame(prepareForPopUp); // not work in Chrome/Firefox, while works in Safari, IE11, setInterval/Timer as well doesn't work right in Firefox
					setTimeout(prepareForPopUp,  300);
				}
				else
				{
					UIUtils.removePopUp(_popUp);
					COMPILE::JS
					{
					document.body.classList.remove("remove-app-scroll");
					}
					_popUp.removeEventListener("initComplete", handlePopUpInitComplete);
					_popUp = null;
				}
			}
			_showingPopup = false;
		}

		COMPILE::JS
		private var rq:int;
		private function prepareForPopUp():void
        {
			//avoid scroll in html
			_popUp.addClass("open");
			COMPILE::JS
			{
				//cancelAnimationFrame(rq);
				document.body.classList.add("remove-app-scroll");
			}
		}

		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event = null):void
		{
			getHost().dispatchEvent(new Event("selectedDateChanged"));
			getHost().dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
