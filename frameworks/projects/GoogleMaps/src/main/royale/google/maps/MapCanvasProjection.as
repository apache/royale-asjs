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
 * @constructor extends google.maps.MVCObject */
public class MapCanvasProjection extends google.maps.MVCObject {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function MapCanvasProjection() {
        super();
    }

    /**
     * @param latLng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Point|null)} 
     */
    public function fromLatLngToDivPixel(latLng:google.maps.LatLng):google.maps.Point {  return null; }

    /**
     * @param pixel [(google.maps.Point|null)] 
     * @param opt_nowrap [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function fromContainerPixelToLatLng(pixel:google.maps.Point, opt_nowrap:Boolean = false):google.maps.LatLng {  return null; }

    /**
     * @param latLng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Point|null)} 
     */
    public function fromLatLngToContainerPixel(latLng:google.maps.LatLng):google.maps.Point {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getWorldWidth():Number { return 0; }

    /**
     * @param pixel [(google.maps.Point|null)] 
     * @param opt_nowrap [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function fromDivPixelToLatLng(pixel:google.maps.Point, opt_nowrap:Boolean = false):google.maps.LatLng {  return null; }

}
}
