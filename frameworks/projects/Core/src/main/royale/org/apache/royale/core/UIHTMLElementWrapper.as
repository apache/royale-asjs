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
package org.apache.royale.core
{
COMPILE::SWF
{
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
}

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IMeasurementBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
    import org.apache.royale.events.utils.MouseEventConverter;
	import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Set a different class for click events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  The UIHTMLElementWrapper class is the base class for most Buttons
     *  and other UI objects in a Royale application that do not have children.  
     *  In Flash, these buttons extend SimpleButton and therefore
     *  do not support all of the Sprite APIs.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class UIHTMLElementWrapper extends ElementWrapper implements IStrandWithModel, IEventDispatcher
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function UIHTMLElementWrapper()
		{
        }

        /**
         * The HTMLElement used to position the component.
         */
        COMPILE::JS
        public function get positioner():WrappedHTMLElement
        {
            return _element;
        }
        
        /**
         * @private
         */
        COMPILE::JS
        public function set positioner(value:WrappedHTMLElement):void
        {
            element = value;
        }
        
        /**
         * allow access from overrides
         */
        protected var _model:Object;
        
        /**
         * @royaleignorecoercion Class 
         * @royaleignorecoercion org.apache.royale.core.IBeadModel 
         */
        public function get model():Object
        {
            if (_model == null) 
            {
                // addbead will set _model
                var m:Class = org.apache.royale.core.ValuesManager.valuesImpl.
                    getValue(this, 'iBeadModel') as Class;
                if (m)
                {
                    var b:IBeadModel = new m() as IBeadModel;
                    addBead(b);
                }
            }
            return _model;
        }
        
        /**
         * @royaleignorecoercion org.apache.royale.core.IBead
         */
        [Bindable("modelChanged")]
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                if (value is IBead)
                    addBead(value as IBead);
                else
                    _model = value;
                dispatchEvent(new org.apache.royale.events.Event("modelChanged"));
            }
        }
        
        /**
         * @param bead The new bead.
         * @royaleignorecoercion org.apache.royale.core.IBeadModel
         */
        override public function addBead(bead:IBead):void
        {
            if (!_beads)
            {
                _beads = new Vector.<IBead>();
            }
            
            _beads.push(bead);
            
            if (bead is IBeadModel)
            {
                _model = bead as IBeadModel;
            }
            
            bead.strand = this;
        }
        
        COMPILE::SWF
        public function get $displayObjectContainer():DisplayObjectContainer
        {
            return _element as DisplayObjectContainer;
        }
        
        COMPILE::SWF
        public function get $displayObject():DisplayObject
        {
            return _element as DisplayObject;
        }
                
        COMPILE::SWF
        public function get width():Number
        {
            return $displayObject.width;
        }
        
        COMPILE::SWF
        public function set width(value:Number):void
        {
            $displayObject.width = value;
        }
        
        COMPILE::SWF
        public function get height():Number
        {
            return $displayObject.height;
        }
        
        COMPILE::SWF
        public function set height(value:Number):void
        {
            $displayObject.height = value;
        }
        
        COMPILE::SWF
        public function get x():Number
        {
            return $displayObject.x;
        }
        
        COMPILE::SWF
        public function set x(value:Number):void
        {
            $displayObject.x = value;
        }
        
        COMPILE::SWF
        public function get y():Number
        {
            return $displayObject.y;
        }
        
        COMPILE::SWF
        public function set y(value:Number):void
        {
            $displayObject.y = value;
        }        
        
        COMPILE::SWF
        public function get visible():Boolean
        {
            return $displayObject.visible;
        }
        
        COMPILE::SWF
        public function set visible(value:Boolean):void
        {
            $displayObject.visible = value;
        }        
        
        COMPILE::SWF
        public function get alpha():Number
        {
            return $displayObject.alpha;
        }
        
        COMPILE::SWF
        public function set alpha(value:Number):void
        {
            $displayObject.alpha = value;
        }        
        
        /**
         * @param value The event containing new style properties.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion org.apache.royale.core.IParent
         */
        public function get parent():IParent
        {
            COMPILE::JS
            {
            var p:WrappedHTMLElement = this.positioner.parentNode as WrappedHTMLElement;
            }
            COMPILE::SWF
            {
                var p:IRoyaleElement = this.$displayObject.parent as IRoyaleElement;
            }
            var wrapper:IParent = p ? p.royale_wrapper as IParent : null;
            return wrapper;
        }
        
	}
}
