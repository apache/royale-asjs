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
    import org.apache.royale.core.IParent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.utils.MXMLDataInterpreter;
    import org.apache.royale.utils.Timer;
    import org.apache.royale.utils.sendEvent;

    COMPILE::SWF {
        import flash.display.DisplayObject;
        import flash.display.Sprite;
        import flash.display.StageAlign;
        import flash.display.StageQuality;
        import flash.display.StageScaleMode;
        import flash.events.Event;
        import flash.system.ApplicationDomain;
        import flash.utils.getQualifiedClassName;
        import org.apache.royale.events.utils.MouseEventConverter;
    }

    COMPILE::JS
    {
        import org.apache.royale.utils.html.getStyle;
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
     *  @productversion Royale 0.0
     */
    [Event(name="initialize", type="org.apache.royale.events.Event")]

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
     *  @productversion Royale 0.0
     */
    [Event(name="preinitialize", type="org.apache.royale.events.Event")]

    /**
     *  Dispatched at startup after the initial view has been
     *  put on the display list. This event is sent before
     *  applicationComplete is dispatched.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="viewChanged", type="org.apache.royale.events.Event")]

    /**
     *  Dispatched at startup after the initial view has been
     *  put on the display list.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="applicationComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  The Application class is the main class and entry point for a Royale
     *  application.  This Application class is different than the
     *  Flex SDK's mx:Application or spark:Application in that it does not contain
     *  user interface elements.  Those UI elements go in the views (ViewBase).  This
     *  Application class expects there to be a main model, a controller, and
     *  an initial view.
     *
     *  @see ViewBase
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class Application extends ApplicationBase implements IStrand, IParent, IEventDispatcher, IInitialViewApplication, IPopUpHost, IPopUpHostParent, IRenderedObject
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function Application()
        {
            super();

            COMPILE::SWF {
    			if (stage)
    			{
    				stage.align = StageAlign.TOP_LEFT;
    				stage.scaleMode = StageScaleMode.NO_SCALE;
                    // should be opt-in
    				//stage.quality = StageQuality.HIGH_16X16_LINEAR;
    			}

                loaderInfo.addEventListener(flash.events.Event.INIT, initHandler);
            }
			COMPILE::JS {
				element = document.getElementsByTagName('body')[0];
				element.className = 'Application';			
			}
        }
        
        protected var instanceParent:IParent = null;

        COMPILE::SWF
        private function initHandler(event:flash.events.Event):void
        {
			if (model is IBead) addBead(model as IBead);
			if (controller is IBead) addBead(controller as IBead);

            MouseEventConverter.setupAllConverters(stage);

            for each (var bead:IBead in beads)
                addBead(bead);

            sendEvent(this,"beadsAdded");

            if (sendEvent(this,new org.apache.royale.events.Event("preinitialize", false, true)))
                initialize();
            else
                addEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);

        }

        COMPILE::SWF
        private function enterFrameHandler(event:flash.events.Event):void
        {
            if (sendEvent(this,new org.apache.royale.events.Event("preinitialize", false, true)))
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
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
        protected function initialize():void
        {

            MXMLDataInterpreter.generateMXMLInstances(this, instanceParent, MXMLDescriptor);

            sendEvent(this,"initialize");

            if (initialView)
            {
                initialView.applicationModel =  model;
        	    this.addElement(initialView);
                // if someone has installed a resize listener, fake an event to run it now
                if (stage.hasEventListener("resize"))
                    stage.dispatchEvent(new flash.events.Event("resize"));
                else if (initialView is ILayoutChild)
                {
                    var ilc:ILayoutChild = initialView as ILayoutChild;
                    // otherwise, size once like this
                    if (!isNaN(ilc.percentWidth) && !isNaN(ilc.percentHeight))
                        ilc.setWidthAndHeight(stage.stageWidth, stage.stageHeight, true);
                    else if (!isNaN(ilc.percentWidth))
                        ilc.setWidth(stage.stageWidth);
                    else if (!isNaN(ilc.percentHeight))
                        ilc.setHeight(stage.stageHeight);
                }
                var bgColor:Object = ValuesManager.valuesImpl.getValue(this, "background-color");
                if (bgColor != null)
                {
                    var backgroundColor:uint = ValuesManager.valuesImpl.convertColor(bgColor);
                    graphics.beginFill(backgroundColor);
                    graphics.drawRect(0, 0, initialView.width, initialView.height);
                    graphics.endFill();
                }
                sendEvent(this,"viewChanged");
            }
            sendEvent(this,"applicationComplete");
        }

        /**
         *  The org.apache.royale.core.IValuesImpl that will
         *  determine the default values and other values
         *  for the application.  The most common choice
         *  is org.apache.royale.core.SimpleCSSValuesImpl.
         *
         *  @see org.apache.royale.core.SimpleCSSValuesImpl
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set valuesImpl(value:IValuesImpl):void
        {
            ValuesManager.valuesImpl = value;
            ValuesManager.valuesImpl.init(this);
        }

        private var _initialView:IApplicationView;
        /**
         *  The initial view.
         *
         *  @see org.apache.royale.core.ViewBase
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get initialView():IApplicationView
        {
            return _initialView;
        }
        public function set initialView(value:IApplicationView):void
        {
            _initialView = value;
        }

        /**
         *  The data model (for the initial view).
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        [Bindable("__NoChangeEvent__")]
        COMPILE::SWF
        public var model:Object;

        COMPILE::JS
        private var _model:Object;

        /**
         *  The data model (for the initial view).
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        [Bindable("__NoChangeEvent__")]
        COMPILE::JS
        override public function get model():Object
        {
            return _model;
        }

        /**
         *  @private
         */
        [Bindable("__NoChangeEvent__")]
        COMPILE::JS
        override public function set model(value:Object):void
        {
            _model = value;
        }

        private var _controller:Object;
        
        /**
         *  The controller.  The controller typically watches
         *  the UI for events and updates the model accordingly.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        [Bindable("__NoChangeEvent__")]
        public function get controller():Object
        {
            return _controller;
        }
        
        /**
         *  @private
         */
        [Bindable("__NoChangeEvent__")]
        public function set controller(value:Object):void
        {
            _controller = value;
        }

        /**
         *  Application can host popups but they will be in the layout, if any
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUpParent():IPopUpHostParent
        {
            return this;
        }
        
        /**
         *  An array of data that describes the MXML attributes
         *  and tags in an MXML document.  This data is usually
         *  decoded by an MXMLDataInterpreter
         *
         *  @see org.apache.royale.utils.MXMLDataInterpreter
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @see org.apache.royale.utils.MXMLDataInterpreter
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
    	public function generateMXMLAttributes(data:Array):void
        {
            // move the initialView to be the last thing to be
            // the last thing instantiated so all other properties
            // are set up first.  This more closely mimics the
            // Flex timing
            var propCount:int = data[0];
            var n:int = data.length;
            for (var i:int = 1; i < n; i += 3)
            {
                if (data[i] == "initialView")
                {
                    var initialViewArray:Array = data.splice(i, 3);
                    var offset:int = (propCount - 1) * 3 + 1;
                    data.splice(offset, 0, initialViewArray[0], initialViewArray[1], initialViewArray[2]);
                }
            }
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
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var beads:Array;

        COMPILE::SWF
        private var _beads:Vector.<IBead>;

        /**
         *  @copy org.apache.royale.core.IStrand#addBead()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
        public function addBead(bead:IBead):void
        {
            if (!_beads)
                _beads = new Vector.<IBead>;
            _beads.push(bead);
            bead.strand = this;
        }

        /**
         *  @copy org.apache.royale.core.IStrand#getBeadByType()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
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
         *  @copy org.apache.royale.core.IStrand#removeBead()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
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
         *  @copy org.apache.royale.core.IParent#addElement()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         *  @royaleignorecoercion HTMLElement
         */
        public function addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        addChild(IRenderedObject(c).$displayObject);
                    else
                        addChild(c as DisplayObject);
                    IUIBase(c).addedToParent();
                }
                else
                    addChild(c as DisplayObject);
            }
            COMPILE::JS {
                this.element.appendChild(c.positioner as HTMLElement);
                (c as IUIBase).addedToParent();
            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#addElementAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        addChildAt(IRenderedObject(c).$displayObject, index);
                    else
                        addChildAt(c as DisplayObject, index);
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
	                (c as IUIBase).addedToParent();
                }

            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#getElementAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getElementAt(index:int):IChild
        {
            COMPILE::SWF {
                return getChildAt(index) as IChild;
            }
            COMPILE::JS {
                var children:NodeList = internalChildren();
                return children[index].royale_wrapper;
            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#getElementIndex()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getElementIndex(c:IChild):int
        {
            COMPILE::SWF {
                if (c is IRenderedObject)
                    return getChildIndex(IRenderedObject(c).$displayObject);

                return getChildIndex(c as DisplayObject);
            }
            COMPILE::JS {
                var children:NodeList = internalChildren();
                var n:int = children.length;
                for (var i:int = 0; i < n; i++)
                {
                    if (children[i] == c.positioner)
                        return i;
                }
                return -1;
            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#removeElement()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
         */
        public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF {
                if (c is IRenderedObject)
                {
                    removeChild(IRenderedObject(c).$displayObject);
                }
                else
                    removeChild(c as DisplayObject);
            }
            COMPILE::JS {
                element.removeChild(c.positioner as HTMLElement);
            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#numElements
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get numElements():int
        {
            COMPILE::SWF {
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
		
		COMPILE::JS
		protected var startupTimer:Timer;

		/**
		 * @royaleignorecoercion org.apache.royale.core.IBead
		 */
		COMPILE::JS
		public function start():void
		{
			if (model is IBead) addBead(model as IBead);
			if (controller is IBead) addBead(controller as IBead);
			
			for (var index:int in beads) {
				addBead(beads[index]);
			}
			sendEvent(this,"beadsAdded");
			
			if (sendEvent(this,new org.apache.royale.events.Event("preinitialize", false, true)))
				initialize();
			else {			
				startupTimer = new Timer(34, 0);
				startupTimer.addEventListener("timer", handleStartupTimer);
				startupTimer.start();
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::JS
		protected function handleStartupTimer(event:Event):void
		{
			if (sendEvent(this,new org.apache.royale.events.Event("preinitialize", false, true)))
			{
				startupTimer.stop();
				initialize();
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IBead
         * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		protected function initialize():void
		{
			MXMLDataInterpreter.generateMXMLInstances(this, instanceParent, MXMLDescriptor);
			
			sendEvent(this,'initialize');
			
			if (initialView)
			{
                initialView.applicationModel = model;
                addElement(initialView);
                
				var baseView:UIBase = initialView as UIBase;
				if (!isNaN(baseView.percentWidth) || !isNaN(baseView.percentHeight)) {
                    var style:CSSStyleDeclaration  = getStyle(this);
					style.height = window.innerHeight.toString() + 'px';
					style.width = window.innerWidth.toString() + 'px';
					sendEvent(initialView,"sizeChanged"); // kick off layout if % sizes
				}
				
				sendEvent(this,"viewChanged");
			}
			sendEvent(this,"applicationComplete");
		}
        
        COMPILE::SWF
        public function get $displayObject():DisplayObject
        {
            return this;
        }
        
        COMPILE::SWF
        override public function set width(value:Number):void
        {
            // just eat this.  
            // The stageWidth will be set by SWF metadata. 
            // Setting this directly doesn't do anything
        }
        
        COMPILE::SWF
        override public function set height(value:Number):void
        {
            // just eat this.  
            // The stageWidth will be set by SWF metadata. 
            // Setting this directly doesn't do anything
        }

        /**
         */
        public function get popUpHost():IPopUpHost
        {
            return this;
        }
    }
}
