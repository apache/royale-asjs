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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.LoadIndicator;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.core.Bead;

	COMPILE::JS
	{
	import org.apache.royale.core.WrappedHTMLElement;
	}
	/**
	 *  The DisableLoaderBead class is a specialty bead that can be used with
	 *  any UIBase control which has a DisableBead attached.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class DisableLoaderBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function DisableLoaderBead()
		{
		}
		
		protected var _loader:IUIBase;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function set strand(value:IStrand):void
		{	
			COMPILE::JS
			{
				_strand = value;
				listenOnStrand("disabledChange", disabledChangeHandler);
				updateHost(null);
			}
		}

		private function disabledChangeHandler(e:ValueEvent):void
		{
			updateHost(e.value);
		}
		
        /**
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		protected function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		private function updateHost(value:Object):void
		{
			COMPILE::JS
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
				if (disabled)
				{
					addLoadIndicator();
				} else if (_loader)
				{
					removeLoadIndicator();
				}
			}
		}
		
		protected function addLoadIndicator():void
		{
			var point:Point = PointUtils.localToGlobal(new Point(0, 0), host);
			_loader = new LoadIndicator();
			_loader.x = point.x;
			_loader.y = point.y;
			_loader.width = host.width;
			_loader.height = host.height;
			COMPILE::JS
			{
				_loader.element.style.position = "absolute";
			}
			var popupHost:IPopUpHost = UIUtils.findPopUpHost(_strand as IUIBase);
			popupHost.popUpParent.addElement(_loader);
		}
		
		protected function removeLoadIndicator():void
		{
			_loader.parent.removeElement(_loader);
		}
	}
}
