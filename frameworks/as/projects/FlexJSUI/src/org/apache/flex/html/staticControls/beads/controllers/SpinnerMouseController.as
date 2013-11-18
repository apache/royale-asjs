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
package org.apache.flex.html.staticControls.beads.controllers
{
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.beads.ISpinnerView;
	
	public class SpinnerMouseController implements IBeadController
	{
		public function SpinnerMouseController()
		{
		}
		
		private var rangeModel:IRangeModel;
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			rangeModel = UIBase(value).model as IRangeModel;
			
			var spinnerBead:ISpinnerView = value.getBeadByType(ISpinnerView) as ISpinnerView;
			spinnerBead.decrement.addEventListener(MouseEvent.CLICK, decrementClickHandler);
			spinnerBead.decrement.addEventListener("buttonRepeat", decrementClickHandler);
			spinnerBead.increment.addEventListener(MouseEvent.CLICK, incrementClickHandler);
			spinnerBead.increment.addEventListener("buttonRepeat", incrementClickHandler);
		}
		
		private function decrementClickHandler( event:Event ) : void
		{
			rangeModel.value = Math.max(rangeModel.minimum, rangeModel.value - rangeModel.stepSize);
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChanged"));
		}
		
		private function incrementClickHandler( event:Event ) : void
		{
			rangeModel.value = Math.min(rangeModel.maximum, rangeModel.value + rangeModel.stepSize);	
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChanged"));
		}
	}
}