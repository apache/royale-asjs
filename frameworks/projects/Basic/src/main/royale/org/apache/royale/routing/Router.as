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
package org.apache.royale.routing
{
  import org.apache.royale.core.IStrand;
  import org.apache.royale.events.Event;
  import org.apache.royale.core.IInitialViewApplication;
  import org.apache.royale.core.Strand;
  import org.apache.royale.core.IBead;
  import org.apache.royale.events.IEventDispatcher;
  import org.apache.royale.events.ValueEvent;
  import org.apache.royale.core.IMXMLDocument;
  import org.apache.royale.utils.MXMLDataInterpreter;
  import org.apache.royale.utils.sendStrandEvent;
  import org.apache.royale.utils.loadBeadFromValuesManager;
  import org.apache.royale.utils.callLater;
  [DefaultProperty("beads")]
	/**
	 *  Dispatched when the state is changed.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="stateChange", type="org.apache.royale.events.Event")]

	/**
	 *  Dispatched when bindings are initialized
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="initBindings", type="org.apache.royale.events.Event")]

	/**
	 * Router is deprecated. Please use HashRouter or BrowserRouter instead.
   * Router is a bead which automatically handles browsing history.
	 * It could be attached to any strand, but typically it would be attached to Application or View
	 * Listen to stateChange events to handle changes to browsing history and use setState and renderState for modifying the history.
	 * The state of the router can be modified before committing the state changes.
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
   *  @deprecated
	 */
	[Deprecated(message="Use BrowserRouter or HashRouter instead")]
  public class Router extends Strand implements IRouter, IBead, IMXMLDocument
  {
		[Deprecated(message="Use BrowserRouter or HashRouter instead")]
		public function Router()
		{

		}

		public function get host():IStrand
		{
		  return _strand;
		}

		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{	
			_strand = value;
			loadBeadFromValuesManager(IPathRouteBead, "iPathRouteBead", this);
			COMPILE::JS
			{
				window.addEventListener("hashchange", hashChangeHandler);
			}

			// wait until the app is initialized. Calling onInit async soves this problem
			callLater(onInit);
		}

		/**
		 * Helper function to attach event listener without the need for casting
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function listenOnStrand(eventType:String,handler:Function,capture:Boolean=false):void
		{
		  (_strand as IEventDispatcher).addEventListener(eventType, handler, capture);
		}

		protected function onInit(event:Event):void
		{
		  if(beads)
		  {
			for each (var bead:IBead in beads)
			  addBead(bead);
		  }
		  // needed for binding in MXML
		  dispatchEvent(new Event("initBindings"));

		  COMPILE::JS
		  {
			if(location.hash)
			{
			  hashChangeHandler();
			}
			else// if there's no hash we should still dispatch a stateChange event so the beads can set defaults
			{
			  dispatchEvent(new Event("stateChange"));
			}
		  }
		}

		private function hashChangeHandler():void
		{
			parseHash();
			dispatchEvent(new Event("stateChange"));
		}

		private function parseHash():void
		{
		  //TODO SWF implementation
		  COMPILE::JS
		  {
			var hash:String = location.hash;
			var index:int = 0;
			if(hash.indexOf("!")==1){
			  index = 1;
			}
			hash = hash.slice(index+1);
			var ev:ValueEvent = new ValueEvent("urlReceived",hash);
			dispatchEvent(ev);
		  }
		}

		private var _routeState:RouteState;

		public function get routeState():RouteState
		{
		  if(!_routeState){
			_routeState = new RouteState();
		  }
			return _routeState;
		}

		public function set routeState(value:RouteState):void
		{
			_routeState = value;
		}
		/**
		 * Commits the current state to the browsing history
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function setState():void
		{
		  COMPILE::JS
		  {
			var hash:String = "#!";
			var ev:ValueEvent = new ValueEvent("urlNeeded","");
			dispatchEvent(ev);
			var stateEv:ValueEvent = new ValueEvent("stateNeeded",{});
			dispatchEvent(stateEv);
			if(!ev.defaultPrevented)
			{
			  hash += ev.value;
			  window.history.pushState(stateEv.value,_routeState.title,hash);
			  sendStrandEvent(this,"stateSet");
			}
		  }
		}
		/**
		 * Same as setState, but also notifies of the state change
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function renderState():void
		{
		  setState();
		  dispatchEvent(new Event("stateChange"));
		}

		private var _mxmlDescriptor:Array;
		private var _mxmlDocument:Object = this;

		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, data);
		}
		

  }
}