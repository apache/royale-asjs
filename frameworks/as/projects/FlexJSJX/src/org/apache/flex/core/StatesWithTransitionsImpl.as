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
    
    import mx.states.AddItems;
    import mx.states.SetEventHandler;
    import mx.states.SetProperty;
    import mx.states.State;
    
    import org.apache.flex.core.IParent;
    import org.apache.flex.core.IStatesObject;
    import org.apache.flex.effects.Effect;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.ValueChangeEvent;
    import org.apache.flex.states.Transition;
    import org.apache.flex.utils.MXMLDataInterpreter;
	
    /**
     *  The StatesWithTransitionsImpl class implements a set of
     *  view state functionality that includes transitions between states.
     *  It only supports AddItems and SetProperty and SetEventHandler 
     *  changes at this time.
     *  
     *  @flexjsignoreimport org.apache.flex.core.IStatesObject
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class StatesWithTransitionsImpl extends EventDispatcher implements IStatesImpl, IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function StatesWithTransitionsImpl()
		{
			super();
		}
        
        private var _strand:IStrand;
        
        private var sawInitComplete:Boolean;
        
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(_strand).addEventListener("currentStateChange", stateChangeHandler);
            IEventDispatcher(_strand).addEventListener("initComplete", initialStateHandler);
        }
        
        /**
         *  @private
         *  @flexjsignorecoercion org.apache.flex.core.IStatesObject
         */
        private function initialStateHandler(event:org.apache.flex.events.Event):void
        {
            sawInitComplete = true;
            stateChangeHandler(new ValueChangeEvent("currentStateChange", false, false, null, 
                IStatesObject(_strand).currentState));
        }		
     
        /**
         *  @private
         *  @flexjsignorecoercion org.apache.flex.core.IStatesObject
         */
        private function stateChangeHandler(event:ValueChangeEvent):void
        {
            if (!sawInitComplete)
                return;
            
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
                            transitionEffects = t.effects.slice();
                            for each (var e:Effect in transitionEffects)
                            {
                                e.captureStartValues();
                            }
                            break;
                        }
                    }
                }
            }
            var arr:Array = doc.states;
            for each (var s:State in arr)
            {
                if (s.name == event.oldValue)
                {
                    revert(s);
                    break;
                }
            }
            for each (s in arr)
            {
                if (s.name == event.newValue)
                {
                    apply(s);
                    break;
                }
            }
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
         *  @flexjsignorecoercion org.apache.flex.core.IStatesObject
         */
        private function effectEndHandler(event:Event):void
        {
            var n:int = transitionEffects.length;
            for (var i:int = 0; i < n; i++)   
            {
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
            
        private function revert(s:State):void
        {
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    for each (var item:IChild in ai.items)
                    {
                        var parent:IParent = item.parent as IParent;
                        parent.removeElement(item);
                    }
                    if (parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    if (sp.target != null)
                        setProperty(getProperty(sp.document, sp.target), sp.name, sp.previousValue);
                    else
                        setProperty(sp.document, sp.name, sp.previousValue);
                }
                else if (o is SetEventHandler)
                {
                    var seh:SetEventHandler = SetEventHandler(o);
                    if (seh.target != null)
                    {
                        getProperty(seh.document, seh.target).removeEventListener(seh.name, seh.handlerFunction);
                    }
                    else
                    {
                        seh.document.removeEventListener(seh.name, seh.handlerFunction);
                    }
                }
            }
        }
        
        private function apply(s:State):void
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
                    for each (var item:Object in ai.items)
                    {
                        var parent:IParent = ai.document as IParent;
                        if (ai.destination != null)
                            parent = parent[ai.destination] as IParent;
                        if (ai.relativeTo != null)
                        {
                            var child:Object = ai.document[ai.relativeTo];
                            if (ai.destination == null)
                                parent = child.parent as IParent;
                            var index:int = parent.getElementIndex(child);
                            if (ai.position == "after")
                                index++;
                            parent.addElementAt(item, index);
                        }
                        else
                        {
                            parent.addElement(item);
                        }
                    }
                    if (parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    if (sp.target != null)
                    {
                        sp.previousValue = getProperty(getProperty(sp.document, sp.target), sp.name);
                        setProperty(getProperty(sp.document, sp.target), sp.name, sp.value);
                    }
                    else
                    {
                        sp.previousValue = getProperty(sp.document, sp.name);
                        setProperty(sp.document, sp.name, sp.value);                        
                    }
                }
                else if (o is SetEventHandler)
                {
                    var seh:SetEventHandler = SetEventHandler(o);
                    if (seh.target != null)
                    {
                        getProperty(seh.document, seh.target).addEventListener(seh.name, seh.handlerFunction);
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