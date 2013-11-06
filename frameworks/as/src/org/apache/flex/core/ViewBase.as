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
	import mx.states.State;
	
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.utils.MXMLDataInterpreter;

	[Event(name="initComplete", type="org.apache.flex.events.Event")]
	[DefaultProperty("mxmlContent")]
	public class ViewBase extends UIBase implements IPopUpHost
	{
		public function ViewBase()
		{
			super();
		}
		
		override public function addedToParent():void
		{
			// each MXML file can also have styles in fx:Style block
			ValuesManager.valuesImpl.init(this);
			
			MXMLDataInterpreter.generateMXMLProperties(this, mxmlProperties);
			MXMLDataInterpreter.generateMXMLInstances(this, this, MXMLDescriptor);
			
			dispatchEvent(new Event("initComplete"))
		}
		
		public function get MXMLDescriptor():Array
		{
			return null;
		}
		
		private var mxmlProperties:Array ;
		
		public function generateMXMLAttributes(data:Array):void
		{
			mxmlProperties = data;
		}
		
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
        
        public function get states():Array
        {
            return _states;
        }
        public function set states(value:Array):void
        {
            _states = value;
            if (getBeadByType(IStatesImpl) == null)
                addBead(new (ValuesManager.valuesImpl.getValue(this, "iStatesImpl")) as IBead);
            
        }
        
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
        
        public function get currentState():String
        {
            return _currentState;   
        }
        public function set currentState(value:String):void
        {
            var event:ValueChangeEvent = new ValueChangeEvent("currentStateChanged", false, false, _currentState, value)
            _currentState = value;
            dispatchEvent(event);
        }
        
        private var _transitions:Array;
        
        public function get transitions():Array
        {
            return _transitions;   
        }
        public function set transitions(value:Array):void
        {
            _transitions = value;   
        }

    }
}