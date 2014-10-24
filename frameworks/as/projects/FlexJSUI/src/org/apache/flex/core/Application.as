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
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;
    
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.MouseEvent;
    import org.apache.flex.utils.MXMLDataInterpreter;
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched at startup. Attributes and sub-instances of
     *  the MXML document have been created and assigned.
     *  The component lifecycle is different
     *  than the Flex SDK.  There is no creationComplete event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="initialize", type="org.apache.flex.events.Event")]
    
    /**
     *  Dispatched at startup after the initial view has been
     *  put on the display list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="viewChanged", type="org.apache.flex.events.Event")]
    
    /**
     *  Dispatched at startup after the initial view has been
     *  put on the display list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="applicationComplete", type="org.apache.flex.events.Event")]

    /**
     *  The Application class is the main class and entry point for a FlexJS
     *  application.  This Application class is different than the
     *  Flex SDK's mx:Application or spark:Application in that it does not contain
     *  user interface elements.  Those UI elements go in the views.  This
     *  Application class expects there to be a main model, a controller, and 
     *  an initial view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class Application extends Sprite implements IStrand, IFlexInfo, IParent, IEventDispatcher
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function Application()
        {
            super();
			if (stage)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
                // should be opt-in
				//stage.quality = StageQuality.HIGH_16X16_LINEAR;
                
                stage.addEventListener(flash.events.MouseEvent.CLICK, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.ROLL_OVER, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.ROLL_OUT, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.MOUSE_OVER, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.MOUSE_OUT, mouseEventKiller, true, 9999);
                stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseEventKiller, true, 9999);
			}
			
            loaderInfo.addEventListener(flash.events.Event.INIT, initHandler);
        }

        private function mouseEventKiller(event:flash.events.Event):void
        {
            if (event is flash.events.MouseEvent && (!(event is org.apache.flex.events.MouseEvent)))
            {
                var newEvent:org.apache.flex.events.MouseEvent = 
                    org.apache.flex.events.MouseEvent.convert(flash.events.MouseEvent(event));
                if (newEvent) 
                {
                    // some events are not converted if there are no JS equivalents
                    event.stopImmediatePropagation();
                    event.target.dispatchEvent(newEvent);
                }
                else
                    trace("did not convert", event.type);
            }
        }
        
        /**
         *  The document property is used to provide
         *  a property lookup context for non-display objects.
         *  For Application, it points to itself.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var document:Object = this;
        
        private function initHandler(event:flash.events.Event):void
        {
            for each (var bead:IBead in beads)
                addBead(bead);
                
            dispatchEvent(new org.apache.flex.events.Event("beadsAdded"));

            MXMLDataInterpreter.generateMXMLInstances(this, null, MXMLDescriptor);
            
            dispatchEvent(new org.apache.flex.events.Event("initialize"));

            if (initialView)
            {
                initialView.applicationModel =  model;
        	    this.addElement(initialView);
                dispatchEvent(new org.apache.flex.events.Event("viewChanged"));
            }
            dispatchEvent(new org.apache.flex.events.Event("applicationComplete"));
        }

        /**
         *  The org.apache.flex.core.IValuesImpl that will
         *  determine the default values and other values
         *  for the application.  The most common choice
         *  is org.apache.flex.core.SimpleCSSValuesImpl.
         * 
         *  @see org.apache.flex.core.SimpleCSSValuesImpl
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set valuesImpl(value:IValuesImpl):void
        {
            ValuesManager.valuesImpl = value;
            ValuesManager.valuesImpl.init(this);
        }

        /**
         *  The initial view.
         * 
         *  @see org.apache.flex.core.ViewBase
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var initialView:ViewBase;

        /**
         *  The data model (for the initial view).
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var model:Object;

        /**
         *  The controller.  The controller typically watches
         *  the UI for events and updates the model accordingly.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var controller:Object;

        /**
         *  An array of data that describes the MXML attributes
         *  and tags in an MXML document.  This data is usually
         *  decoded by an MXMLDataInterpreter
         * 
         *  @see org.apache.flex.utils.MXMLDataInterpreter
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get MXMLDescriptor():Array
        {
            return null;
        }

        /**
         *  An method called by the compiler's generated
         *  code to kick off the setting of MXML attribute
         *  values and instantiation of child tags.
         * 
         *  The call has to be made in the generated code
         *  in order to ensure that the constructors have
         *  completed first.
         * 
         *  @param data The encoded data representing the
         *  MXML attributes.
         * 
         *  @see org.apache.flex.utils.MXMLDataInterpreter
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
    	public function generateMXMLAttributes(data:Array):void
        {
			MXMLDataInterpreter.generateMXMLProperties(this, data);
        }
        
        /**
         *  The array property that is used to add additional
         *  beads to an MXML tag.  From ActionScript, just
         *  call addBead directly.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var beads:Array;
        
        private var _beads:Vector.<IBead>;
        
        /**
         *  @copy org.apache.flex.core.IStrand#addBead()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function addBead(bead:IBead):void
        {
            if (!_beads)
                _beads = new Vector.<IBead>;
            _beads.push(bead);
            bead.strand = this;
        }
        
        /**
         *  @copy org.apache.flex.core.IStrand#getBeadByType()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getBeadByType(classOrInterface:Class):IBead
        {
            for each (var bead:IBead in _beads)
            {
                if (bead is classOrInterface)
                    return bead;
            }
            return null;
        }
        
        /**
         *  @copy org.apache.flex.core.IStrand#removeBead()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
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
        
        private var _info:Object;
        
        /**
         *  An Object containing information generated
         *  by the compiler that is useful at startup time.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function info():Object
        {
            if (!_info)
            {
                var mainClassName:String = getQualifiedClassName(this);
                var initClassName:String = "_" + mainClassName + "_FlexInit";
                var c:Class = ApplicationDomain.currentDomain.getDefinition(initClassName) as Class;
                _info = c.info();
            }
            return _info;
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
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
        
        /**
         *  @copy org.apache.flex.core.IParent#addElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
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

        /**
         *  @copy org.apache.flex.core.IParent#getElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getElementAt(index:int):Object
        {
            return getChildAt(index);
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#getElementIndex()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getElementIndex(c:Object):int
        {
            if (c is IUIBase)
                return getChildIndex(IUIBase(c).element as DisplayObject);

            return getChildIndex(c as DisplayObject);
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#removeElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function removeElement(c:Object):void
        {
            if (c is IUIBase)
            {
                removeChild(IUIBase(c).element as DisplayObject);
            }
            else
                removeChild(c as DisplayObject);
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#numElements
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get numElements():int
        {
            return numChildren;
        }
    }
}