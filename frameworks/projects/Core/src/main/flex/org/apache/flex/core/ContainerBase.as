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
	public class ContainerBase extends UIBase implements IMXMLDocument, IStatesObject, IContainer, IContentViewHost
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
            
			_strandChildren = new ContainerBaseStrandChildren(this);
		}
		
		private var _strandChildren:ContainerBaseStrandChildren;
		
		/**
		 * @private
		 */
		public function get strandChildren():IParent
		{
			return _strandChildren;
		}
        
        /**
         *  @copy org.apache.flex.core.IParent#getElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        override public function getElementAt(index:int):IVisualElement
        {
            var contentView:IParent = view as IParent;
            if (contentView != null) {
                return contentView.getElementAt(index);
            } else {
                return super.getElementAt(index);
            }
        }        
        
        /**
         *  @private
         */
        override public function getElementIndex(c:IVisualElement):int
        {
			var contentView:IParent = view as IParent;
			if (contentView != null) {
				return contentView.getElementIndex(c);
			} else {
				return super.getElementIndex(c);
			}
        }
        
        /**
         *  @private
         */
        override public function addElement(c:IVisualElement, dispatchEvent:Boolean = true):void
        {
			var contentView:IParent = view as IParent;
			if (contentView != null) {
				contentView.addElement(c, dispatchEvent);
                if (dispatchEvent)
                    this.dispatchEvent(new Event("childrenAdded"));
			}
			else {
				super.addElement(c);
			}
        }
        
        /**
         *  @private
         */
        override public function addElementAt(c:IVisualElement, index:int, dispatchEvent:Boolean = true):void
        {
			var contentView:IParent = view as IParent;
			if (contentView != null) {
				contentView.addElementAt(c, index, dispatchEvent);
                if (dispatchEvent)
                    this.dispatchEvent(new Event("childrenAdded"));
			}
			else {
				super.addElementAt(c, index);
			}
        }
        
        /**
         *  @private
         */
        override public function removeElement(c:IVisualElement, dispatchEvent:Boolean = true):void
        {
			var contentView:IParent = view as IParent;
			if (contentView != null) {
				contentView.removeElement(c, dispatchEvent);
                if (dispatchEvent)
                    this.dispatchEvent(new Event("childrenRemoved"));
			}
			else {
				super.removeElement(c);
			}
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
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $numElements():int
		{
			return super.numElements();
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $addElement(c:IVisualElement, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $addElementAt(c:IVisualElement, index:int, dispatchEvent:Boolean = true):void
		{
			super.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $removeElement(c:IVisualElement, dispatchEvent:Boolean = true):void
		{
			super.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $getElementIndex(c:IVisualElement):int
		{
			return super.getElementIndex(c);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $getElementAt(index:int):IVisualElement
		{
			return super.getElementAt(index);
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
                COMPILE::AS3
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
