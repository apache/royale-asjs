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
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IInitModel;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	[Event(name="click", type="org.apache.flex.events.Event")]

	public class Button extends SimpleButton implements IStrand, IInitSkin, IInitModel, IEventDispatcher
	{
		public function Button(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			// mouseChildren = true;
			// mouseEnabled = true;
			addEventListener(MouseEvent.CLICK, clickKiller, false, 9999); 
		}
		
		private function clickKiller(event:flash.events.Event):void
		{
			if (event is MouseEvent)
			{
				event.stopImmediatePropagation();
				dispatchEvent(new Event("click"));
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
		
        // beads declared in MXML are added to the strand.
        // from AS, just call addBead()
        public var beads:Array;
        
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
		
		public function initModel():void
		{
			
		}
		
		public function initSkin():void
		{
			_width = $width;
			_height = $height;
		}
		
		public function addToParent(p:DisplayObjectContainer):void
		{
			p.addChild(this);
		}
	}
}