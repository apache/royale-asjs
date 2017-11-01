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
	import org.apache.flex.html.beads.models.DateChooserModel;

	/**
	 *  The CalendarNavigation class adjusts a calendar by a month, week and/or day.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.9
	 */
	public class CalendarNavigation
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.9
		 */
		public function CalendarNavigation()
		{
		}

        /**
         *  Move the display model back one month.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function previousMonth(model:DateChooserModel):void
          {
            var month:Number = model.displayedMonth - 1;
            var year:Number  = model.displayedYear;
            if (month < 0) {
                month = 11;
                year--;
            }
            model.displayedMonth = month;
            model.displayedYear = year;
        }

        /**
         *  Move the display model forward one month.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function nextMonth(model:DateChooserModel):void
        {
            var month:Number = model.displayedMonth + 1;
            var year:Number  = model.displayedYear;
            if (month >= 12) {
                month = 0;
                year++;
            }
            model.displayedMonth = month;
            model.displayedYear = year;
        }

        /**
         *  Move the date one week into the past, the month and year
         *  displayed may change.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function previousWeek(model:DateChooserModel):Date
        {
            return pastDate(model, 7);
        }

        /**
         *  Move the date one week into the future, the month and year
         *  displayed may change.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function nextWeek(model:DateChooserModel):Date
        {
            return futureDate(model, 7);
        }

        /**
         *  Move the date one day into the past, teh month and year
         *  displayed may change.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
		public function previousDay(model:DateChooserModel):Date
        {
            return pastDate(model, 1);
		}

        /**
         *  Move the date one day into the future, the month and year
         *  displayed may change.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function nextDay(model:DateChooserModel):Date
		{
            return futureDate(model, 1);
		}

        /**
         * @private
         */
        private function futureDate(model:DateChooserModel, noDays:int):Date
        {
            var selected:Date = new Date(model.selectedDate.getTime());
            var month:Number = selected.getMonth();

            selected.setDate(selected.getDate() + noDays);
            if (month > selected.getMonth()) {
              nextMonth(model);
            }
            return selected;
        }

        /**
         * @private
         */
        private function pastDate(model:DateChooserModel, noDays:int):Date
        {
            var selected:Date = new Date(model.selectedDate.getTime());
            var month:Number = selected.getMonth();

            selected.setDate(selected.getDate() - noDays);
            if (month < selected.getMonth()) {
              previousMonth(model);
            }
            return selected;
        }
	}
}
