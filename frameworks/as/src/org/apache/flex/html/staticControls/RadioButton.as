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
package org.apache.flex.html.staticControls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IInitModel;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.IRadioButtonBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IValueToggleButtonModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	
	[Event(name="change", type="org.apache.flex.events.Event")]

	public class RadioButton extends SimpleButton implements IStrand, IInitSkin, IInitModel
	{
		public function RadioButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}
		
		protected static var dict:Dictionary = new Dictionary(true);
		
		private var _groupName:String;
		
		public function get groupName() : String
		{
			return IValueToggleButtonModel(model).groupName;
		}
		
		public function set groupName(value:String) : void
		{
			IValueToggleButtonModel(model).groupName = value;
		}
		
		public function get text():String
		{
			return IValueToggleButtonModel(model).text;
		}
		public function set text(value:String):void
		{
			IValueToggleButtonModel(model).text = value;
		}
		
		public function get selected():Boolean
		{
			return IValueToggleButtonModel(model).selected;
		}
		
		public function set selected(selValue:Boolean):void
		{
			IValueToggleButtonModel(model).selected = selValue;
			
			// if this button is being selected, its value should become
			// its group's selectedValue
			if( selValue ) {
				for each(var rb:RadioButton in dict)
				{
					if( rb.groupName == groupName )
					{
						rb.selectedValue = value;
					}
				}
			}
		}
		
		public function get value():Object
		{
			return IValueToggleButtonModel(model).value;
		}
		
		public function set value(newValue:Object):void
		{
			IValueToggleButtonModel(model).value = newValue;
		}
		
		public function get selectedValue():Object 
		{
			return IValueToggleButtonModel(model).selectedValue;
		}
		
		public function set selectedValue(newValue:Object):void 
		{
			// a radio button is really selected when its value matches that of the group's value
			IValueToggleButtonModel(model).selected = (newValue == value);
			IValueToggleButtonModel(model).selectedValue = newValue;
		}
		
		public function addToParent(p:DisplayObjectContainer):void
		{
			p.addChild(this);
		}
		
		public function initModel():void
		{
			if (getBeadByType(IValueToggleButtonModel) == null) 
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iToggleButtonModel")) as IBead);
		}
		
		public function initSkin():void
		{
			if (getBeadByType(IRadioButtonBead) == null)
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iRadioButtonBead")) as IBead);	
			
			_width = $width;
			_height = $height;
			
			// if this instance is selected, set the local selectedValue to
			// this instance's value
			if( selected ) selectedValue = value;
			
			else {
			
				// make sure this button's selectedValue is set from its group's selectedValue
				// to keep it in sync with the rest of the buttons in its group.
				for each(var rb:RadioButton in dict)
				{
					if( rb.groupName == groupName )
					{
						selectedValue = rb.selectedValue;
						break;
					}
				}
			}
			
			dict[this] = this;
		}
		
		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}
		
		private var _width:Number = 0;
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				dispatchEvent(new Event("widthChanged"));
			}
		}
		protected function get $width():Number
		{
			return super.width;
		}
		
		private var _height:Number = 0;
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				dispatchEvent(new Event("heightChanged"));
			}
		}
		protected function get $height():Number
		{
			return super.height;
		}
		
		private var _model:IBeadModel;
		protected function get model():IBeadModel
		{
			return _model;
		}
		
		private var strand:Vector.<IBead>;
		public function addBead(bead:IBead):void
		{
			if (!strand)
				strand = new Vector.<IBead>;
			strand.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
			bead.strand = this;
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in strand)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
		public function removeBead(value:IBead):IBead	
		{
			var n:int = strand.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = strand[i];
				if (bead == value)
				{
					strand.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
		
		private function internalMouseHandler(event:MouseEvent) : void
		{
			// prevent radiobutton from being turned off by a click
			if( !selected ) {
				selected = !selected;
				dispatchEvent(new Event("change"));
			}
		}
	}
}