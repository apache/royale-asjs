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
package org.apache.flex.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class UIBase extends Sprite implements IInitModel, IStrand, IEventDispatcher, IUIBase
	{
		public function UIBase()
		{
			super();
		}
		
		private var _width:Number;
		override public function get width():Number
		{
			if (isNaN(_width))
            {
                var value:* = ValuesManager.valuesImpl.getValue(this, "width");
                if (value === undefined)
                    return $width;
				_width = Number(value);
            }
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
		
		private var _height:Number;
		override public function get height():Number
		{
			if (isNaN(_height))
            {
                var value:* = ValuesManager.valuesImpl.getValue(this, "height");
                if (value === undefined)
                    return $height;
  	            _height = Number(value);
            }
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
		public function get model():IBeadModel
		{
			return _model;
		}
		public function set model(value:IBeadModel):void
		{
			if (_model != value)
			{
				addBead(value as IBead);
				dispatchEvent(new Event("modelChanged"));
			}
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
		
		private var _className:String;
		public function get className():String
		{
			return _className;
		}
		public function set className(value:String):void
		{
			if (_className != value)
			{
				_className = value;
				dispatchEvent(new Event("classNameChanged"));
			}
		}
		
		// beads declared in MXML are added to the strand.
		// from AS, just call addBead()
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
			bead.strand = this;
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
		
		public function initModel():void
		{
			
		}
		
		public function addToParent(p:Object):void
		{
			if (p is UIBase)
				UIBase(p).internalAddChild(this);
            else
    			p.addChild(this);
		}
		
		/**
		 * Used internally by addToParent() implementations
		 * to determine attach a child to a parent.  Containers
		 * may host controls in a sub-component in order to
		 * manage scrolling and margins and other internal abstractions.
		 * Each platform assumes that the appropriate platform call
		 * will add the child to the parent (i.e. addChild on Flash, 
		 * appendChild on HTML).
		 */
		public function internalAddChild(child:Object):void
		{
			addChild(child as DisplayObject);
		}

        /*
        public function addToParent(p:Object):void
        {
            var doc:DisplayObjectContainer = p as DisplayObjectContainer;
            if (p is UIBase)
                doc = UIBase(p).getParentForChild(this) as DisplayObjectContainer;
            doc.addChild(this);
        }
        */
        
        /**
         * Used internally by addToParent() implementations
         * to determine suitable parent for a child.  Containers
         * may host controls in a sub-component in order to
         * manage scrolling and margins and other internal abstractions.
         * Each platform assumes that the appropriate platform call
         * will add the child to the parent (i.e. addChild on Flash, 
         * appendTo on HTML).
        public function getParentForChild(child:Object):Object
        {
            return this;
        }
         */
		
		public function get measurementBead() : IMeasurementBead
		{
			var measurementBead:IMeasurementBead = getBeadByType(IMeasurementBead) as IMeasurementBead;
			if( measurementBead == null ) {
				addBead(measurementBead = new (ValuesManager.valuesImpl.getValue(this, "iMeasurementBead")) as IMeasurementBead);
			}
			
			return measurementBead;
		}
        
	}
}