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
	import org.apache.flex.core.IAlertModel;
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.createjs.staticControls.Label;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Alert;
	import org.apache.flex.html.staticControls.ControlBar;
	import org.apache.flex.html.staticControls.TextButton;
	import org.apache.flex.html.staticControls.TitleBar;
	
	public class AlertBead implements IAlertBead
	{
		public function AlertBead()
		{
		}
		
		private var _titleBar:TitleBar;
		private var _controlBar:ControlBar;
		private var _label:Label;
		private var _okButton:TextButton;
		private var _cancelButton:TextButton;
		private var _yesButton:TextButton;
		private var _noButton:TextButton;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var flags:uint = IAlertModel(UIBase(_strand).model).flags;
			if( flags & Alert.OK ) {
				_okButton = new TextButton();
				_okButton.initModel();
				_okButton.text = IAlertModel(UIBase(_strand).model).okLabel;
				_okButton.initSkin();
				_okButton.addEventListener("click",handleOK);
			}
			if( flags & Alert.CANCEL ) {
				_cancelButton = new TextButton();
				_cancelButton.initModel();
				_cancelButton.text = IAlertModel(UIBase(_strand).model).cancelLabel;
				_cancelButton.initSkin();
				_cancelButton.addEventListener("click",handleCancel);
			}
			if( flags & Alert.YES ) {
				_yesButton = new TextButton();
				_yesButton.initModel();
				_yesButton.text = IAlertModel(UIBase(_strand).model).yesLabel;
				_yesButton.initSkin();
				_yesButton.addEventListener("click",handleYes);
			}
			if( flags & Alert.NO ) {
				_noButton = new TextButton();
				_noButton.initModel();
				_noButton.text = IAlertModel(UIBase(_strand).model).noLabel;
				_noButton.initSkin();
				_noButton.addEventListener("click",handleNo);
			}
			
			_titleBar = new TitleBar();
			_titleBar.initModel();
			_titleBar.title = IAlertModel(UIBase(_strand).model).title;
			_titleBar.initSkin();
			
			_label = new Label();
			_label.initModel();
			_label.text = IAlertModel(UIBase(_strand).model).message;
			_label.initSkin();
			
			_controlBar = new ControlBar();
			_controlBar.initModel();
			_controlBar.initSkin();
			if( _okButton ) _okButton.addToParent(_controlBar);
			if( _cancelButton ) _cancelButton.addToParent(_controlBar);
			if( _yesButton  ) _yesButton.addToParent(_controlBar);
			if( _noButton ) _noButton.addToParent(_controlBar);
			
			_titleBar.addToParent(_strand);
			_controlBar.addToParent(_strand);
			_label.addToParent(_strand);
			
			sizeHandler(null);
		}
		
		private function sizeHandler(event:Event):void
		{
			var labelMeasure:IMeasurementBead = _label.measurementBead;
			var titleMeasure:IMeasurementBead = _titleBar.measurementBead;
			var ctrlMeasure:IMeasurementBead  = _controlBar.measurementBead;
			var maxWidth:Number = Math.max(titleMeasure.measuredWidth, ctrlMeasure.measuredWidth, labelMeasure.measuredWidth);
			
			var borderThickness:Object = ValuesManager.valuesImpl.getValue(_strand,"border-thickness");
			var borderOffset:Number;
			if( borderThickness == null ) {
				borderOffset = 0;
			}
			else {
				borderOffset = Number(borderThickness);
				if( isNaN(borderOffset) ) borderOffset = 0;
			}
			
			_titleBar.x = borderOffset;
			_titleBar.y = borderOffset;
			_titleBar.width = maxWidth - 2*borderOffset;
			
			// content placement here
			_label.x = borderOffset;
			_label.y = borderOffset + _titleBar.height + 2;
			_label.width = maxWidth - 2*borderOffset;
			
			_controlBar.x = borderOffset;
			_controlBar.y = borderOffset + _label.y + _label.height + 2;
			_controlBar.width = maxWidth - 2*borderOffset;
			
			UIBase(_strand).width = maxWidth;
			UIBase(_strand).height = _controlBar.y + _controlBar.height + borderOffset;
		}
		
		private function handleOK(event:Event):void
		{
			// create some custom event where the detail value
			// is the OK button flag. Do same for other event handlers
			dispatchCloseEvent(Alert.OK);
		}
		
		private function handleCancel(event:Event):void
		{
			dispatchCloseEvent(Alert.CANCEL);
		}
		
		private function handleYes(event:Event):void
		{
			dispatchCloseEvent(Alert.YES);
		}
		
		private function handleNo(event:Event):void
		{
			dispatchCloseEvent(Alert.NO);
		}
		
		public function dispatchCloseEvent(buttonFlag:uint):void
		{
			// TO DO: buttonFlag should be part of the event
			var newEvent:Event = new Event("close",true);
			IEventDispatcher(_strand).dispatchEvent(newEvent);
		}
	}
}