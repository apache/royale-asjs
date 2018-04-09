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
package org.apache.royale.jewel.beads
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	
	/**
	 *  The Disabled bead class is a specialty bead that can be used to disable a Jewel control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.2
	 */
	public class Disabled implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
		public function Disabled()
		{
		}

		private var _disabled:Boolean = true;
        /**
		 *  A boolean flag to enable or disable the host control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
        public function get disabled():Boolean
        {
            return _disabled;
        }
        public function set disabled(value:Boolean):void
        {
            _disabled = value;

			COMPILE::JS
            {
                updateHost();
            }
        }

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var host:UIBase = value as UIBase;

			COMPILE::JS
			{
				updateHost();
			}
		}

		COMPILE::JS
		private function updateHost():void
		{
			var host:UIBase = _strand as UIBase;

			if (host)
            {
                _disabled ?
				host.element.setAttribute('disabled', '') :
				host.element.removeAttribute('disabled');
            }
		}
	}
}
