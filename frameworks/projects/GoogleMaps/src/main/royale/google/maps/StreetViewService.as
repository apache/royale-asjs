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
package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class StreetViewService {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function StreetViewService() {
        super();
    }

    /**
     * @param latlng [(google.maps.LatLng|null)] 
     * @param radius [number] 
     * @param callback [function ((google.maps.StreetViewPanoramaData|null), (google.maps.StreetViewStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getPanoramaByLocation(latlng:google.maps.LatLng, radius:Number, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param pano [string] 
     * @param callback [function ((google.maps.StreetViewPanoramaData|null), (google.maps.StreetViewStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getPanoramaById(pano:String, callback:Object):Object /* undefined */ {  return null; }

}
}
