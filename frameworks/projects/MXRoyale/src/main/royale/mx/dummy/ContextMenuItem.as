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
package mx.dummy
{
    import org.apache.royale.events.EventDispatcher;

    public class ContextMenuItem extends EventDispatcher
    {
	   public function ContextMenuItem(caption:String, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true) {
			//super(caption, separatorBefore, enabled,visible);
	   }
	   
		public var _caption:String = "";
	    public function get caption():String {
			trace("get caption in ContextMenuItem is not implemented");
			return _caption;
		}
		public function set caption(value:String):void {
			trace("set caption in ContextMenuItem is not implemented");
			_caption = value;
		}

    }
}
