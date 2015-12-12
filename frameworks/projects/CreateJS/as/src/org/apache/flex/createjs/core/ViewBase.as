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
package org.apache.flex.createjs.core
{
    COMPILE::AS3
    {
        import flash.display.DisplayObject;            
        import org.apache.flex.core.ViewBase;
    }
	
    import org.apache.flex.core.IApplicationView;
    import org.apache.flex.core.IParent;
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.events.Event;
    import org.apache.flex.utils.MXMLDataInterpreter;
    
    COMPILE::JS
    {
        import org.apache.flex.core.IBead;
        import org.apache.flex.core.IStatesImpl;
        import org.apache.flex.core.ValuesManager;
        import org.apache.flex.events.ValueChangeEvent;
        import org.apache.flex.states.State;
    }
	
    COMPILE::AS3
    public class ViewBase extends org.apache.flex.core.ViewBase
    {
        
    }
    
	[DefaultProperty("mxmlContent")]
    COMPILE::JS
	public class ViewBase extends UIBase implements IParent, IApplicationView
	{
		public function ViewBase()
		{
			super();
		}
		
		override public function addedToParent():void
		{
            /* AJH needed?
			MXMLDataInterpreter.generateMXMLProperties(this, MXMLProperties);
            */
			MXMLDataInterpreter.generateMXMLInstances(this, this, MXMLDescriptor);
		}
		
		public function get MXMLDescriptor():Array
		{
			return null;
		}
		
        /*
		public function get MXMLProperties():Array
		{
			return null;
		}
		*/
        
		public var mxmlContent:Array;
		
		private var _applicationModel:Object;
		
		[Bindable("modelChanged")]
		public function get applicationModel():Object
		{
			return _applicationModel;
		}
        
        public function set applicationModel(value:Object):void
        {
            _applicationModel = value;
            dispatchEvent(new Event("modelChanged"));
        }

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
