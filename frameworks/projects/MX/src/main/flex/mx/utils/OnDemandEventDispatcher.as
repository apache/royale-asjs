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
package mx.utils
{
COMPILE::AS3
{
	import flash.events.Event;	
}
COMPILE::JS
{
	import org.apache.flex.events.Event;	
}
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.EventDispatcher;

    /**
     * OnDemandEventDispatcher serves as a base class for classes that dispatch events but expect listeners
     * to be infrequent.  When a class extends OnDemandEventDispatcher instead of the standard EventDispatcher,
     * it is trading off a small overhead on every single instance for a slightly larger overhead on only the instances
     * that actually have listeners attached to them.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class OnDemandEventDispatcher implements IEventDispatcher
    {
        private var _dispatcher:EventDispatcher;
    

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
        /**
         * Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function OnDemandEventDispatcher()
        {
        }

        /**
         *  @inheritDoc
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		COMPILE::AS3
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            if (_dispatcher == null)
            {
                _dispatcher = new EventDispatcher(this);
            }
            _dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference); 
        }
		COMPILE::JS
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, handlerScope:Object = null):void
		{
			if (_dispatcher == null)
			{
				_dispatcher = new EventDispatcher(this);
			}
			_dispatcher.addEventListener(type,listener,useCapture); 
		}
        
            
        /**
         *  @inheritDoc
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		COMPILE::AS3
        public function dispatchEvent(event:Event):Boolean
        {
            if (_dispatcher != null)
                return _dispatcher.dispatchEvent(event);
            return true; 
        }
		COMPILE::JS
		public function dispatchEvent(event:Object):Boolean
		{
			if (_dispatcher != null)
				return _dispatcher.dispatchEvent(event);
			return true; 
		}
    
        /**
         *  @inheritDoc
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function hasEventListener(type:String):Boolean
        {
            if (_dispatcher != null)
                return _dispatcher.hasEventListener(type);
            return false; 
        }
            
        /**
         *  @inheritDoc
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		COMPILE::AS3
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            if (_dispatcher != null)
                _dispatcher.removeEventListener(type,listener,useCapture);         
        }
		COMPILE::JS
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false, handlerScope:Object = null):void
		{
			if (_dispatcher != null)
				_dispatcher.removeEventListener(type,listener,useCapture);         
		}
    
        /**
         *  @inheritDoc
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
		COMPILE::AS3
        public function willTrigger(type:String):Boolean
        {
            if (_dispatcher != null)
                return _dispatcher.willTrigger(type);
            return false; 
        }

    }
}