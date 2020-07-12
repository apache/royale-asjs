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

package org.apache.royale.binding
{
    /**
     *  The WatcherBase class is the base class for data-binding classes that watch
     *  various properties and styles for changes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
    public class WatcherBase
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Royale 1.0.0
         */
        public function WatcherBase()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         *  The binding objects that are listening to this Watcher.
         *  The standard event mechanism isn't used because it's too heavyweight.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var listeners:Array;
        
        /**
         *  Children of this watcher are watching sub values.  For example, if watching 
         *  {a.b.c} and this watcher is watching "b", then it is the watchers watching
         *  "c" and "d" if there is an {a.b.d} being watched.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var children:Array;
        
        /**
         *  The value of whatever it is we are watching.  For example, if watching 
         *  {a.b.c} and this watcher is watching "b", then it is the value of "a.b".
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var value:Object;
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  This is an abstract method that subclasses implement.  Implementations
         *  handle changes in the parent chain.  For example, if watching 
         *  {a.b.c} and this watcher is watching "b", then handle "a" changing.
         *
         *  @param parent The new parent.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function parentChanged(parent:Object):void
        {
        }
        
        /**
         *  Add a child to this watcher, meaning that the child
         *  is watching a sub value of ours.  For example, if watching 
         *  {a.b.c} and this watcher is watching "b", then this method
         *  is called to add the watcher watching "c".
         *
         *  @param child The new child
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function addChild(child:WatcherBase):void
        {
            if (!children)
                children = [ child ];
            else
                children.push(child);
            
            child.parentChanged(this);
        }
        
        /**
         *  Add a binding to this watcher, meaning that the binding
         *  is notified when our value changes.  Bindings are classes
         *  that actually perform the change based on changes
         *  detected to this portion of the chain.
         *
         *  @param binding The new binding.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function addBinding(binding:GenericBinding):void
        {
            if (!listeners)
                listeners = [ binding ];
            else
                listeners.push(binding);
            
            binding.valueChanged(value, typeof binding.source === "function");
        }
                
        /**
         *  This method is called when the value
         *  might have changed and goes through
         *  and makes sure the children are updated.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function updateChildren():void
        {
            if (children)
            {
                var n:int = children.length;
                for (var i:int = 0; i < n; ++i)
                {
                    children[i].parentChanged(this);
                }
            }
        }
        
        /**
         *  @private
         */
        private function valueChanged(oldval:Object):Boolean
        {
            if (oldval == null && value == null)
                return false;
            
            var valType:String = typeof(value);
            
            // The first check is meant to catch the delayed instantiation case
            // where a control comes into existence but its value is still
            // the equivalent of not having been filled in.
            // Otherwise we simply return whether the value has changed.
            
            if (valType == "string")
            {
                if (oldval == null && value == "")
                    return false;
                else
                    return oldval != value;
            }
            
            if (valType == "number")
            {
                if (oldval == null && value == 0)
                    return false;
                else
                    return oldval != value;
            }
            
            if (valType == "boolean")
            {
                if (oldval == null && value == false)
                    return false;
                else
                    return oldval != value;
            }
            
            return true;
        }
        
        /**
         *  Calls a function inside a try catch block to try to
         *  update the value.
         *
         *  @param wrappedFunction The function to call.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected function wrapUpdate(wrappedFunction:Function):void
        {
            try
            {
                wrappedFunction.apply(this);
            }
            catch(error:Error)
            {
                var n:int = allowedErrorTypes.length;
                for (var i:int = 0; i < n; i++)
                {
                    if (error is allowedErrorTypes[i].type)
                    {
                        var handler:Function = allowedErrorTypes[i].handler;
                        if (handler != null)
                            value = handler(this, wrappedFunction);
                        else
                            value = null;
                    }
                }
                
                COMPILE::SWF
                {
                    if (allowedErrors.indexOf(error.errorID) == -1)
                        throw error;                        
                }
                COMPILE::JS
                {
                    var s:String = error.message;
                    n = allowedErrors.length;
                    for (i = 0; i < n; i++)
                    {
                        if (s.indexOf(allowedErrors[i]) != -1)
                            return;
                    }
                    throw error;
                }
            }
        }
        
        /**
         *  Certain errors are normal when executing an update, so we swallow them.
         *  Feel free to add more errors if needed.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
        public static var allowedErrors:Array = [
            1006, //   Error #1006: Call attempted on an object that is not a function.
            1009, //   Error #1009: null has no properties.
            1010, //   Error #1010: undefined has no properties.
            1055, //   Error #1055: - has no properties.
            1069, //   Error #1069: Property - not found on - and there is no default value
            1507 //   Error #1507: - invalid null argument.
            ];        
        COMPILE::JS
        public static var allowedErrors:Array = [
            "Call attempted on an object that is not a function.",
            "null has no properties.",
            "undefined has no properties.",
            "undefined is not an object",
            "has no properties.",
            "and there is no default value",
            "invalid null argument."
        ];
        
        /**
         *  Certain errors classes are normal when executing an update, so we swallow all
         *  errors they represent.  Feel free to add more errors if needed.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static var allowedErrorTypes:Array = [
            { type: RangeError /*, handler: function(w:WatcherBase, wrappedFunction:Function):Object { return null }*/ }
            ];
        
        /**
         *  Notify the various bindings that the value has changed so they can update
         *  their data binding expressions.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.binding.GenericBinding
         */
        public function notifyListeners():void
        {
            if (listeners)
            {
                var n:int = listeners.length;
                
                for (var i:int = 0; i < n; i++)
                {
                    var gb:GenericBinding = listeners[i] as GenericBinding;
                    gb.valueChanged(value, typeof gb.source === "function");
                }
            }
        }
    }
    
}
