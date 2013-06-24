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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.core.ISpinnerModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.html.staticControls.Button;
	import org.apache.flex.html.staticControls.beads.controllers.ButtonAutoRepeatController;
	import org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController;
	
	public class SpinnerBead implements ISpinnerBead
	{
		public function SpinnerBead()
		{
		}
		
		private var spinnerModel:ISpinnerModel;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			initSkin();
		}
		
		public function initSkin():void
		{
			_increment = new Button();
			Button(_increment).addBead(new UpArrowButtonBead());
			Button(_increment).addBead(new ButtonAutoRepeatController());
			Button(_increment).initSkin();
			_decrement = new Button();
			Button(_decrement).addBead(new DownArrowButtonBead());
			Button(_decrement).addBead(new ButtonAutoRepeatController());
			Button(_decrement).initSkin();
			
			var mouseController:SpinnerMouseController = new SpinnerMouseController();
			_strand.addBead(mouseController);
			
			Button(_increment).x = 0;
			Button(_increment).y = 0;
			Button(_decrement).x = 0;
			Button(_decrement).y = Button(_increment).height;
			
			UIBase(_strand).addChild(_decrement);
			UIBase(_strand).addChild(_increment);
			spinnerModel = _strand.getBeadByType(ISpinnerModel) as ISpinnerModel;
		}
		
		private var _decrement:DisplayObject;
		private var _increment:DisplayObject;
		
		public function get decrement():DisplayObject
		{
			return _decrement;
		}
		public function get increment():DisplayObject
		{
			return _increment;
		}
	}
}