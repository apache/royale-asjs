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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewportModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.core.layout.EdgeData;
	
    /**
     * @copy org.apache.royale.core.IViewportModel
     */
	public class ViewportModel extends EventDispatcher implements IViewportModel
	{
		public function ViewportModel()
		{
			super();
		}
		
        private var _borderMetrics:EdgeData;
		private var _chromeMetrics:EdgeData;
		
		private var _strand:IStrand;
		
        /**
         * @copy org.apache.royale.core.IViewportModel
         */
        public function get borderMetrics():EdgeData
        {
            return _borderMetrics;
        }
        public function set borderMetrics(value:EdgeData):void
        {
            _borderMetrics = value;
        }
        
        /**
         * @copy org.apache.royale.core.IViewportModel
         */
        public function get chromeMetrics():EdgeData
        {
            return _chromeMetrics;
        }
        public function set chromeMetrics(value:EdgeData):void
        {
            _chromeMetrics = value;
        }
        
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}
