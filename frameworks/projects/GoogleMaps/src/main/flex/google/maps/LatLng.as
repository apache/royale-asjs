/*
 * Copyright 2010 The Closure Compiler Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*
 * This file was generated from Google's Externs for the Google Maps v3.11 API.
 * Modifications were implemented at the Apache Software Foundation.
 */
package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class LatLng {

    /**
     * @param lat [number] 
     * @param lng [number] 
     * @param opt_noWrap [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function LatLng(lat:Number, lng:Number, opt_noWrap:Boolean = false) {
        super();
		_lat = lat;
		_lng = lng;
    }
	
	private var _lat:Number;
	private var _lng:Number;

    /**
     * @param other [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function equals(other:google.maps.LatLng):Boolean {
		return other.lat() == _lat && other.lng() == _lng;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function toString():String { 
		return String(_lat)+", "+String(_lng);
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function lng():Number { return _lng; }

    /**
     * @param opt_precision [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function toUrlValue(opt_precision:Number = 0):String {  return toString(); }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function lat():Number { return _lat; }

}
}
