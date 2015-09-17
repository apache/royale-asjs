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
    import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.MouseEvent;
    import org.apache.flex.events.utils.MouseEventConverter;
    import org.apache.flex.utils.MXMLDataInterpreter;

    COMPILE::AS3 {
        import flash.display.DisplayObject;
        import flash.display.Sprite;
        import flash.display.StageAlign;
        import flash.display.StageQuality;
        import flash.display.StageScaleMode;
        import flash.events.Event;
        import flash.system.ApplicationDomain;
        import flash.utils.getQualifiedClassName;
    }

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
     *  Dispatched at startup before the instances get created.
     *  Beads can call preventDefault and defer initialization.
     *  This event will be dispatched on every frame until no
     *  listeners call preventDefault(), then the initialize()
     *  method will be called.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="preinitialize", type="org.apache.flex.events.Event")]

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
    public class Application extends ApplicationBase implements IStrand, IParent, IEventDispatcher
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
            
            COMPILE::AS3 {
    			if (stage)
    			{
    				stage.align = StageAlign.TOP_LEFT;
    				stage.scaleMode = StageScaleMode.NO_SCALE;
                    // should be opt-in
    				//stage.quality = StageQuality.HIGH_16X16_LINEAR;                
    			}
    			
                loaderInfo.addEventListener(flash.events.Event.INIT, initHandler);
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
        
        COMPILE::AS3
        private function initHandler(event:flash.events.Event):void
        {
			if (model is IBead) addBead(model as IBead);
			if (controller is IBead) addBead(controller as IBead);
			
            MouseEventConverter.setupAllConverters(stage);
                
            for each (var bead:IBead in beads)
                addBead(bead);
                
            dispatchEvent(new org.apache.flex.events.Event("beadsAdded"));

            if (dispatchEvent(new org.apache.flex.events.Event("preinitialize", false, true)))
                initialize();
            else
                addEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);
            
        }
        
        COMPILE::AS3
        private function enterFrameHandler(event:flash.events.Event):void
        {
            if (dispatchEvent(new org.apache.flex.events.Event("preinitialize", false, true)))
            {
                removeEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);
                initialize();
            }    
        }
        
        /**
         *  This method gets called when all preinitialize handlers
         *  no longer call preventDefault();
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        COMPILE::AS3
        protected function initialize():void
        {
            
            MXMLDataInterpreter.generateMXMLInstances(this, null, MXMLDescriptor);
            
            dispatchEvent(new org.apache.flex.events.Event("initialize"));

            if (initialView)
            {
                initialView.applicationModel =  model;
                if (isNaN(initialView.explicitWidth))
                    initialView.width = stage.stageWidth;
                if (isNaN(initialView.explicitHeight))
                    initialView.height = stage.stageHeight;
        	    this.addElement(initialView);
                var bgColor:Object = ValuesManager.valuesImpl.getValue(this, "background-color");
                if (bgColor != null)
                {
                    var backgroundColor:uint = ValuesManager.valuesImpl.convertColor(bgColor);
                    graphics.beginFill(backgroundColor);
                    graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
                    graphics.endFill();
                }
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
        public var initialView:Object;

        /**
         *  The data model (for the initial view).
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        COMPILE::AS3
        public var model:IBead;

        /**
         *  The controller.  The controller typically watches
         *  the UI for events and updates the model accordingly.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var controller:IBead;

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
        COMPILE::AS3
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
        
        COMPILE::AS3
        private var _beads:Vector.<IBead>;
        
        /**
         *  @copy org.apache.flex.core.IStrand#addBead()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        COMPILE::AS3
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
        
        /**
         *  @copy org.apache.flex.core.IStrand#removeBead()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
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
        
        /**
         *  @copy org.apache.flex.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            COMPILE::AS3 {
                if (c is IUIBase)
                {
                    addChild(IUIBase(c).element as DisplayObject);
                    IUIBase(c).addedToParent();
                }
                else
                    addChild(c as DisplayObject);
            }
            COMPILE::JS {
                this.element.appendChild(c.element);
            }
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#addElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            COMPILE::AS3 {
                if (c is IUIBase)
                {
                    addChildAt(IUIBase(c).element as DisplayObject, index);
                    IUIBase(c).addedToParent();
                }
                else
                    addChildAt(c as DisplayObject, index);
            }
            COMPILE::JS {
                var children:NodeList = internalChildren();
                if (index >= children.length)
                    addElement(c);
                else
                {
                    element.insertBefore(c.positioner,
                        children[index]);
                    c.addedToParent();
                }

            }
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
            COMPILE::AS3 {
                return getChildAt(index);
            }
            COMPILE::JS {
                var children:NodeList = internalChildren();
                return children[index].flexjs_wrapper;
            }
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
            COMPILE::AS3 {
                if (c is IUIBase)
                    return getChildIndex(IUIBase(c).element as DisplayObject);
    
                return getChildIndex(c as DisplayObject);
            }
            COMPILE::JS {
                var children:NodeList = internalChildren();
                var n:int = children.length;
                for (var i:int = 0; i < n; i++)
                {
                    if (children[i] == c.element)
                        return i;
                }
                return -1;
            }
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#removeElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            COMPILE::AS3 {
                if (c is IUIBase)
                {
                    removeChild(IUIBase(c).element as DisplayObject);
                }
                else
                    removeChild(c as DisplayObject);
            }
            COMPILE::JS {
                element.removeChild(c.element);
            }
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
            COMPILE::AS3 {
                return numChildren;
            }
            COMPILE::JS {
                var children:NodeList = internalChildren();
                return children.length;
            }
        }
        
        /**
         * @return {Object} The array of children.
         */
        COMPILE::JS
        protected function internalChildren():NodeList
        {
            return element.childNodes;
        };
        
        

        /**
         * @export
         */
        COMPILE::JS
        public function start():void 
        {
            element = document.getElementsByTagName('body')[0];
            element.flexjs_wrapper = this;
            element.className = 'Application';
            
            MXMLDataInterpreter.generateMXMLInstances(this, null, MXMLDescriptor);
            
            dispatchEvent('initialize');
            
            if (model) addBead(model);
            if (controller) addBead(controller);
            
            initialView.applicationModel = model;
            addElement(initialView);
            
            dispatchEvent('viewChanged');
        };

    }
}
