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
public class InfoWindow extends google.maps.MVCObject {

    /**
     * @param opt_opts [(Object<?,string>|google.maps.InfoWindowOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function InfoWindow(opt_opts:Object = null) {
        super();
    }

    /**
     * @param zIndex [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setZIndex(zIndex:Number):Object /* undefined */ {  return null; }

    /**
     * @param opt_map [(google.maps.Map|google.maps.StreetViewPanorama|null|undefined)] 
     * @param opt_anchor [(google.maps.MVCObject|null|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function open(opt_map:Object = null, opt_anchor:google.maps.MVCObject = null):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(Node|null|string)} 
     */
    public function getContent():Object {  return null; }

    /**
     * @param options [(Object<?,string>|google.maps.InfoWindowOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getZIndex():Number { return 0; }

    /**
     * @param position [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPosition(position:google.maps.LatLng):Object /* undefined */ {  return null; }

    /**
     * @param content [(Node|null|string)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setContent(content:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getPosition():google.maps.LatLng {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function close():Object /* undefined */ {  return null; }

}
}
