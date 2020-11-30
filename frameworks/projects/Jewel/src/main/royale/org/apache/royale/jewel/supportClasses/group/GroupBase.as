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
package org.apache.royale.jewel.supportClasses.group
{
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainer;
    import org.apache.royale.core.IContentViewHost;
    import org.apache.royale.core.ILayoutHost;
    import org.apache.royale.core.ILayoutParent;
    import org.apache.royale.core.ILayoutView;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IState;
    import org.apache.royale.core.IStatesImpl;
    import org.apache.royale.core.IStatesObject;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.ValueChangeEvent;
    import org.apache.royale.events.ValueEvent;
    import org.apache.royale.utils.loadBeadFromValuesManager;

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
     *  @productversion Royale 0.9.7
     */
    [Event(name="stateChangeComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  Indicates that the initialization of the container is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="initComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  Indicates that the children of the container is have been added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="childrenAdded", type="org.apache.royale.events.Event")]
    
    /**
     *  The Jewel GroupBase class is the base class for most simple containers
     *  in Royale. It is usable as the root tag of MXML
     *  documents and UI controls and containers are added to it.
     *  
     *  Unlike Basic version that inherits from UIBase, this class inherits from
     *  StyledUIBase that's the main class for Jewel components and containers
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class GroupBase extends StyledUIBase implements IStatesObject, IContainer, ILayoutParent, ILayoutView, IContentViewHost
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function GroupBase()
		{
			super();            
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this,'div');
		}
		
        /**
         * @private
         */
		override public function addedToParent():void
		{
			super.addedToParent();
			
            addLayoutBead();
		}

        /**
		 * Load the layout bead if it hasn't already been loaded.
         * 
         * @private
         */
        protected function addLayoutBead():void {
			loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);
		}
		
		/*
		 * IContainer
		 */
        
        /**
         *  @private
         */
        public function childrenAdded():void
        {
            dispatchEvent(new ValueEvent("childrenAdded"));
        }
		
		/*
		 * Utility
		 */
		
		/**
		 * Dispatches a "layoutNeeded" event
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
		 */
		public function layoutNeeded():void
		{
			dispatchEvent( new Event("layoutNeeded") );
		}
		
		/*
		 * ILayoutParent
		 */
		
		/**
		 *  Returns the ILayoutHost which is its view. From ILayoutParent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
         *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 */
		public function getLayoutHost():ILayoutHost
		{
			return view as ILayoutHost;
		}
		
		/**
		 * @copy org.apache.royale.core.IContentViewHost#strandChildren
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
		 */
		public function get strandChildren():IParent
		{
			return this;
		}
		
        private var _states:Array;
        /**
         *  The array of view states. These should
         *  be instances of org.apache.royale.states.State.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get states():Array
        {
            return _states;
        }
        /**
         *  @private
         *  @royaleignorecoercion Class
         *  @royaleignorecoercion org.apache.royale.core.IBead
         */
        public function set states(value:Array):void
        {
            _states = value;
            _currentState = _states[0].name;
            
			try{
    			loadBeadFromValuesManager(IStatesImpl, "iStatesImpl", this);
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
         *  @productversion Royale 0.9.7
         */
        public function hasState(state:String):Boolean
        {
            for each (var s:IState in _states)
            {
                if (s.name == state)
                    return true;
            }
            return false;
        }
        
        private var _currentState:String;
        /**
         *  The name of the current state.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        [Bindable("currentStateChange")]
        public function get currentState():String
        {
            return _currentState;   
        }
        /**
         *  @private
         */
        public function set currentState(value:String):void
        {
			if (value == _currentState) return;
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
         *  @productversion Royale 0.9.7
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

        /*
		 * IParent
		 */

		/**
		 * @private
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenAdded", c));
		}
		
		/**
		 * @private
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			super.addElementAt(c, index, dispatchEvent);
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenAdded", c));
		}

		/**
		 * @private
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.removeElement(c, dispatchEvent);
			//TODO This should possibly be ultimately refactored to be more PAYG
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenRemoved", c));
		}

    }
}
