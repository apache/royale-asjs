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
	import flash.display.Stage;
    import flash.events.Event;
	
    import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

    /**
     *  The StageProxy class wraps the stage and
     *  presents it as a Royale IEventDispatcher.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class StageProxy implements IEventDispatcher
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function StageProxy(stage:Stage)
		{
			super();
            _stage = stage;
            _stage.addEventListener("removedFromStage", removedFromStageHandler);
        }
		
		private var _stage:Stage;

        private function removedFromStageHandler(event:flash.events.Event):void
        {
            _stage.removeEventListener("removedFromStage", removedFromStageHandler);
            dispatchEvent(new org.apache.royale.events.Event("removedFromStage"));
        }
        
        /**
         *  @copy org.apache.royale.core.IEventDispatcher#addEventListener()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReferences:Boolean = false):void	
		{
            _stage.addEventListener(type, listener, useCapture);
		}
       
        /**
         *  @copy org.apache.royale.core.IEventDispatcher#removeEventListener()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void	
        {
            _stage.removeEventListener(type, listener, useCapture);
        }
        
        /**
         *  @copy org.apache.royale.core.IEventDispatcher#removeEventListener()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function dispatchEvent(event:flash.events.Event):Boolean	
        {
            return _stage.dispatchEvent(event);
        }
        
        /**
         *  @copy org.apache.royale.core.IEventDispatcher#willTriger()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function willTrigger(eventName:String):Boolean	
        {
            return _stage.willTrigger(eventName);
        }
        
        /**
         *  @copy org.apache.royale.core.IEventDispatcher#hasEventListener()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function hasEventListener(eventName:String):Boolean	
        {
            return _stage.hasEventListener(eventName);
        }
	}
}
