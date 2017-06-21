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
package org.apache.flex.html.beads
{	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDateChooserModel;
	import org.apache.flex.core.IFormatBead;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IPopUpHost;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.utils.UIUtils;
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.geom.Point;
	import org.apache.flex.html.DateChooser;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.html.TextInput;
	
	/**
	 * The DateFieldView class is a bead for DateField that creates the
	 * input and button controls. This class also handles the pop-up 
	 * mechanics.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateFieldView extends BeadViewBase implements IBeadView
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
		override public function set strand(value:IStrand):void
		{	
			super.strand = value;
			
			_textInput = new TextInput();
			UIBase(_strand).addElement(_textInput);
			_textInput.width = 100;
			_textInput.height = 18;
			
			_button = new TextButton();
			_button.text = "⬇︎";
			UIBase(_strand).addElement(_button);
			
			COMPILE::SWF {
				_button.x = _textInput.width;
				_button.y = _textInput.y;
			}
			
			IEventDispatcher(_strand).addEventListener("initComplete",handleInitComplete);
		}
		
		private function handleInitComplete(event:Event):void
		{
			var formatter:IFormatBead = _strand.getBeadByType(IFormatBead) as IFormatBead;
			formatter.addEventListener("formatChanged",handleFormatChanged);
			_textInput.height = _button.height;
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
		 *  @productversion FlexJS 0.0
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
						_popUp = new DateChooser();
						_popUp.width = 210;
						_popUp.height = 230;
					}
					
					var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
					_popUp.selectedDate = model.selectedDate;
					
					var host:IPopUpHost = UIUtils.findPopUpHost(UIBase(_strand));
					var point:Point = new Point(_textInput.width, _button.height);
					var p2:Point = PointUtils.localToGlobal(point, _strand);
					var p3:Point = PointUtils.globalToLocal(p2, host);
					_popUp.x = p3.x;
					_popUp.y = p3.y;
					COMPILE::JS {
						_popUp.element.style.position = "absolute";
					}
					
					host.addElement(_popUp);
				}
				else
				{
					UIUtils.removePopUp(_popUp);
				}
			}
		}
	}
}
