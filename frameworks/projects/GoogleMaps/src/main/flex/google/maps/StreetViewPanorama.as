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
public class StreetViewPanorama extends google.maps.MVCObject {

    /**
     * @param container [(Node|null)] 
     * @param opt_opts [(Object<?,string>|google.maps.StreetViewPanoramaOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function StreetViewPanorama(container:Object, opt_opts:Object = null) {
        super();
    }

    /**
     * @see JSType - [(Array((google.maps.MVCArray|null))|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var controls:Array;

    /**
     * @param pov [(google.maps.StreetViewPov|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPov(pov:google.maps.StreetViewPov):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.StreetViewPov|null)} 
     */
    public function getPov():google.maps.StreetViewPov {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function getVisible():Boolean {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function getPano():String {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.StreetViewPov|null)} 
     */
    public function getPhotographerPov():google.maps.StreetViewPov {  return null; }

    /**
     * @param zoom [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setZoom(zoom:Number):Object /* undefined */ {  return null; }

    /**
     * @param flag [boolean] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setVisible(flag:Boolean):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getZoom():Number { return 0; }

    /**
     * @param latLng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPosition(latLng:google.maps.LatLng):Object /* undefined */ {  return null; }

    /**
     * @param pano [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPano(pano:String):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getPosition():google.maps.LatLng {  return null; }

    /**
     * @param provider [function (string): (google.maps.StreetViewPanoramaData|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function registerPanoProvider(provider:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(Array<(google.maps.StreetViewLink|null)>|null)} 
     */
    public function getLinks():Array {  return null; }

}
}
