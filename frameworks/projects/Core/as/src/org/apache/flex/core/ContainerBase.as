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
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IMXMLDocument;
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
     *  @productversion FlexJS 0.0
     */
    [Event(name="stateChangeComplete", type="org.apache.flex.events.Event")]
    
    /**
     *  Indicates that the initialization of the container is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="initComplete", type="org.apache.flex.events.Event")]
    
    /**
     *  Indicates that the children of the container is have been added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="childrenAdded", type="org.apache.flex.events.Event")]
    
	[DefaultProperty("mxmlContent")]
    
    /**
     *  The ContainerBase class is the base class for most containers
     *  in FlexJS.  It is usable as the root tag of MXML
     *  documents and UI controls and containers are added to it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ContainerBase extends UIBase implements IMXMLDocument, IStatesObject, IContainer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ContainerBase()
		{
			super();
            actualParent = this;
		}
		
        /**
         *  False if IChrome children are treated just like
         *  any other children.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected var supportsChromeChildren:Boolean = true;
        
        private var actualParent:DisplayObjectContainer;
        
        /**
         *  Set a platform-specific object as the actual parent for 
         *  children.  This must be public so it can be accessed
         *  by beads.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function setActualParent(parent:DisplayObjectContainer):void
        {
            actualParent = parent;	
        }
        
        /**
         *  @private
         */
        override public function getElementIndex(c:Object):int
        {
            if (c is IUIBase)
                return actualParent.getChildIndex(IUIBase(c).element as DisplayObject);
            else
                return actualParent.getChildIndex(c as DisplayObject);
        }
        
        /**
         *  @private
         */
        override public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
            {
                if (supportsChromeChildren && c is IChrome) {
                    addChild(IUIBase(c).element as DisplayObject);
                    IUIBase(c).addedToParent();
                }
                else {
                    actualParent.addChild(IUIBase(c).element as DisplayObject);
                    IUIBase(c).addedToParent();
                }
            }
            else {
                if (supportsChromeChildren && c is IChrome) {
                    addChild(c as DisplayObject);
                }
                else {
                    actualParent.addChild(c as DisplayObject);
                }
            }
            if (dispatchEvent)
                this.dispatchEvent(new Event("childrenAdded"));
        }
        
        /**
         *  @private
         */
        override public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
            {
                if (supportsChromeChildren && c is IChrome) {
                    addChildAt(IUIBase(c).element as DisplayObject, index);
                    IUIBase(c).addedToParent();
                }
                else {
                    actualParent.addChildAt(IUIBase(c).element as DisplayObject, index);
                    IUIBase(c).addedToParent();
                }
            }
            else {
                if (supportsChromeChildren && c is IChrome) {
                    addChildAt(c as DisplayObject, index);
                } else {
                    actualParent.addChildAt(c as DisplayObject, index);
                }
            }
            if (dispatchEvent)
                this.dispatchEvent(new Event("childrenAdded"));
        }
        
        /**
         *  @private
         */
        override public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
			{
				if (supportsChromeChildren && c is IChrome) {
					removeChild(IUIBase(c).element as DisplayObject);
				}
				else {
					actualParent.removeChild(IUIBase(c).element as DisplayObject);
				}
			}
			else {
				actualParent.removeChild(c as DisplayObject);
			}    
            
            if (dispatchEvent)
                this.dispatchEvent(new Event("childrenRemoved"));
        }
        
        /**
         *  Get the array of children.  To change the children use
         *  addElement, removeElement.
         */
        public function getChildren():Array
        {
            var children:Array = [];
            var n:int = actualParent.numChildren;
            for (var i:int = 0; i < n; i++)
                children.push(actualParent.getChildAt(i));
            return children;
        }
        
        /**
         *  @private
         */
        public function childrenAdded():void
        {
            dispatchEvent(new Event("childrenAdded"));
        }
        
        /**
         *  A ContainerBase doesn't create its children until it is added to
         *  a parent.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function addedToParent():void
		{
            if (!_initialized)
            {
    			// each MXML file can also have styles in fx:Style block
    			ValuesManager.valuesImpl.init(this);
            }
            
			super.addedToParent();
			
            if (!_initialized)
            {
    			MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
			
                dispatchEvent(new Event("initBindings"));
    			dispatchEvent(new Event("initComplete"));
                _initialized = true;
            }
		}

        private var _mxmlDescriptor:Array;
        private var _mxmlDocument:Object = this;
        private var _initialized:Boolean;
        
        /**
         *  @copy org.apache.flex.core.Application#MXMLDescriptor
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get MXMLDescriptor():Array
		{
			return _mxmlDescriptor;
		}

        /**
         *  @private
         */
        public function setMXMLDescriptor(document:Object, value:Array):void
        {
            _mxmlDocument = document;
            _mxmlDescriptor = value;
        }

        /**
         *  @copy org.apache.flex.core.Application#generateMXMLAttributes()
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
         *  @copy org.apache.flex.core.ItemRendererClassFactory#mxmlContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var mxmlContent:Array;
		
        private var _states:Array;
        
        /**
         *  The array of view states. These should
         *  be instances of org.apache.flex.states.State.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get states():Array
        {
            return _states;
        }

        /**
         *  @private
         */
        public function set states(value:Array):void
        {
            _states = value;
            _currentState = _states[0].name;
            
			try{
				if (getBeadByType(IStatesImpl) == null)
					addBead(new (ValuesManager.valuesImpl.getValue(this, "iStatesImpl")) as IBead);
			}
			//TODO:  Need to handle this case more gracefully
			catch(e:Error)
			{
				trace(e.message);
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
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
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