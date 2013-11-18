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

package org.apache.flex.binding
{
    
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
         *  @productversion Flex 3
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
         *  @private
         *  The binding objects that are listening to this Watcher.
         *  The standard event mechanism isn't used because it's too heavyweight.
         */
        protected var listeners:Array;
        
        /**
         *  @private
         *  Children of this watcher are watching sub values.
         */
        protected var children:Array;
        
        /**
         *  @private
         *  The value itself.
         */
        public var value:Object;
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  @private
         *  This is an abstract method that subclasses implement.
         */
        public function parentChanged(parent:Object):void
        {
        }
        
        /**
         *  @private
         *  Add a child to this watcher, meaning that the child
         *  is watching a sub value of ours.
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
         *  @private
         *  Add a binding to this watcher, meaning that the binding
         *  is notified when our value changes.
         */
        public function addBinding(binding:GenericBinding):void
        {
            if (!listeners)
                listeners = [ binding ];
            else
                listeners.push(binding);
            
            binding.valueChanged(value);
        }
                
        /**
         *  We have probably changed, so go through
         *  and make sure our children are updated.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
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
         *  @private
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
                
                if (allowedErrors.indexOf(error.errorID) == -1)
                    throw error;
            }
        }
        
        // Certain errors are normal when executing an update, so we swallow them:
        public static var allowedErrors:Array = [
            1006, //   Error #1006: Call attempted on an object that is not a function.
            1009, //   Error #1009: null has no properties.
            1010, //   Error #1010: undefined has no properties.
            1055, //   Error #1055: - has no properties.
            1069, //   Error #1069: Property - not found on - and there is no default value
            1507 //   Error #1507: - invalid null argument.
            ];
        
        public static var allowedErrorTypes:Array = [
            { type: RangeError /*, handler: function(w:WatcherBase, wrappedFunction:Function):Object { return null }*/ }
            ];
        
        /**
         *  @private
         */
        public function notifyListeners():void
        {
            if (listeners)
            {
                var n:int = listeners.length;
                
                for (var i:int = 0; i < n; i++)
                {
                    listeners[i].valueChanged(value);
                }
            }
        }
    }
    
}
