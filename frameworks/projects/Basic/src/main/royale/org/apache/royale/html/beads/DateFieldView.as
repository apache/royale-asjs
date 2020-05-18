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
    import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDateChooserModel;
    import org.apache.royale.core.IDateChooserModelWithChangeCheck;
	import org.apache.royale.core.IFormatter;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextInput;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.utils.PointUtils;
    import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.geom.Point;
    import org.apache.royale.html.beads.IComboBoxView;
	import org.apache.royale.html.supportClasses.IDateChooser;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.TextInput;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.TextInputView;
		import flash.text.TextFieldType;
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
	 *  @productversion Royale 0.0
	 */
	public class DateFieldView extends BeadViewBase implements IBeadView, IComboBoxView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DateFieldView()
		{
		}

		protected var _textInput:ITextInput;
		protected var _button:TextButton;

		/**
		 *  The TextButton that triggers the display of the DateChooser pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get popupButton():Object
		{
			return _button;
		}

		/**
		 *  The TextInput that displays the date selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get textInputField():Object
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
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            if (!_textInput)
    			_textInput = new TextInput();
			getHost().addElement(_textInput);
			_textInput.width = 100;
			_textInput.height = 18;

			_button = new TextButton();
			//_button.text = "⬇︎";
			_button.text =  "\uD83D\uDCC5"
			getHost().addElement(_button);

			COMPILE::SWF {
				_button.x = _textInput.width;
				_button.y = _textInput.y;
				var view:TextInputView = _strand.getBeadByType(IBeadView) as TextInputView;
				if(view)
					view.textField.type = TextFieldType.DYNAMIC;
			}

			COMPILE::JS
			{
				_textInput.element.setAttribute('readonly', 'true');
			}

			getHost().addEventListener("initComplete",handleInitComplete);
		}

		private function handleInitComplete(event:Event):void
		{
			_textInput.height = _button.height;

			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			IEventDispatcher(model).addEventListener("selectedDateChanged", selectionChangeHandler);
		}


		protected var _popUp:IDateChooser;

		/**
		 *  The pop-up component that holds the selection list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get popUp():Object
		{
			return _popUp;
		}

		protected var _popUpVisible:Boolean;

		/**
		 *  This property is true if the pop-up selection list is currently visible.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get popUpVisible():Boolean
		{
			return _popUpVisible;
		}
		protected var _showingPopup:Boolean;
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
                        _popUp = ValuesManager.valuesImpl.newInstance(_strand, "iPopUp") as IDateChooser;
                    }

					var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
					_popUp.selectedDate = model.selectedDate;
                    var popUpModel:IDateChooserModelWithChangeCheck = _popUp.getBeadByType(IDateChooserModelWithChangeCheck) as IDateChooserModelWithChangeCheck;
                    popUpModel.disableChangeCheck = true;

					var host:IPopUpHost = UIUtils.findPopUpHost(getHost());
					var point:Point = new Point(_textInput.width, _button.height);
					var p2:Point = PointUtils.localToGlobal(point, _strand);
					var p3:Point = PointUtils.globalToLocal(p2, host);
					_popUp.x = p3.x;
					_popUp.y = p3.y;
					COMPILE::JS {
						_popUp.element.style.position = "absolute";
					}

					host.popUpParent.addElement(_popUp);
				}
				else
				{
					UIUtils.removePopUp(_popUp);
				}
			}
			_showingPopup = false;
		}

		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			getHost().dispatchEvent(new Event("selectedDateChanged"));
			var model:IDateChooserModel = event.target as IDateChooserModel;
			var formatter:IFormatter = _strand.getBeadByType(IFormatter) as IFormatter;
			_textInput.text = formatter.format(model.selectedDate);
		}
	}
}
