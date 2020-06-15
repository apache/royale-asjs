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
package org.apache.royale.jewel.beads.layouts
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.IClassSelectorListSupport;
	
	/**
	 *  The ResponsiveVisibility bead class is a specialty bead that 
	 *  can be used to show or hide a Jewel component depending on responsive
	 *  rules.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ResponsiveVisibility implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ResponsiveVisibility()
		{
		}

		private var _phoneVisible:Boolean;
		/**
		 *  Makes the component to be visible or hidden in phone size
		 *  Uses "visible-phone" and "hidden-phone" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get phoneVisible():Boolean
        {
            return _phoneVisible;
        }

        public function set phoneVisible(value:Boolean):void
        {
			if (_phoneVisible != value)
            {
                COMPILE::JS
                {
					_phoneVisible = value;
					
					if(_strand)
                		showOrHideHost();
				}
			}
		}

		private var _tabletVisible:Boolean;
		/**
		 *  Makes the component to be visible or hidden in phone size
		 *  Uses "visible-tablet" and "hidden-tablet" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get tabletVisible():Boolean
        {
            return _tabletVisible;
        }

        public function set tabletVisible(value:Boolean):void
        {
			if (_tabletVisible != value)
            {
                COMPILE::JS
                {
					_tabletVisible = value;

					if(_strand)
                		showOrHideHost();
				}
			}
		}

		private var _desktopVisible:Boolean;
		/**
		 *  Makes the component to be visible or hidden in phone size
		 *  Uses "visible-desktop" and "hidden-desktop" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get desktopVisible():Boolean
        {
            return _desktopVisible;
        }

        public function set desktopVisible(value:Boolean):void
        {
			if (_desktopVisible != value)
            {
                COMPILE::JS
                {
					_desktopVisible = value;

					if(_strand)
                		showOrHideHost();
				}
			}
		}
		
		private var _wideScreenVisible:Boolean;
		/**
		 *  Makes the component to be visible or hidden in phone size
		 *  Uses "visible-widescreen" and "hidden-widescreen" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get wideScreenVisible():Boolean
        {
            return _wideScreenVisible;
        }

        public function set wideScreenVisible(value:Boolean):void
        {
			if (_wideScreenVisible != value)
            {
                COMPILE::JS
                {
					_wideScreenVisible = value;

					if(_strand)
                		showOrHideHost();
				}
			}
		}

		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			showOrHideHost();
		}

		protected function showOrHideHost():void
		{
			var host:IClassSelectorListSupport = _strand as IClassSelectorListSupport;
			if (host)
            {
				if(phoneVisible != null)
				{
					if(phoneVisible)
						host.replaceClass("hidden-phone", "visible-phone");
					else
						host.replaceClass("visible-phone", "hidden-phone");
				}

				if(tabletVisible != null)
				{
					if(tabletVisible)
						host.replaceClass("hidden-tablet", "visible-tablet");
					else
						host.replaceClass("visible-tablet", "hidden-tablet");

				}

				if(desktopVisible != null)
				{
					if(desktopVisible)
						host.replaceClass("hidden-desktop", "visible-desktop");
					else
						host.replaceClass("visible-desktop", "hidden-desktop");
				}

				if(wideScreenVisible != null)
				{
					if(wideScreenVisible)
						host.replaceClass("hidden-widescreen", "visible-widescreen");
					else
						host.replaceClass("visible-widescreen", "hidden-widescreen");
				}
            }
		}
	}
}
