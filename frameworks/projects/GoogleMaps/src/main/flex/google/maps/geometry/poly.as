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
 */
package google.maps.geometry {

import google.maps.LatLng;
import google.maps.Polygon;

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class poly {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function poly():void {  }

    /**
     * @param point [(google.maps.LatLng|null)] 
     * @param polygon [(google.maps.Polygon|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public static function containsLocation(point:google.maps.LatLng, polygon:google.maps.Polygon):Boolean {  return null; }

    /**
     * @param point [(google.maps.LatLng|null)] 
     * @param poly [(google.maps.Polygon|google.maps.Polyline|null)] 
     * @param opt_tolerance [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public static function isLocationOnEdge(point:google.maps.LatLng, poly:Object, opt_tolerance:Number = 0):Boolean {  return null; }

}
}
