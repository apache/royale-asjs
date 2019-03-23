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
package org.apache.royale.jewel.beads.controls
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.IClassSelectorListSupport;
	
	/**
	 *  The MultiLine bead is a specialty bead that can be used with
	 *  any IClassSelectorListSupport control to allow more than one line
	 *  i.e: Button, DropDownList, ...
	 *  Note that Label has multiline property baked since is very used on that component
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class MultiLine implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function MultiLine()
		{
		}
		
		protected var control:IClassSelectorListSupport;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			control = value as IClassSelectorListSupport;
            updateControl();
		}

        private var _multiline:Boolean;
        /**
		 *  A boolean flag to activate "multiline" effect selector.
		 *  Allow the label to have more than one line if needed
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get multiline():Boolean
        {
            return _multiline;
        }

        public function set multiline(value:Boolean):void
        {
            if (_multiline != value)
            {
                _multiline = value;
                updateControl();
            }
        }

        protected function updateControl():void
		{
			if(control)
            {
				control.toggleClass("multiline", _multiline);
			}
        }
	}
}
