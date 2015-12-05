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
package org.apache.flex.createjs.core
{
    import org.apache.flex.core.HTMLElementWrapper;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBead;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.DisplayObject;
        import org.apache.flex.core.WrappedHTMLElement;
    }
        
	public class UIBase extends HTMLElementWrapper implements IStrand, IEventDispatcher
	{
		public function UIBase()
		{
			super();
            COMPILE::JS
            {
                createElement();                    
            }
		}
		
        COMPILE::JS
        public var positioner:WrappedHTMLElement;
        
        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            (element as Container).addChild(c as DisplayObject);
        }
        
        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            (element as Container).addChildAt(c as DisplayObject, index);
        }
        
        
        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        public function getElementIndex(c:Object):int
        {
            return (element as Container).getChildIndex(c as DisplayObject);
        }
        

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            (element as Container).removeChild(c as DisplayObject);
        }
        

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        public function getElementAt(index:int):Object
        {
            return (element as Container).getChildAt(index);
        }
        

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        COMPILE::JS
        public function get numElements():int
        {
            return (element as Container).numChildren;
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement;
         */
        COMPILE::JS
        public function createElement():WrappedHTMLElement
        {
            element = new Container() as WrappedHTMLElement;
            
            positioner = this.element;
            positioner.style.position = 'relative';
            return element;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function get x():Number
        {
            return (positioner as Container).x;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function set x(value:Number):void
        {
            var container:Container = positioner as Container;
            container.x = value;
            container.getStage().update();
        }

        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function get y():Number
        {
            return (positioner as Container).y;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function set y(value:Number):void
        {
            var container:Container = positioner as Container;
            container.y = value;
            container.getStage().update();
        }        
        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function get width():Number
        {
            return (positioner as Container).width;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function set width(value:Number):void
        {
            var container:Container = positioner as Container;
            container.width = value;
            container.getStage().update();
        }

        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function get height():Number
        {
            return (positioner as Container).height;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container;
         */
        COMPILE::JS
        public function set height(value:Number):void
        {
            var container:Container = positioner as Container;
            container.height = value;
            container.getStage().update();
        }
        
        COMPILE::AS3
		private var _width:Number = 0;
        COMPILE::AS3
		override public function get width():Number
		{
            return _width;                    
		}
        
        COMPILE::AS3
		override public function set width(value:Number):void
		{
            if (_width != value)
            {
                _width = value;
                dispatchEvent(new Event("widthChanged"));
            }                    
		}
        COMPILE::AS3
		protected function get $width():Number
		{
			return super.width;
		}
		
        COMPILE::AS3
		private var _height:Number = 0;
        COMPILE::AS3
		override public function get height():Number
		{
			return _height;
		}
        COMPILE::AS3
		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				dispatchEvent(new Event("heightChanged"));
			}
		}
        COMPILE::AS3
		protected function get $height():Number
		{
			return super.height;
		}
		
        COMPILE::AS3
		private var _model:IBeadModel;
        COMPILE::AS3
		public function get model():IBeadModel
		{
			return _model;
		}
        COMPILE::AS3
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
		
		// beads declared in MXML are added to the strand.
		// from AS, just call addBead()
        COMPILE::AS3
		public var beads:Array;
		
        COMPILE::AS3
		private var _beads:Vector.<IBead>;
        COMPILE::AS3
		override public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
			bead.strand = this;
		}
		
        COMPILE::AS3
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
        COMPILE::AS3
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
		
	}
}
