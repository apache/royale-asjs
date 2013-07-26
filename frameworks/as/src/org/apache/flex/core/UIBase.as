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
	
	public class UIBase extends Sprite implements IStrand, IEventDispatcher, IUIBase, IParent
	{
		public function UIBase()
		{
			super();
		}
		
		private var _explicitWidth:Number;
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		public function set explicitWidth(value:Number):void
		{
			if (_explicitWidth == value)
				return;
			
			// width can be pixel or percent not both
			if (!isNaN(value))
				_percentWidth = NaN;
			
			_explicitWidth = value;
			
			dispatchEvent(new Event("explicitWidthChanged"));
		}
		
		private var _explicitHeight:Number;
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		public function set explicitHeight(value:Number):void
		{
			if (_explicitHeight == value)
				return;
			
			// height can be pixel or percent not both
			if (!isNaN(value))
				_percentHeight = NaN;
			
			_explicitHeight = value;
			
			dispatchEvent(new Event("explicitHeightChanged"));
		}
		
		private var _percentWidth:Number;
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		public function set percentWidth(value:Number):void
		{
			if (_percentWidth == value)
				return;
			
			if (!isNaN(value))
				_explicitWidth = NaN;
			
			_percentWidth = value;
			
			dispatchEvent(new Event("percentWidthChanged"));
		}
		private var _percentHeight:Number;
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		public function set percentHeight(value:Number):void
		{
			if (_percentHeight == value)
				return;
			
			if (!isNaN(value))
				_explicitHeight = NaN;
			
			_percentHeight = value;
			
			dispatchEvent(new Event("percentHeightChanged"));
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
			if (explicitWidth != value)
			{
				explicitWidth = value;
			}
			
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
			if (explicitHeight != value)
			{
				explicitHeight = value;
			}
			
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
            if (_model == null)
            {
                // addbead will set _model
                addBead(new (ValuesManager.valuesImpl.getValue(this, "iBeadModel")) as IBead);
            }
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
        
        public function get element():Object
        {
            return this;
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
		
		public function addElement(c:Object):void
		{
            if (c is IUIBase)
            {
                addChild(IUIBase(c).element as DisplayObject);
                IUIBase(c).addedToParent();
            }
            else
                addChild(c as DisplayObject);
		}
        
        public function addElementAt(c:Object, index:int):void
        {
            if (c is IUIBase)
            {
                addChildAt(IUIBase(c).element as DisplayObject, index);
                IUIBase(c).addedToParent();
            }
            else
                addChildAt(c as DisplayObject, index);
        }
        
        public function getElementIndex(c:Object):int
        {
            if (c is IUIBase)
                return getChildIndex(IUIBase(c).element as DisplayObject);
            else
                return getChildIndex(c as DisplayObject);
        }

        public function removeElement(c:Object):void
        {
            if (c is IUIBase)
                removeChild(IUIBase(c).element as DisplayObject);
            else
                removeChild(c as DisplayObject);
        }
		
        public function addedToParent():void
        {
            var c:Class;
            
            if (getBeadByType(IBeadModel) == null) 
            {
                c = ValuesManager.valuesImpl.getValue(this, "iBeadModel") as Class;
                if (c)
                {
                    var model:IBeadModel = new c as IBeadModel;
                    if (model)
                        addBead(model);
                }
            }
            if (getBeadByType(IBeadView) == null) 
            {
                c = ValuesManager.valuesImpl.getValue(this, "iBeadView") as Class;
                if (c)
                {
                    var view:IBeadView = new c as IBeadView;
                    if (view)
                        addBead(view);
                }
            }
            if (getBeadByType(IBeadController) == null) 
            {
                c = ValuesManager.valuesImpl.getValue(this, "iBeadController") as Class;
                if (c)
                {
                    var controller:IBeadController = new c as IBeadController;
                    if (controller)
                        addBead(controller);
                }
            }
        }
        		
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