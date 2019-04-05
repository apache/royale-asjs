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
    import org.apache.royale.core.IDateControlConfigBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.jewel.beads.models.DateChooserModel;
    import org.apache.royale.jewel.DateField;

    /**
	 *  The SpanishDateFieldConfig class is a specialty bead that is used
     *  by DateField or DateChooser control to configure to Spanish.
	 *  You can use in combination with DateFormatDDMMYYYY Formatter
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SpanishDateComponentConfig implements IDateControlConfigBead
	{
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SpanishDateComponentConfig()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var model:DateChooserModel = _strand.getBeadByType(DateChooserModel) as DateChooserModel;
            model.dayNames = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];
            model.monthNames = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
            model.firstDayOfWeek = 1;

			(_strand as DateField).dateFormat = "DD/MM/YYYY";
		}
    }
}