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
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.geom.Rectangle;
	
    /**
     * @copy org.apache.flex.core.IViewportModel
     */
	public class ViewportModel extends EventDispatcher implements IViewportModel
	{
		public function ViewportModel()
		{
			super();
		}
		
        private var _borderMetrics:Rectangle;
		private var _chromeMetrics:Rectangle;
		
		private var _strand:IStrand;
		
        /**
         * @copy org.apache.flex.core.IViewportModel
         */
        public function get borderMetrics():Rectangle
        {
            return _borderMetrics;
        }
        public function set borderMetrics(value:Rectangle):void
        {
            _borderMetrics = value;
        }
        
        /**
         * @copy org.apache.flex.core.IViewportModel
         */
        public function get chromeMetrics():Rectangle
        {
            return _chromeMetrics;
        }
        public function set chromeMetrics(value:Rectangle):void
        {
            _chromeMetrics = value;
        }
        
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}