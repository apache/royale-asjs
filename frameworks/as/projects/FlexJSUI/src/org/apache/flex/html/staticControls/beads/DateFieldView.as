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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDateChooserModel;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IPopUpHost;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.DateChooser;
	import org.apache.flex.html.staticControls.TextButton;
	import org.apache.flex.html.staticControls.TextInput;
	
	/**
	 * The DateFieldView class is a bead for DateField that creates the
	 * input and button controls. This class also handles the pop-up 
	 * mechanics.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateFieldView implements IBeadView
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DateFieldView()
		{
		}
		
		private var _strand:IStrand;
		
		private var _textInput:TextInput;
		private var _button:TextButton;
		
		/**
		 *  The TextButton that triggers the display of the DateChooser pop-up.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get menuButton():TextButton
		{
			return _button;
		}
		
		/**
		 *  The TextInput that displays the date selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get textInput():TextInput
		{
			return _textInput;
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{	
			_strand = value;
			
			_textInput = new TextInput();
			IParent(_strand).addElement(_textInput);
			_textInput.width = 100;
			_textInput.height = 18;
			
			
			_button = new TextButton();
			_button.text = "M";
			IParent(_strand).addElement(_button);
			_button.x = _textInput.width;
			_button.y = _textInput.y;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("viewChanged"));
		}
		
		private var _popUp:IStrand;
		
		/**
		 *  The pop-up component that holds the selection list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get popUp():IStrand
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
		 *  @productversion FlexJS 0.0
		 */
		public function get popUpVisible():Boolean
		{
			return _popUpVisible;
		}
		public function set popUpVisible(value:Boolean):void
		{
			if (value != _popUpVisible)
			{
				_popUpVisible = value;
				if (value)
				{
					if (!_popUp)
					{
						var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
						_popUp = new popUpClass() as IStrand;
						UIBase(_popUp).width = 210;
						UIBase(_popUp).height = 220;
					}
					
					var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
					DateChooser(_popUp).selectedDate = model.selectedDate;
					
					var root:Object = DisplayObject(_strand).root;
					var host:DisplayObjectContainer = DisplayObject(_strand).parent;
					while (host && !(host is IPopUpHost))
						host = host.parent;
					if (host)
						IPopUpHost(host).addElement(popUp);
				}
				else
				{
					DisplayObject(_popUp).parent.removeChild(_popUp as DisplayObject);                    
				}
			}
		}
	}
}