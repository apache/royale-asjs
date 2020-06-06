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
package org.apache.royale.html.beads.layouts
{	
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 *  The LayoutChangeNotifier notifies layouts when a property
     *  it is watching changes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class LayoutChangeNotifier extends Bead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function LayoutChangeNotifier()
		{
		}
		
			
        private var _value:* = undefined;
        
        /**
         *  The value of the property being watched.  This is usually
         *  a data binding expression.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        public function set initialValue(value:Object):void
        {
            _value = value;
        }
        
		/**
		 *  The value of the property being watched.  This is usually
         *  a data binding expression.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IBeadView
		 */
		public function set watchedProperty(value:Object):void
		{
			if (_value !== value)
            {
                _value = value;
                if (_strand is IBeadView)
                    IBeadView(_strand).host.dispatchEvent(new Event("layoutNeeded"));
                else {
					if (_strand)
                    	sendStrandEvent(_strand, "layoutNeeded");
				}
            }
		}
		
	}
}
