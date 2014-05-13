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
package org.apache.flex.maps.google.beads
{
	import flash.events.Event;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The MapView bead class displays a Google Map using HTMLLoader.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class MapView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function MapView()
		{
		}
		
		private var _loader:HTMLLoader;
		
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
			
			_loader = new HTMLLoader();
			_loader.x = 0;
			_loader.y = 0;
			_loader.width = UIBase(value).width;
			_loader.height = UIBase(value).height;
			
			IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);
						
			(_strand as UIBase).addChild(_loader);
			
			if (page) {
				_loader.loadString(page);
			}
		}
		
		private var _token:String;
		
		/**
		 *  Sets the API token and modifies the pageTemplate so that a proper
		 *  HTML DOM can be constructed to house the Google Map.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set token(value:String):void
		{
			_token = value;
			
			page = pageTemplate.replace("{Your-Google-Token-Here}",_token);
			
			if (_loader) {
				_loader.loadString(page);
			}
		}
		
		private var page:String;
		
		/**
		 *  Adjusts the map to the given coordinate and zoom level.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function mapit(lat:Number, lng:Number, zoomLevel:Number):void
		{
			if (_loader && page) {
				_loader.window.mapit(lat,lng,zoomLevel);
			}
		}
		
		/**
		 * @private
		 */
		private function handleSizeChange(event:Event):void
		{
			_loader.width = UIBase(_strand).width;
			_loader.height = UIBase(_strand).height;
		}
		
		/**
		 * @private
		 * This page definition is used with HTMLLoader to bring in the Google Maps
		 * API (a Google APP token is required).
		 */
		private static var pageTemplate:String = '<!DOCTYPE html>'+
			'<html>'+
			'  <head>'+
			'    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />'+
			'    <style type="text/css">'+
			'      html { height: 100% }'+
			'      body { height: 100%; margin: 0; padding: 0 }'+
			'      #map-canvas { height: 100% }'+
			'    </style>'+
			'    <script type="text/javascript"'+
			'      src="https://maps.googleapis.com/maps/api/js?key={Your-Google-Token-Here}&sensor=false">'+
			'    </script>'+
			'    <script type="text/javascript">'+
			'      function mapit(lat, lng, zoomLevel) {'+
			'        var mapOptions = {'+
			'          center: new google.maps.LatLng(lat, lng),'+
			'          zoom: zoomLevel'+
			'        };'+
			'        var map = new google.maps.Map(document.getElementById("map-canvas"),'+
			'            mapOptions);'+
			'      };'+
			'      function initialize() {'+
			'        mapit(-34.397, 150.644, 8);'+
			'      };'+
			'      google.maps.event.addDomListener(window, "load", initialize);'+
			'    </script>'+
			'  </head>'+
			'  <body>'+
			'    <div id="map-canvas"/>'+
			'  </body>'+
			'</html>';
	}
}