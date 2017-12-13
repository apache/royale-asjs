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
public class Map extends google.maps.MVCObject {

    /**
     * @param mapDiv [(Node|null)] 
     * @param opt_opts [(Object<?,string>|google.maps.MapOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function Map(mapDiv:Object, opt_opts:Object = null) {
        super();
    }

    /**
     * @see JSType - [(Array((google.maps.MVCArray|null))|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var controls:Array;

    /**
     * @see JSType - [(google.maps.MapTypeRegistry|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var mapTypes:google.maps.MapTypeRegistry;

    /**
     * @see JSType - [(google.maps.MVCArray|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var overlayMapTypes:google.maps.MVCArray;

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getCenter():google.maps.LatLng {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getTilt():Number { return 0; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(Node|null)} 
     */
    public function getDiv():Object {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Projection|null)} 
     */
    public function getProjection():Object { return null; } //google.maps.Projection {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getHeading():Number { return 0; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapTypeId|null|string)} 
     */
    public function getMapTypeId():Object {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.StreetViewPanorama|null)} 
     */
    public function getStreetView():google.maps.StreetViewPanorama {  return null; }

    /**
     * @param x [number] 
     * @param y [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function panBy(x:Number, y:Number):Object /* undefined */ {  return null; }

    /**
     * @param panorama [(google.maps.StreetViewPanorama|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setStreetView(panorama:google.maps.StreetViewPanorama):Object /* undefined */ {  return null; }

    /**
     * @param bounds [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function fitBounds(bounds:google.maps.LatLngBounds):Object /* undefined */ {  return null; }

    /**
     * @param options [(Object<?,string>|google.maps.MapOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {  return null; }

    /**
     * @param zoom [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setZoom(zoom:Number):Object /* undefined */ {  return null; }

    /**
     * @param tilt [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setTilt(tilt:Number):Object /* undefined */ {  return null; }

    /**
     * @param mapTypeId [(google.maps.MapTypeId|null|string)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setMapTypeId(mapTypeId:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLngBounds|null)} 
     */
    public function getBounds():google.maps.LatLngBounds {  return null; }

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
    public function panTo(latLng:google.maps.LatLng):Object /* undefined */ {  return null; }

    /**
     * @param latLngBounds [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function panToBounds(latLngBounds:google.maps.LatLngBounds):Object /* undefined */ {  return null; }

    /**
     * @param heading [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setHeading(heading:Number):Object /* undefined */ {  return null; }

    /**
     * @param latlng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setCenter(latlng:google.maps.LatLng):Object /* undefined */ {  return null; }

}
}
