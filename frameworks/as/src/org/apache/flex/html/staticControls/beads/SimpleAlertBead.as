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
	
	import org.apache.flex.core.IAlertModel;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitModel;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextBead;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.html.staticControls.Label;
	import org.apache.flex.html.staticControls.TextButton;
	
	public class SimpleAlertBead implements ISimpleAlertBead
	{
		public function SimpleAlertBead()
		{
		}
		
		private var messageLabel:Label;
		private var okButton:TextButton;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var model:IAlertModel = _strand.getBeadByType(IAlertModel) as IAlertModel;
			model.addEventListener("messageChange",handleMessageChange);
			model.addEventListener("htmlMessageChange",handleMessageChange);
			
			messageLabel = new Label();
			messageLabel.initModel();
			messageLabel.initSkin();
			messageLabel.text = model.message;
			messageLabel.html = model.htmlMessage;
			messageLabel.addToParent(_strand);
			
			okButton = new TextButton();
			okButton.initModel();
			okButton.text = model.okLabel;
			okButton.initSkin();
			okButton.addToParent(_strand);
			okButton.addEventListener("click",handleOK);
			
			handleMessageChange(null);
		}
		
		private function handleMessageChange(event:Event):void
		{
			var ruler:IMeasurementBead = messageLabel.getBeadByType(IMeasurementBead) as IMeasurementBead;
			if( ruler == null ) {
				messageLabel.addBead(ruler = new (ValuesManager.valuesImpl.getValue(messageLabel, "iMeasurementBead")) as IMeasurementBead);
			}
			var maxWidth:Number = Math.max(UIBase(_strand).width,ruler.measuredWidth);
			
			var borderThickness:Object = ValuesManager.valuesImpl.getValue(_strand,"border-thickness");
			var borderOffset:Number;
			if( borderThickness == null ) {
				borderOffset = 0;
			}
			else {
				borderOffset = Number(borderThickness);
				if( isNaN(borderOffset) ) borderOffset = 0;
			}
			
			messageLabel.x = borderOffset;
			messageLabel.y = borderOffset;
			messageLabel.width = maxWidth-2*borderOffset;
			
			okButton.x = (UIBase(_strand).width - okButton.width)/2;
			okButton.y = messageLabel.height + 20;
			
			UIBase(_strand).width = maxWidth;
			UIBase(_strand).height = messageLabel.height + okButton.height + 20 + 2*borderOffset;
		}
		
		private function handleOK(event:Event):void
		{
			var newEvent:Event = new Event("close");
			IEventDispatcher(_strand).dispatchEvent(newEvent);
		}
	}
}