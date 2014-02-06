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
    import flash.events.IEventDispatcher;
    
    import mx.states.AddItems;
    import mx.states.SetProperty;
    import mx.states.State;
    
    import org.apache.flex.core.IParent;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.ValueChangeEvent;
    import org.apache.flex.utils.MXMLDataInterpreter;
	
    /**
     *  The SimpleStatesImpl class implements a minimal set of
     *  view state functionality that is sufficient for most applications.
     *  It only supports AddItems and SetProperty changes at this time.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SimpleStatesImpl extends EventDispatcher implements IStatesImpl, IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SimpleStatesImpl()
		{
			super();
		}
        
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.flex.core.IBead#strand.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(_strand).addEventListener("currentStateChanged", stateChangeHandler);
        }		
     
        private function stateChangeHandler(event:ValueChangeEvent):void
        {
            var doc:Object = event.target;
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
            
        }
        
        private function revert(s:State):void
        {
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    for each (var item:DisplayObject in ai.items)
                    {
                        var parent:IParent = ai.document[ai.destination] as IParent;
                        parent.removeElement(item);
                    }
                    if (parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    sp.document[sp.target][sp.name] = sp.previousValue;
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
                        ai.items = MXMLDataInterpreter.generateMXMLArray(ai.document,
                                                    null, ai.itemsDescriptor, true);
                    }
                    for each (var item:DisplayObject in ai.items)
                    {
                        var parent:IParent = ai.document[ai.destination] as IParent;
                        if (ai.relativeTo != null)
                        {
                            var child:Object = ai.document[ai.relativeTo];
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
                    sp.previousValue = sp.document[sp.target][sp.name];
                    sp.document[sp.target][sp.name] = sp.value;
                }
            }            
        }
	}
}