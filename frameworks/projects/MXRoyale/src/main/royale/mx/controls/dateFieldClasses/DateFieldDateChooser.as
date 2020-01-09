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
package mx.controls.dateFieldClasses
{	
    import mx.controls.DateChooser;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.html.supportClasses.IDateChooser;
	
    /**
     *  The DateFieldDateChooser is the DateChooser dropdown
     *  for a DateField.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DateFieldDateChooser extends DateChooser implements IDateChooser
	{
        
        override public function set selectedDate(value:Date):void
        {
            if (!value)
                value = new Date();
                
            super.selectedDate = value;
        }

	}
}
