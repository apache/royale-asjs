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
    import org.apache.flex.utils.Timer;

    COMPILE::SWF {
        import flash.display.DisplayObject;
        import flash.display.Graphics;
        import flash.display.Sprite;
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
     *  put on the display list. This event is sent before
     *  applicationComplete is dispatched.
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
	 *  A SWF application must be bootstrapped by a Flash Sprite.
	 *  The factory class is the default bootstrap.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Frame(factoryClass="org.apache.flex.core.ApplicationFactory")]

    /**
     *  The Application class is the main class and entry point for a FlexJS
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
     *  @productversion FlexJS 0.0
     */
    public class Application extends ApplicationBase implements IStrand, IParent, IEventDispatcher, ISWFApplication
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
        }

		/**
		 *  Application wraps the root object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		COMPILE::SWF
		public function setRoot(r:WrappedMovieClip):void
		{
			element = r;	
			MouseEventConverter.setupAllConverters(r.stage);
            MouseEventConverter.setupAllConverters(r.stage, false);
			initHandler();
		}
		
        COMPILE::SWF
        private function initHandler():void
        {
			if (model is IBead) addBead(model as IBead);
			if (controller is IBead) addBead(controller as IBead);

            for each (var bead:IBead in beads)
                addBead(bead);

            dispatchEvent(new org.apache.flex.events.Event("beadsAdded"));

            if (dispatchEvent(new org.apache.flex.events.Event("preinitialize", false, true)))
                initialize();
            else
                addEventListener(flash.events.Event.ENTER_FRAME, enterFrameHandler);

        }

        COMPILE::SWF
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
		 *  @flexjsignorecoercion org.apache.flex.core.IBead
         */
        protected function initialize():void
        {
            MXMLDataInterpreter.generateMXMLInstances(this, null, MXMLDescriptor);

            dispatchEvent(new org.apache.flex.events.Event("initialize"));

            if (initialView)
            {
                initialView.applicationModel =  model;
        	    this.addElement(initialView);
				
				COMPILE::SWF
				{	
                // if someone has installed a resize listener, fake an event to run it now
                if ($displayObject.stage.hasEventListener("resize"))
					$displayObject.stage.dispatchEvent(new flash.events.Event("resize"));
                else if (initialView is ILayoutChild)
                {
                    var ilc:ILayoutChild = initialView as ILayoutChild;
                    // otherwise, size once like this
                    if (!isNaN(ilc.percentWidth) && !isNaN(ilc.percentHeight))
                        ilc.setWidthAndHeight($displayObject.stage.stageWidth, $displayObject.stage.stageHeight, true);
                    else if (!isNaN(ilc.percentWidth))
                        ilc.setWidth($displayObject.stage.stageWidth);
                    else if (!isNaN(ilc.percentHeight))
                        ilc.setHeight($displayObject.stage.stageHeight);
                }
				}
				COMPILE::JS
				{	
				var baseView:UIBase = initialView as UIBase;
				if (!isNaN(baseView.percentWidth) || !isNaN(baseView.percentHeight)) {
					this.element.style.height = window.innerHeight.toString() + 'px';
					this.element.style.width = window.innerWidth.toString() + 'px';
					this.initialView.dispatchEvent('sizeChanged'); // kick off layout if % sizes
				}
				}
				COMPILE::SWF
				{
                var bgColor:Object = ValuesManager.valuesImpl.getValue(this, "background-color");
                if (bgColor != null)
                {
                    var backgroundColor:uint = ValuesManager.valuesImpl.convertColor(bgColor);
                    var graphics:Graphics = Sprite($displayObject).graphics;
					graphics.beginFill(backgroundColor);
					graphics.drawRect(0, 0, initialView.width, initialView.height);
					graphics.endFill();
                }
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
        [Bindable("__NoChangeEvent__")]
        public var initialView:IApplicationView;

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

        private var _elements:Array;

        /**
         *  @copy org.apache.flex.core.IParent#addElement()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.IUIBase
         *  @flexjsignorecoercion HTMLElement
         */
        public function addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF
            {
                if(_elements == null)
                    _elements = [];
                _elements[_elements.length] = c;
				$displayObjectContainer.addChild(c.$displayObject);
                if (c is IUIBase)
                {
                    IUIBase(c).addedToParent();
                }
            }
            COMPILE::JS {
                this.element.appendChild(c.element as HTMLElement);
                (c as IUIBase).addedToParent();
            }
        }

        /**
         *  @copy org.apache.flex.core.IParent#addElementAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.IUIBase
         */
        public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF
            {
                if(_elements == null)
                    _elements = [];
                _elements.splice(index,0,c);

				$displayObjectContainer.addChildAt(c.$displayObject,index);

                if (c is IUIBase)
                {
                    IUIBase(c).addedToParent();
                }
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
         *  @copy org.apache.flex.core.IParent#getElementAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getElementAt(index:int):IChild
        {
            COMPILE::SWF
            {
                if(_elements == null)
                    return null;
                return _elements[index];
            }
            COMPILE::JS
            {
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
        public function getElementIndex(c:IChild):int
        {
            COMPILE::SWF
            {
                if(_elements == null)
                    return -1;
                return _elements.indexOf(c);
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
         *  @flexjsignorecoercion HTMLElement
         */
        public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF
            {
                if(_elements)
                {
                    var idx:int = _elements.indexOf(c);
                    if(idx>=0)
                        _elements.splice(idx,1);
                }
				$displayObjectContainer.removeChild(c.$displayObject as DisplayObject);
            }
            COMPILE::JS
            {
                element.removeChild(c.element as HTMLElement);
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
            COMPILE::SWF
            {
                return _elements ? _elements.length : 0;
            }
            COMPILE::JS
            {
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
		 * @flexjsignorecoercion org.apache.flex.core.IBead
		 */
		COMPILE::JS
		public function start():void
		{
			element = document.getElementsByTagName('body')[0];
			element.flexjs_wrapper = this;
			element.className = 'Application';
			
			if (model is IBead) addBead(model as IBead);
			if (controller is IBead) addBead(controller as IBead);
			
			for (var index:int in beads) {
				addBead(beads[index]);
			}
			
			dispatchEvent(new org.apache.flex.events.Event("beadsAdded"));
			
			if (dispatchEvent(new org.apache.flex.events.Event("preinitialize", false, true)))
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
			if (dispatchEvent(new org.apache.flex.events.Event("preinitialize", false, true)))
			{
				startupTimer.stop();
				initialize();
			}
		}
		
    }
}
