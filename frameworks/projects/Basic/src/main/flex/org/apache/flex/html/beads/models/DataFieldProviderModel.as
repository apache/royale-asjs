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
package org.apache.flex.html.beads.models
{
	import org.apache.flex.core.IDataFieldProviderModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
			
    /**
     *  The DataFieldProviderModel class is a model that holds dataField used mostly
	 *  in item renderers for retrieve some value from dataProvider items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.9
     */
	public class DataFieldProviderModel extends EventDispatcher implements IDataFieldProviderModel
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
		public function DataFieldProviderModel()
		{
		}

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}

		private var _dataField:String = null;
		
        /**
         *  @copy org.apache.flex.core.IDataFieldProviderModel#dataField
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
		public function get dataField():String
		{
			return _dataField;
		}

        /**
         *  @private
         */
		public function set dataField(value:String):void
		{
			if (value != _dataField)
			{
                _dataField = value;
				dispatchEvent(new Event("labelFieldChanged"));
			}
		}
	}
}
