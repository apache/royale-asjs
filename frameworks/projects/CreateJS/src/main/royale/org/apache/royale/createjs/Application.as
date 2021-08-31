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
package org.apache.royale.createjs
{	
	import org.apache.royale.core.ApplicationBase;
	import org.apache.royale.core.IApplicationView;
	import org.apache.royale.core.IChild;
    import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IValuesImpl;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.utils.MXMLDataInterpreter;
	
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import createjs.DisplayObject;
        import createjs.Stage;
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
     * This is the CreateJS Application class which must be used in place of the normal
	 * Royale Application. CreateJS uses the HTML5 &lt;canvas&gt;, rather than the HTML DOM. This
	 * class sets up the canvas and injects the necessary script elements into the index.html
	 * file to bootstrap CreateJS.
	 *
	 *  @see ViewBase
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	
	COMPILE::SWF
	public class Application extends org.apache.royale.core.Application
	{
		// does nothing different for SWF side
	}
	
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
    
	COMPILE::JS
	public class Application extends ApplicationBase implements IStrand, IParent, IEventDispatcher
	{
        /**
         * The Royale Compiler will inject html into the index.html file.  Surround with
         * "inject_script" tag as follows:
         *
         * <inject_script>
         * var script = document.createElement("script");
         * script.setAttribute("src", "https://code.createjs.com/easeljs-0.8.1.min.js");
         * document.head.appendChild(script);
	 * script = document.createElement("script");
	 * script.setAttribute("src", "https://code.createjs.com/tweenjs-0.6.2.min.js");
	 * document.head.appendChild(script);
         * </inject_script>
         */
		public function Application()
		{
			super();
		}
		        
        private var stage:Stage;
        
        /**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLBodyElement
         * @royaleignorecoercion HTMLCanvasElement
         * @royaleignorecoercion createjs.Stage
         */
		public function start():void
        {
            var body:HTMLBodyElement;
            var canvas:HTMLCanvasElement;
            
            // For createjs, the application is the same as the canvas
            // and it provides convenient access to the stage.
            
            element = document.createElement('canvas') as WrappedHTMLElement;
            canvas = element as HTMLCanvasElement;
            canvas.id = 'royaleCanvas';
            canvas.width = 700;
            canvas.height = 500;
            
            body = document.getElementsByTagName('body')[0] as HTMLBodyElement;
            body.appendChild(this.element);
            
            stage = new createjs.Stage('royaleCanvas');
			
			MXMLDataInterpreter.generateMXMLInstances(this, null, MXMLDescriptor);
            
            dispatchEvent('initialize');
			
			for (var index:int in beads) {
				addBead(beads[index]);
			}
			
			dispatchEvent(new org.apache.royale.events.Event("beadsAdded"));
            
            initialView.applicationModel = this.model;
            addElement(initialView);
            
            dispatchEvent('viewChanged');
            
            stage.update();
			
			dispatchEvent('applicationComplete');
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
        [Bindable("__NoChangeEvent__")]
        public function get initialView():IApplicationView
        {
            return _initialView;
        }
        
        /**
         *  @private
         */
        [Bindable("__NoChangeEvent__")]
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
		override public function get model():Object
		{
			return _model;
		}
		
		/**
		 *  @private
		 */
		[Bindable("__NoChangeEvent__")]
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
		
		/**
		 *  @copy org.apache.royale.core.IParent#addElement()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion createjs.DisplayObject
         *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			stage.addChild(c.element as DisplayObject);
            (c as IUIBase).addedToParent();
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
			stage.addChildAt(c.element as DisplayObject, index);
            (c as IUIBase).addedToParent();
		}
		
		/**
		 *  @copy org.apache.royale.core.IParent#getElementAt()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion org.apache.royale.core.IChild
		 */
		public function getElementAt(index:int):IChild
		{
			var c:WrappedHTMLElement = stage.getChildAt(index) as WrappedHTMLElement;
			return c.royale_wrapper as IChild;
		}
		
		/**
		 *  @copy org.apache.royale.core.IParent#getElementIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion createjs.DisplayObject
		 */
		public function getElementIndex(c:IChild):int
		{
			return stage.getChildIndex(c.element as DisplayObject)
		}
		
		/**
		 *  @copy org.apache.royale.core.IParent#removeElement()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			stage.removeChild(c.element as DisplayObject);
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
			return stage.numChildren;
		}
	}
}
