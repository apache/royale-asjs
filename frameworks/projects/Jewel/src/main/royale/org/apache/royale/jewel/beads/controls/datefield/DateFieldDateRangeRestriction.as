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
package org.apache.royale.jewel.beads.controls.datefield
{
    import org.apache.royale.core.DispatcherBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.jewel.DateChooser;
    import org.apache.royale.jewel.beads.controls.datechooser.DateChooserDateRangeRestriction;
    import org.apache.royale.jewel.beads.views.DateFieldView;
													
	/**
	 *  Disable dates which are outside restriction provided by minDate and maxDate properties
	 *  in DateField component
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class DateFieldDateRangeRestriction extends DispatcherBead
	{
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function DateFieldDateRangeRestriction()
		{
		}
		
		private var _minDate:Date;
        /**
         *  The minimun date
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		[Bindable]
		public function get minDate():Date
		{
			return _minDate;
		}
		public function set minDate(value:Date):void
		{
			if (_minDate != value)
			{
				_minDate = value;
				setUpDateRangeRestriction();
			}
		}
		
		private var _maxDate:Date;
        /**
         *  The maximun date
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		[Bindable]
		public function get maxDate():Date
		{
			return _maxDate;
		}
		public function set maxDate(value:Date):void
		{
			if (_maxDate != value)
			{
				_maxDate = value;
				setUpDateRangeRestriction();
			}
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public override function set strand(value:IStrand):void
		{
			super.strand = value;
			(_strand as IEventDispatcher).addEventListener("initComplete", handleDateFieldInitComplete);
		}

		private var view:DateFieldView;
		private var dataRangeRestriction:DateChooserDateRangeRestriction;
		
		private function handleDateFieldInitComplete(event:Event):void
		{
			(_strand as IEventDispatcher).removeEventListener("initComplete", handleDateFieldInitComplete);
            (_strand as IEventDispatcher).addEventListener('popUpOpened', popUpOpenedHandler, false);
			
			view = _strand.getBeadByType(DateFieldView) as DateFieldView;
		}

		private function setUpDateRangeRestriction():void 
		{
			if(!dataRangeRestriction)
				dataRangeRestriction = new DateChooserDateRangeRestriction();

			dataRangeRestriction.minDate = minDate;
			dataRangeRestriction.maxDate = maxDate;
		}
		
		protected function popUpOpenedHandler():void
		{
            if (!minDate || !maxDate) return;
			
            setUpDateRangeRestriction();

			var dateChooser:DateChooser = view.popUp as DateChooser;
			dateChooser.addBead(dataRangeRestriction);

			dataRangeRestriction.setUpBead();
		}
    }
}