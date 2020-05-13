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
  import org.apache.royale.events.IEventDispatcher;
  COMPILE::SWF
  {
    import flash.events.Event;
  }

  /**
   * Base class for simple beads
   *  @productversion Royale 0.9.7
   */
  public class Bead implements IBead
  {
    public function Bead()
    {
      
    }

    /**
     *  The strand.  Do not modify except
     *  via the strand setter.  For reading only.
     * 
     *  Because Object.defineProperties in JS
     *  doesn't allow you to just override the setter
     *  (you have to override the getter as well even
     *  if it just calls the super getter) it is
     *  more efficient to expose this variable than
     *  have all of the layers of simple overrides.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

		}
    /**
     * Helper function to attach event listener without the need for casting
     * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
     */
    protected function listenOnStrand(eventType:String,handler:Function,capture:Boolean=false):void
    {
      (_strand as IEventDispatcher).addEventListener(eventType, handler, capture);
    }

  }
}