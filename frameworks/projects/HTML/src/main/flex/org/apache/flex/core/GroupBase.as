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
//	import org.apache.flex.core.IMXMLDocument;
	import org.apache.flex.core.IContentViewHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.states.State;
	import org.apache.flex.utils.MXMLDataInterpreter;

    /**
     *  Indicates that the state change has completed.  All properties
     *  that need to change have been changed, and all transitinos
     *  that need to run have completed.  However, any deferred work
     *  may not be completed, and the screen may not be updated until
     *  code stops executing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    [Event(name="stateChangeComplete", type="org.apache.flex.events.Event")]
    
    /**
     *  Indicates that the initialization of the container is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    [Event(name="initComplete", type="org.apache.flex.events.Event")]
    
    /**
     *  Indicates that the children of the container is have been added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    [Event(name="childrenAdded", type="org.apache.flex.events.Event")]
    
	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
//	[DefaultProperty("mxmlContent")]
    
    /**
     *  The GroupBase class is the base class for most simple containers
     *  in FlexJS.  It is usable as the root tag of MXML
     *  documents and UI controls and containers are added to it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
	public class GroupBase extends UIBase implements IStatesObject, ILayoutParent, ILayoutView, IContentViewHost
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function GroupBase()
		{
			super();            
		}
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElement('div') as WrappedHTMLElement;
			element.flexjs_wrapper = this;
			
			positioner = element;
			
			return element;
		}
        
        /**
         *  @private
         */
        public function childrenAdded():void
        {
            dispatchEvent(new Event("childrenAdded"));
        }
		
		/**
		 * @private
		 */
//		override public function addedToParent():void
//		{
//			if (!_initialized)
//			{
//				// each MXML file can also have styles in fx:Style block
//				ValuesManager.valuesImpl.init(this);
//			}
//			
//			super.addedToParent();
//			
//			if (!_initialized)
//			{
//				MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
//				
//				dispatchEvent(new Event("initBindings"));
//				dispatchEvent(new Event("initComplete"));
//				_initialized = true;
//				
//				childrenAdded();
//			}
//		}
		
		/**
		 * Returns the ILayoutHost which is its view. From ILayoutParent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function getLayoutHost():ILayoutHost
		{
			return view as ILayoutHost;
		}
		
		/**
		 * @copy org.apache.flex.core.IContentViewHost#strandChildren
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
		 */
		public function get strandChildren():IParent
		{
			return this;
		}

//        private var _mxmlDescriptor:Array;
//        private var _mxmlDocument:Object = this;
//        private var _initialized:Boolean;
        
        /**
         *  @copy org.apache.flex.core.Application#MXMLDescriptor
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
//		public function get MXMLDescriptor():Array
//		{
//			return _mxmlDescriptor;
//		}

        /**
         *  @private
         */
//        public function setMXMLDescriptor(document:Object, value:Array):void
//        {
//            _mxmlDocument = document;
//            _mxmlDescriptor = value;
//        }

        /**
         *  @copy org.apache.flex.core.Application#generateMXMLAttributes()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
//		public function generateMXMLAttributes(data:Array):void
//		{
//            MXMLDataInterpreter.generateMXMLProperties(this, data);
//		}
		
        /**
         *  @copy org.apache.flex.core.ItemRendererClassFactory#mxmlContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
//		public var mxmlContent:Array;
		
        private var _states:Array;
        
        /**
         *  The array of view states. These should
         *  be instances of org.apache.flex.states.State.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get states():Array
        {
            return _states;
        }

        /**
         *  @private
         *  @flexjsignorecoercion Class
         *  @flexjsignorecoercion org.apache.flex.core.IBead
         */
        public function set states(value:Array):void
        {
            _states = value;
            _currentState = _states[0].name;
            
			try{
				if (getBeadByType(IStatesImpl) == null)
                {
                    var c:Class = ValuesManager.valuesImpl.getValue(this, "iStatesImpl") as Class;
                    var b:Object = new c();
					addBead(b as IBead);
                }
			}
			//TODO:  Need to handle this case more gracefully
			catch(e:Error)
			{
                COMPILE::SWF
                {
                    trace(e.message);                        
                }
			}
            
        }
        
        /**
         *  <code>true</code> if the array of states
         *  contains a state with this name.
         * 
         *  @param state The state namem.
         *  @return True if state in state array
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function hasState(state:String):Boolean
        {
            for each (var s:State in _states)
            {
                if (s.name == state)
                    return true;
            }
            return false;
        }
        
        private var _currentState:String;
        
        [Bindable("currentStateChange")]
        /**
         *  The name of the current state.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get currentState():String
        {
            return _currentState;   
        }

        /**
         *  @private
         */
        public function set currentState(value:String):void
        {
            var event:ValueChangeEvent = new ValueChangeEvent("currentStateChange", false, false, _currentState, value)
            _currentState = value;
            dispatchEvent(event);
        }
        
        private var _transitions:Array;
        
        /**
         *  The array of transitions.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get transitions():Array
        {
            return _transitions;   
        }
        
        /**
         *  @private
         */
        public function set transitions(value:Array):void
        {
            _transitions = value;   
        }

    }
}
