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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.jewel.WizardPage;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.Event;

	/**
	 *  The WizardModel bead class holds the values for a org.apache.royale.html.Panel, such as its
	 *  title.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */

	public class WizardStep extends EventDispatcher
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function WizardStep(name:String, previousStep:String, nextStep:String)
		{
			super();
			
			this.name = name;
			this.previousStep = previousStep;
			this.nextStep = nextStep;
		}

        private var _name:String;
		/**
		 *  the name of the step
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('nameChange')]
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			if(value != _name) {
				_name = value;
				dispatchEvent(new Event('nameChange'));
			}
		}
  
		private var _previousStep:String = null;
		/**
		 *  the previous step to go
		 *
		 *  defaults to null if there's no previous step
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('previousStepChange')]
		public function get previousStep():String
		{
			return _previousStep;
		}
		public function set previousStep(value:String):void
		{
			if(value != _previousStep) {
				_previousStep = value;
				dispatchEvent(new Event('previousStepChange'));
			}
		}
  
		private var _nextStep:String = null;
		/**
		 *  the next step to go
		 *
		 *  defaults to null if there's no next step
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('nextStepChange')]
		public function get nextStep():String
		{
			return _nextStep;
		}
		public function set nextStep(value:String):void
		{
			if(value != _nextStep) {
				_nextStep = value;
				dispatchEvent(new Event('nextStepChange'));
			}
		}
		
		private var _page:WizardPage;
		/**
		 *  the page associated with this data
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('pageChange')]
		public function get page():WizardPage
		{
			return _page;
		}
		public function set page(value:WizardPage):void
		{
			if(value != _page) {
				_page = value;
				dispatchEvent(new Event('pageChange'));
			}
		}
		
		private var _stepLabel:String;
		/**
		 *  the label for this step
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('stepLabelChange')]
		public function get stepLabel():String
		{
			return _stepLabel;
		}
		public function set stepLabel(value:String):void
		{
			if(value != _stepLabel) {
				_stepLabel = value;
				dispatchEvent(new Event('stepLabelChange'));
			}
		}
		
		private var _initialPage:Boolean;
		/**
		 *  the initial page to show in the wizard
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('initialPageChange')]
		public function get initialPage():Boolean
		{
			return _initialPage;
		}
		public function set initialPage(value:Boolean):void
		{
			if(value != _initialPage) {
				_initialPage = value;
				dispatchEvent(new Event('initialPageChange'));
			}
		}

		private var _autoSkip:Boolean = false;
		/**
		 *  true to skip automatically next step
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		[Bindable('autoSkipChange')]
		public function get autoSkip():Boolean
		{
			return _autoSkip;
		}
		
		public function set autoSkip(value:Boolean):void
		{
			if(value != _autoSkip)
			{
				_autoSkip=value;
				dispatchEvent(new Event('autoSkipChange'));
			}
		}
    }
}
