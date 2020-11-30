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
package org.apache.royale.html.beads
{
	COMPILE::SWF
	{
		import flash.display.InteractiveObject;
	}

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIHTMLElementWrapper;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.html.beads.DisableBead;
	import org.apache.royale.core.Bead;

	/**
	 *  The DisabledAlphaBead class is a specialty bead that can be used with
	 *  any UIBase control which has a DisableBead attached.
	 *  The bead takes properties for enabledAplha and disabledAlpha.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DisabledAlphaBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DisabledAlphaBead()
		{
		}
		

		private var _enabledAlpha:Number = 1.0;
		/**
		 *  The alpha of the element when enabled. Defaults to 1.0;
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
			*/
		public function get enabledAlpha():Number
		{
			return _enabledAlpha;
		}
		public function set enabledAlpha(value:Number):void
		{
			_enabledAlpha = value;
		}

		private var _disabledAlpha:Number = 0.5;
		
		/**
		 *  The alpha of the element when disabled. Defaults to 0.5;
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
			*/
		public function get disabledAlpha():Number
		{
			return _disabledAlpha;
		}
		public function set disabledAlpha(value:Number):void
		{
			_disabledAlpha = value;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			listenOnStrand("disabledChange", disabledChangeHandler);
			updateHost(null);
		}
		

		private function disabledChangeHandler(e:ValueEvent):void
		{
			updateHost(e.value);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		/**
		 * 	@royaleignorecoercion org.apache.royale.html.beads.DisableBead
		 */
		private function updateHost(value:Object):void
		{
			if(!_strand)//bail out
				return;
				
				var disabled:Boolean;
				if(value == null)
				{
					var disableBead:DisableBead = _strand.getBeadByType(DisableBead) as DisableBead;
					if(!disableBead)// The DisableBead was not added yet. We'll set this when the event is dispatched.
						return;
					disabled = disableBead.disabled;
				} else {
					disabled = value;
				}
				host.alpha = disabled ? disabledAlpha : enabledAlpha;
		}
		
	}
}
