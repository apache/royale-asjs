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
	import org.apache.flex.core.IBead;
    import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.createjs.staticControls.Label;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Alert;
	import org.apache.flex.html.staticControls.ControlBar;
	import org.apache.flex.html.staticControls.TextButton;
	import org.apache.flex.html.staticControls.TitleBar;
	import org.apache.flex.utils.BeadMetrics;
	
	public class AlertView implements IBeadView
	{
		public function AlertView()
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
			
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "background-color");
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(value, "background-image");
			if (backgroundColor != null || backgroundImage != null)
			{
				if (value.getBeadByType(IBackgroundBead) == null)
					value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBackgroundBead")) as IBead);					
			}
			
			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(value, "border");
			if (borderStyles is Array)
			{
				borderStyle = borderStyles[1];
			}
			if (borderStyle == null)
			{
				borderStyle = ValuesManager.valuesImpl.getValue(value, "border-style") as String;
			}
			if (borderStyle != null && borderStyle != "none")
			{
				if (value.getBeadByType(IBorderBead) == null)
					value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);	
			}
			
			var flags:uint = IAlertModel(UIBase(_strand).model).flags;
			if( flags & Alert.OK ) {
				_okButton = new TextButton();
				_okButton.text = IAlertModel(UIBase(_strand).model).okLabel;
				_okButton.addEventListener("click",handleOK);
			}
			if( flags & Alert.CANCEL ) {
				_cancelButton = new TextButton();
				_cancelButton.text = IAlertModel(UIBase(_strand).model).cancelLabel;
				_cancelButton.addEventListener("click",handleCancel);
			}
			if( flags & Alert.YES ) {
				_yesButton = new TextButton();
				_yesButton.text = IAlertModel(UIBase(_strand).model).yesLabel;
				_yesButton.addEventListener("click",handleYes);
			}
			if( flags & Alert.NO ) {
				_noButton = new TextButton();
				_noButton.text = IAlertModel(UIBase(_strand).model).noLabel;
				_noButton.addEventListener("click",handleNo);
			}
			
			_titleBar = new TitleBar();
			_titleBar.title = IAlertModel(UIBase(_strand).model).title;
			
			_label = new Label();
			_label.text = IAlertModel(UIBase(_strand).model).message;
			
			_controlBar = new ControlBar();
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
			
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);

			_titleBar.x = metrics.left;
			_titleBar.y = metrics.top;
			_titleBar.width = maxWidth;
			
			// content placement here
			_label.x = metrics.left;
			_label.y = _titleBar.y + _titleBar.height + 2;
			_label.width = maxWidth;
			
			_controlBar.x = metrics.left;
			_controlBar.y = _label.y + _label.height + 2;
			_controlBar.width = maxWidth;
			
			UIBase(_strand).width = maxWidth + metrics.left + metrics.right;
			UIBase(_strand).height = _controlBar.y + _controlBar.height + metrics.bottom + 2;
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