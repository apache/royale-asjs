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
package org.apache.flex.maps.google
{
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.maps.google.beads.MapView;
	
	/**
	 *  The Map class displays a Google Map centered on lat/lng coordinates. The Map uses
	 *  the following bead type:
	 * 
	 *  org.apache.flex.maps.beads.MapView: Uses HTMLLoader to display the map.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Map extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Map()
		{
			super();
		}
		
		private var _token:String;
		
		/**
		 *  The Google API developer token.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set token(value:String):void
		{
			_token = value; 
			
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead == null) {
				viewBead = new MapView();
				viewBead.token = value;
				addBead(viewBead);
			}
		}
		
		/**
		 *  Loads a map centered on the given latitude and longitude coodinates at the
		 *  zoom level provided.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function loadMap( centerLat:Number, centerLong:Number, zoom:Number ) : void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead == null) {
				viewBead = new MapView();
				addBead(viewBead);
			}
			if (viewBead) {
				viewBead.mapit(centerLat, centerLong, zoom);
			}
		}
	}
}