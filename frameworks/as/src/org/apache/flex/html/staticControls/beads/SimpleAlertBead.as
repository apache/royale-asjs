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
			okButton.text = "OK";
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
			
			messageLabel.x = 0;
			messageLabel.y = 0;
			messageLabel.width = maxWidth;
			
			okButton.x = (UIBase(_strand).width - okButton.width)/2;
			okButton.y = messageLabel.height + 20;
			
			UIBase(_strand).width = maxWidth;
			UIBase(_strand).height = messageLabel.height + okButton.height + 20;
		}
		
		private function handleOK(event:Event):void
		{
			var newEvent:Event = new Event("close");
			IEventDispatcher(_strand).dispatchEvent(newEvent);
			hidePopUp();
		}
		
		
		
		private var _popUp:IStrand;
		public function get popUp():IStrand
		{
			return _popUp;
		}
		
		private var _popUpVisible:Boolean;
		
		public function get popUpVisible():Boolean
		{
			return _popUpVisible;
		}
		
		public function showPopUp( host:DisplayObjectContainer ) : void
		{
			if (!_popUp)
			{
				var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
				_popUp = new popUpClass() as IStrand;
				UIBase(_strand).addToParent(_popUp);
				UIBase(_strand).x = 10;
				UIBase(_strand).y = 10;
			}

			host.addChild(_popUp as DisplayObject);
			if (_popUp is IInitModel)
				IInitModel(_popUp).initModel();
			if (_popUp is IInitSkin)
				IInitSkin(_popUp).initSkin();
			
			UIBase(_popUp).width = UIBase(_strand).width + 20;
			UIBase(_popUp).height = UIBase(_strand).height + 20;
			
			UIBase(_popUp).x = (host.width + UIBase(_strand).width)/2;
			UIBase(_popUp).y = (host.height + UIBase(_strand).height)/2;
			
			_popUpVisible = true;
		}
		
		public function hidePopUp() : void
		{
			if( _popUp )
			{
				DisplayObject(_popUp).parent.removeChild(_popUp as DisplayObject);
			}
			
			_popUpVisible = false;
		}
	}
}