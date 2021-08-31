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
package mx.controls.beads
{	
    COMPILE::SWF
    {
        import flash.display.Sprite;
    }
    import org.apache.royale.html.Button;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextInput;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.html.supportClasses.IDateChooser;
    import org.apache.royale.html.beads.DateFieldView;
    import mx.controls.TextInput;
    import org.apache.royale.core.IDateChooserModel;
    import org.apache.royale.core.IDateChooserModelWithChangeCheck;
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.utils.UIUtils;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.PointUtils;
    import mx.controls.DateField;
	
    /**
     *  The NumericStepperView class overrides the Basic
     *  NumericStepperView and sets default sizes to better 
     *  emulate Flex.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DateFieldView extends org.apache.royale.html.beads.DateFieldView
	{
        public function setFocus():void
        {
            COMPILE::SWF
            {
                var host:Sprite = getHost() as Sprite;
                host.stage.focus = host;
            }
			COMPILE::JS
			{
				(_textInput as TextInput).setFocus();
			}
        }
        
        override public function set strand(value:IStrand):void
        {
            _textInput = new TextInput();
            COMPILE::JS
            {
                (_textInput as TextInput).isAbsolute = false;
            }
            super.strand = value;
        }
        
        public function set textInputField(value:Object):void
        {
            _textInput = value as ITextInput;
        }
        
        override public function get popUp():Object
        {
            if (!_popUp)
            {
                _popUp = ValuesManager.valuesImpl.newInstance(_strand, "iPopUp") as IDateChooser;
            }
            return _popUp;
        }

		override public function set popUpVisible(value:Boolean):void
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

                    var parseFunction:Function = (_strand as DateField).parseFunction;
                    var dateField:DateField = _strand as DateField;
                    if (dateField.parseFunction)
                    {
                        _popUp.selectedDate = dateField.parseFunction(_textInput.text, dateField.formatString);
                    }
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

	}
}
