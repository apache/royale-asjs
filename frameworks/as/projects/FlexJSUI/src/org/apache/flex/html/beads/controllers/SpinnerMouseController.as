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
package org.apache.flex.html.beads.controllers
{
	import flash.events.MouseEvent;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IRangeModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.ISpinnerView;
	
	/**
	 *  The SpinnerMouseController class bead handles mouse events on the 
	 *  org.apache.flex.html.Spinner's component buttons, changing the 
	 *  value of the Spinner.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SpinnerMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function SpinnerMouseController()
		{
		}
		
		private var rangeModel:IRangeModel;
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
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
		
		/**
		 * @private
		 */
		private function decrementClickHandler( event:Event ) : void
		{
			rangeModel.value = Math.max(rangeModel.minimum, rangeModel.value - rangeModel.stepSize);
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
		
		/**
		 * @private
		 */
		private function incrementClickHandler( event:Event ) : void
		{
			rangeModel.value = Math.min(rangeModel.maximum, rangeModel.value + rangeModel.stepSize);	
			IEventDispatcher(_strand).dispatchEvent(new Event("valueChange"));
		}
	}
}
