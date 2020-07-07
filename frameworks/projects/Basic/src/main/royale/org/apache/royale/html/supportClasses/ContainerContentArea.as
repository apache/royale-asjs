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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.ILayoutView;

    /**
     *  The ContainerContentArea class implements the contentView for
     *  a Container on the SWF platform.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ContainerContentArea extends UIBase implements IBead, ILayoutView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ContainerContentArea()
		{
			super();
            addEventListener("layoutNeeded", forwardEventHandler);
		}
		
        private var _host:IUIBase;
		public function get host():IUIBase
        {
            return _host;
        }
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		public function set strand(value:IStrand):void
		{
			_host = value as IUIBase;
		}
        /**
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        private function forwardEventHandler(event:Event):void
        {
            if (parent is IEventDispatcher)
                (parent as IEventDispatcher).dispatchEvent(event);
        }
	}
}
