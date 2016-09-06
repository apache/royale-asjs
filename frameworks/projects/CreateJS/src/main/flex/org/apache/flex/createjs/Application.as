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
package org.apache.flex.createjs
{	
	import org.apache.flex.core.ApplicationBase;
	import org.apache.flex.core.IApplicationView;
	import org.apache.flex.core.IChild;
    import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IValuesImpl;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.utils.MXMLDataInterpreter;
	
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
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
	 *  The Application class is the main class and entry point for a FlexJS
	 *  application.  This Application class is different than the
	 *  Flex SDK's mx:Application or spark:Application in that it does not contain
	 *  user interface elements.  Those UI elements go in the views (ViewBase).  This
	 *  Application class expects there to be a main model, a controller, and
	 *  an initial view.
	 * 
     * This is the CreateJS Application class which must be used in place of the normal
	 * FlexJS Application. CreateJS uses the HTML5 &lt;canvas&gt;, rather than the HTML DOM. This
	 * class sets up the canvas and injects the necessary HTML elements into the index.html
	 * file to bootstrap CreateJS.
	 *
	 *  @see ViewBase
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	
	COMPILE::SWF
	public class Application extends org.apache.flex.core.Application
	{
		// does nothing different for SWF side
	}
	
	COMPILE::JS
	public class Application extends ApplicationBase implements IStrand, IParent, IEventDispatcher
	{
        /**
         * FalconJX will inject html into the index.html file.  Surround with
         * "inject_html" tag as follows:
         *
         * <inject_html>
         * <script src="https://code.createjs.com/easeljs-0.8.1.min.js"></script>
		 * <script src="https://code.createjs.com/tweenjs-0.6.2.min.js"></script>
         * </inject_html>
         */
		public function Application()
		{
			super();
		}
		        
        private var stage:Stage;
        
        /**
		 * @private
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLBodyElement
         * @flexjsignorecoercion HTMLCanvasElement
         * @flexjsignorecoercion createjs.Stage
         */
		public function start():void
        {
            var body:HTMLBodyElement;
            var canvas:HTMLCanvasElement;
            
            // For createjs, the application is the same as the canvas
            // and it provides convenient access to the stage.
            
            element = document.createElement('canvas') as WrappedHTMLElement;
            element.flexjs_wrapper = this;
            canvas = element as HTMLCanvasElement;
            canvas.id = 'flexjsCanvas';
            canvas.width = 700;
            canvas.height = 500;
            
            body = document.getElementsByTagName('body')[0] as HTMLBodyElement;
            body.appendChild(this.element);
            
            stage = new createjs.Stage('flexjsCanvas');
			
			MXMLDataInterpreter.generateMXMLInstances(this, null, MXMLDescriptor);
            
            dispatchEvent('initialize');
			
			for (var index:int in beads) {
				addBead(beads[index]);
			}
			
			dispatchEvent(new org.apache.flex.events.Event("beadsAdded"));
            
            initialView.applicationModel = this.model;
            addElement(initialView);
            
            dispatchEvent('viewChanged');
            
            stage.update();
			
			dispatchEvent('applicationComplete');
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
		 *  The data model (for the initial view).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		[Bindable("__NoChangeEvent__")]		
		private var _model:Object;
		
		/**
		 *  The data model (for the initial view).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		
		/**
		 *  @copy org.apache.flex.core.IParent#addElement()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion createjs.DisplayObject
         *  @flexjsignorecoercion org.apache.flex.core.IUIBase
		 */
		public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			stage.addChild(c.element as DisplayObject);
            (c as IUIBase).addedToParent();
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
			stage.addChildAt(c.element as DisplayObject, index);
            (c as IUIBase).addedToParent();
		}
		
		/**
		 *  @copy org.apache.flex.core.IParent#getElementAt()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *  @flexjsignorecoercion org.apache.flex.core.IChild
		 */
		public function getElementAt(index:int):IChild
		{
			var c:WrappedHTMLElement = stage.getChildAt(index) as WrappedHTMLElement;
			return c.flexjs_wrapper as IChild;
		}
		
		/**
		 *  @copy org.apache.flex.core.IParent#getElementIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion createjs.DisplayObject
		 */
		public function getElementIndex(c:IChild):int
		{
			return stage.getChildIndex(c.element as DisplayObject)
		}
		
		/**
		 *  @copy org.apache.flex.core.IParent#removeElement()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			stage.removeChild(c.element as DisplayObject);
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
			return stage.numChildren;
		}
	}
}
