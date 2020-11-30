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
	import org.apache.royale.html.LoadIndicator;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.geom.Point;
	import org.apache.royale.core.IUIBase;
	/**
	 *  The ShrinkableDisableLoaderBead extends DisableLoaderBead to allow shrinking of the load indicator.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class ShrinkableDisableLoaderBead extends DisableLoaderBead
	{
        private var _resizeFactor:Number = 1;
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function ShrinkableDisableLoaderBead()
		{
			super();
		}

		/**
		 *  The size of the load indicator relative to the strand.
         *  If it's 0.5 it's half the size.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function get resizeFactor():Number
		{
			return _resizeFactor;
		}

		public function set resizeFactor(value:Number):void
		{
			_resizeFactor = value;
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		override protected function addLoadIndicator():void
		{
			var point:Point = PointUtils.localToGlobal(new Point(0, 0), _strand);
			_loader = new LoadIndicator();
			_loader.width = (_strand as IUIBase).width * _resizeFactor;
			_loader.height = (_strand as IUIBase).height * _resizeFactor;
			_loader.x = point.x + (_strand as IUIBase).width / 2 - _loader.width / 2;
			_loader.y = point.y + (_strand as IUIBase).height / 2 - _loader.height / 2;
			COMPILE::JS
			{
				_loader.element.style.position = "absolute";
			}
			var popupHost:IPopUpHost = UIUtils.findPopUpHost(host);
			popupHost.popUpParent.addElement(_loader);
		}
		
	}
}
