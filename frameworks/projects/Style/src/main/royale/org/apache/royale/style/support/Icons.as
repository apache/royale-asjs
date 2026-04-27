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
package org.apache.royale.style.support
{
	import org.apache.royale.style.Icon;
	

	/**
	 * The Icons class supports commonly used icons
	 *  
	 * This file includes derived work based on Adobe Spectrum Icons,
	 * licensed under the Apache License, Version 2.0.
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 1.0
	 *  
	 *  @royalesuppressexport
	 */
	public class Icons 
	{
		/**
		 *  constructor.
		 *
		 *  @private
		 */
		private function Icons()
		{
			super();
		}
		
		/**
		 * @royalesuppressexport
		 */
		public static function cross_Small():Icon{
			if (!Icon.isRegistered('support_icons_cross_small')) { 
				Icon.registerIcon('support_icons_cross_small', <svg viewBox="0 0 20 20" fill="currentColor" stroke="none"><path d="M13.317 12.433L10.884 10l2.433-2.433a.625.625 0 1 0-.884-.884L10 9.116 7.567 6.683a.625.625 0 1 0-.884.884L9.116 10 6.683 12.433a.625.625 0 1 0 .884.884L10 10.884l2.433 2.433a.625.625 0 0 0 .884-.884z" stroke-linecap="round" stroke-linejoin="round"/></svg>);
			}
			return new Icon('support_icons_cross_small');
		}
		
		/**
		 * @royalesuppressexport
		 */
		public static function info_medium():Icon{
			if (!Icon.isRegistered('support_icons_info_medium')) {
				Icon.registerIcon('support_icons_info_medium', <svg viewBox="0 0 20 20" fill="currentColor" stroke="none"><path d="M11 3a8 8 0 1 0 8 8 8 8 0 0 0-8-8zm-.15 2.15a1.359 1.359 0 0 1 1.431 1.283q.004.064.001.129A1.332 1.332 0 0 1 10.85 7.994a1.353 1.353 0 0 1-1.432-1.433 1.359 1.359 0 0 1 1.304-1.412q.064-.002.128.001zM13 15.5a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5H10V11h-.5a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5V14h.5a.5.5 0 0 1 .5.5z"	stroke-linecap="round" stroke-linejoin="round"/></svg>);
			}
			return new Icon('support_icons_info_medium');
		}
		
		/**
		 * @royalesuppressexport
		 */
		public static function alert_medium():Icon{
			if (!Icon.isRegistered('support_icons_alert_medium')) {
				Icon.registerIcon('support_icons_alert_medium', <svg viewBox="0 0 20 20" fill="currentColor" stroke="none"><path d="M10.564 3.289L2.2 18.256A.5.5 0 0 0 2.636 19h16.728a.5.5 0 0 0 .436-.744L11.436 3.289a.5.5 0 0 0-.872 0zM12 16.75a.25.25 0 0 1-.25.25h-1.5a.25.25 0 0 1-.25-.25v-1.5a.25.25 0 0 1 .25-.25h1.5a.25.25 0 0 1 .25.25zm0-3a.25.25 0 0 1-.25.25h-1.5a.25.25 0 0 1-.25-.25v-6a.25.25 0 0 1 .25-.25h1.5a.25.25 0 0 1 .25.25z" stroke-linecap="round" stroke-linejoin="round"/></svg>);
			}
			return new Icon('support_icons_alert_medium');
		}
		
		/**
		 * @royalesuppressexport
		 */
		public static function success_medium():Icon{
			if (!Icon.isRegistered('support_icons_success_medium')) {
				Icon.registerIcon('support_icons_success_medium', <svg viewBox="0 0 20 20" fill="currentColor" stroke="none"><path d="M11 3A8 8 0 1 0 19 11A8 8 0 0 0 11 3M16.333 7.54L10.009 15.67A.6.6 0 0 1 9.572 15.9H9.535A.6.6 0 0 1 9.11 15.724L5.217 11.824A.6.6 0 0 1 5.217 10.975L5.88 10.312A.6.6 0 0 1 6.728 10.312L9.4 12.991L14.656 6.237A.6.6 0 0 1 15.499 6.137L16.227 6.703A.6.6 0 0 1 16.333 7.54Z" stroke-linecap="round" stroke-linejoin="round"/></svg>);
			}
			return new Icon('support_icons_success_medium');
		}
		
		
	}
}
