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
package org.apache.royale.html.accessories
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 *  The PasswordInput class is a specialty bead that can be used with
	 *  any TextInput control. The bead secures the text input area by masking
	 *  the input as it is typed.
     *  PasswordInputRemovableBead adds the ability to remove the functionality at runtime.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class PasswordInputRemovableBead extends PasswordInputBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function PasswordInputRemovableBead()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         *  @royaleignorecoercion HTMLInputElement
		 */
        COMPILE::JS
		override public function set strand(value:IStrand):void
		{
            if(value)
                super.strand = value;
            else
            {
                var host:UIBase = _strand as UIBase;
				var e:HTMLInputElement = host.element as HTMLInputElement;
                e.type = 'text';
                _strand = value;
            }
		}		
	}
}
