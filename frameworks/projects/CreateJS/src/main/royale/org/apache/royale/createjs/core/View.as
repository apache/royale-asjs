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
package org.apache.royale.createjs.core
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.IApplicationView;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IPopUpHostParent;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.IStatesImpl;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.states.State;
	import org.apache.royale.utils.MXMLDataInterpreter;	
	
	COMPILE::JS 
	{
		import createjs.Stage;
		import createjs.Container;
		import org.apache.royale.core.WrappedHTMLElement;
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
	[Event(name="initComplete", type="org.apache.royale.events.Event")]
	
	[DefaultProperty("mxmlContent")]
	
	/**
	 * This version of View is specific for CreateJS since CreateJS does not
	 * use the HTML DOM. 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */
		
	COMPILE::SWF
	public class View extends org.apache.royale.core.ViewBase
	{
		// nothing different for the SWF version
	}
	
	[Event(name="initComplete", type="org.apache.royale.events.Event")]
	
	[DefaultProperty("mxmlContent")]
	
	COMPILE::JS
	public class View extends UIBase implements IPopUpHost, IApplicationView, IContainer, IPopUpHostParent
	{
		private var _applicationModel:Object;
		
		[Bindable("modelChanged")]
		
		/**
		 *  A reference to the Application's model.  Usually,
		 *  a view is displaying the main model for an
		 *  application.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get applicationModel():Object
		{
			return _applicationModel;
		}
		
		/**
		 *  @private
		 */
		public function set applicationModel(value:Object):void
		{
			_applicationModel = value;
			dispatchEvent(new Event("modelChanged"));
		}
		
		public function get strandChildren():IParent
		{
			return this;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion createjs.Container
		 */
		override protected function createElement():WrappedHTMLElement
		{
			if (!element) {
				var container:createjs.Container = new createjs.Container();
				container.name = 'viewbase';
				container.x = 0;
				container.y = 0;
				element = container as WrappedHTMLElement;
			}
			return element;
		}
		
		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
		
		
		/**
		 *  A ViewBase doesn't create its children until it is added to
		 *  a parent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @copy org.apache.royale.core.Application#generateMXMLAttributes()
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
		 *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var mxmlContent:Array;
		
		private var _states:Array;
		
		/**
		 *  The array of view states. These should
		 *  be instances of org.apache.royale.states.State.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
        
        /**
         *  ViewBase can host popups but they will be in the layout, if any
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
         */
        public function get popUpHost():IPopUpHost
        {
            return this;
        }
	}
}
