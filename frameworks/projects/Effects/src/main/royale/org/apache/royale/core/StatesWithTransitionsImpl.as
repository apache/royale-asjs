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
package org.apache.royale.core
{
        
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStatesObject;
    import org.apache.royale.effects.Effect;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.ValueChangeEvent;
    import org.apache.royale.states.AddItems;
    import org.apache.royale.states.SetEventHandler;
    import org.apache.royale.states.SetProperty;
    import org.apache.royale.states.State;
    import org.apache.royale.states.Transition;
    import org.apache.royale.utils.MXMLDataInterpreter;
	
    /**
     *  The StatesWithTransitionsImpl class implements a set of
     *  view state functionality that includes transitions between states.
     *  It only supports AddItems and SetProperty and SetEventHandler 
     *  changes at this time.
     *  
     *  @royaleignoreimport org.apache.royale.core.IStatesObject
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class StatesWithTransitionsImpl extends EventDispatcher implements IStatesImpl, IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function StatesWithTransitionsImpl()
		{
			super();
		}
        
        private var _strand:IStrand;
        
        private var sawInitComplete:Boolean;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(_strand).addEventListener("currentStateChange", stateChangeHandler);
            IEventDispatcher(_strand).addEventListener("initComplete", initialStateHandler);
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IStatesObject
         */
        private function initialStateHandler(event:org.apache.royale.events.Event):void
        {
            sawInitComplete = true;
            stateChangeHandler(new ValueChangeEvent("currentStateChange", false, false, null, 
                IStatesObject(_strand).currentState));
        }		
     
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IStatesObject
         */
        private function stateChangeHandler(event:ValueChangeEvent):void
        {
            if (!sawInitComplete)
                return;
            
            transitionEffects = [];
            
            var doc:IStatesObject = _strand as IStatesObject;
            var transitions:Array = doc.transitions;
            if (transitions && transitions.length > 0)
            {
                for each (var t:Transition in transitions)
                {
                    if (t.fromState == "*" || t.fromState == event.oldValue)
                    {
                        if (t.toState == "*" || t.toState == event.newValue)
                        {
                            var theseEffects:Array = t.effects.slice();
                            for each (var e:Effect in theseEffects)
                            {
                                e.captureStartValues();
                            }
                            transitionEffects = transitionEffects.concat.apply(transitionEffects, theseEffects);
                        }
                    }
                }
            }
            var arr:Array = doc.states;
            var oldState:State;
            var newState:State;
            for each (var s:State in arr)
            {
                if (s.name == event.oldValue)
                {
                    oldState = s;
                    break;
                }
            }
            for each (s in arr)
            {
                if (s.name == event.newValue)
                {
                    newState = s;
                    break;
                }
            }
            if (oldState)
                revert(oldState, newState);
            if (newState)
                apply(oldState, newState);
            if (transitionEffects && transitionEffects.length > 0)
            {
                for each (e in transitionEffects)
                {
                    e.captureEndValues();
                }
            }
            var playingTransition:Boolean;
            if (transitionEffects && transitionEffects.length > 0)
            {
                playingTransition = true;
                for each (e in transitionEffects)
                {
                    e.addEventListener(Effect.EFFECT_END, effectEndHandler);
                    e.play();
                }
            }
            if (!playingTransition)
                doc.dispatchEvent(new Event("stateChangeComplete"));
        }
        
        private var transitionEffects:Array;
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IStatesObject
         */
        private function effectEndHandler(event:Event):void
        {
            // in case of extraneous calls to effectEndHandler
            if (transitionEffects == null)
                return;
            
            var n:int = transitionEffects.length;
            for (var i:int = 0; i < n; i++)   
            {
                event.target.removeEventListener(Effect.EFFECT_END, effectEndHandler);
                if (transitionEffects[i] == event.target)
                    transitionEffects.splice(i, 1);
            }
            if (transitionEffects.length == 0)
            {
                transitionEffects = null;
                var doc:IStatesObject = _strand as IStatesObject;
                doc.dispatchEvent(new Event("stateChangeComplete"));
            }
        }
        
        /**
         * @royaleignorecoercion Array
         * @royaleignorecoercion org.apache.royale.states.AddItems
         */
        private function isItemInState(child:IChild, s:State):Boolean
        {
            if (s == null) return false;
            
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    if (ai.items == null)
                    {
                        ai.items = ai.itemsDescriptor.items as Array;
                        if (ai.items == null)
                        {
                            ai.items = 
                                MXMLDataInterpreter.generateMXMLArray(ai.document,
                                    null, ai.itemsDescriptor.descriptor);
                            ai.itemsDescriptor.items = ai.items;
                        }
                    }
                    for each (var item:IChild in ai.items)
                    {
                        if (item == child)
                            return true;
                    }
                }
            }
            return false;
        }
        
        /**
         * @royaleignorecoercion Array
         * @royaleignorecoercion org.apache.royale.states.AddItems
         * @royaleignorecoercion org.apache.royale.core.IParent
         * @royaleignorecoercion org.apache.royale.core.IContainer
         * @royaleignorecoercion org.apache.royale.states.SetProperty
         * @royaleignorecoercion org.apache.royale.states.SetEventHandler
         */
        private function revert(s:State, newState:State):void
        {
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    var childrenAdded:Boolean = false;
                    for each (var item:IChild in ai.items)
                    {
                        if (!isItemInState(item, newState))
                        {
                            var parent:IParent = item.parent as IParent;
                            parent.removeElement(item);
                            childrenAdded = true;
                        }
                    }
                    if (childrenAdded && parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    if (sp.target != null)
                        sp.document[sp.target][sp.name] = sp.previousValue;
                    else
                        sp.document[sp.name] = sp.previousValue;
                }
                else if (o is SetEventHandler)
                {
                    var seh:SetEventHandler = SetEventHandler(o);
                    if (seh.target != null)
                    {
                        seh.document[seh.target].removeEventListener(seh.name, seh.handlerFunction);
                    }
                    else
                    {
                        seh.document.removeEventListener(seh.name, seh.handlerFunction);
                    }
                }
            }
        }
        
        /**
         * @royaleignorecoercion Array
         * @royaleignorecoercion org.apache.royale.states.AddItems
         * @royaleignorecoercion org.apache.royale.core.IChild
         * @royaleignorecoercion org.apache.royale.core.IParent
         * @royaleignorecoercion org.apache.royale.core.IContainer
         * @royaleignorecoercion org.apache.royale.states.SetProperty
         * @royaleignorecoercion org.apache.royale.states.SetEventHandler
         */
        private function apply(oldState:State, s:State):void
        {
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    if (ai.items == null)
                    {
                        ai.items = ai.itemsDescriptor.items as Array;
                        if (ai.items == null)
                        {
                            ai.items = 
                                MXMLDataInterpreter.generateMXMLArray(ai.document,
                                    null, ai.itemsDescriptor.descriptor);
                            ai.itemsDescriptor.items = ai.items;
                        }
                    }
                    var childrenAdded:Boolean = false;
                    for each (var item:IChild in ai.items)
                    {
						// if item.parent == null then the item wasn't parented in the 
						// old state possibly because its parent was excluded in the old statte
						// see GH issue #737
                        if (!isItemInState(item, oldState) || item.parent == null)
                        {
                            var parent:IParent = ai.document as IParent;
                            if (ai.destination != null)
							{
                                parent = parent[ai.destination] as IParent;
								// SimpleStatesImpl assumes the parent exists (no complex nested states)
								// but we will check here
								if (parent == null) continue;
								// if no parent, might might be excluded in current state.
								// we might later find that the parent hasn't been added yet, not sure.
							}
                            if (ai.relativeTo != null)
                            {
                                var child:IChild = ai.document[ai.relativeTo] as IChild;
                                if (ai.destination == null)
                                    parent = child.parent as IParent;
								if(parent != null) 
								{
	                                var index:int = parent.getElementIndex(child);
	                                if (ai.position == "after")
	                                    index++;
	                                parent.addElementAt(item, index);
	                                childrenAdded = true;
								}
                            }
							else if (ai.position == "first")
							{
								parent.addElementAt(item, 0);
							}
                            else
                            {
                                parent.addElement(item);
                                childrenAdded = true;
                            }
                        }
                    }
                    if (childrenAdded && parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    if (sp.target != null)
                    {
                        sp.previousValue = sp.document[sp.target][sp.name];
                        sp.document[sp.target][sp.name] = sp.value;
                    }
                    else
                    {
                        sp.previousValue = sp.document[sp.name];
                        sp.document[sp.name] = sp.value;                        
                    }
                }
                else if (o is SetEventHandler)
                {
                    var seh:SetEventHandler = SetEventHandler(o);
                    if (seh.target != null)
                    {
                        seh.document[seh.target].addEventListener(seh.name, seh.handlerFunction);
                    }
                    else
                    {
                        seh.document.addEventListener(seh.name, seh.handlerFunction);
                    }
                }
            }            
        }
	}
}
