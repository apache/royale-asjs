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
package google.maps.places {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class PlacesService {

    /**
     * @param attrContainer [(HTMLDivElement|google.maps.Map|null)] 
     * @see [google_maps_api_v3_11]
     */
    public function PlacesService(attrContainer:Object) {
        super();
    }

    /**
     * @param request [(Object<?,string>|google.maps.places.PlaceDetailsRequest|null)] 
     * @param callback [function ((google.maps.places.PlaceResult|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getDetails(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.RadarSearchRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.PlaceResult|null)>|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function radarSearch(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.PlaceSearchRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.PlaceResult|null)>|null), (google.maps.places.PlacesServiceStatus|null), (google.maps.places.PlaceSearchPagination|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function nearbySearch(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.TextSearchRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.PlaceResult|null)>|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function textSearch(request:Object, callback:Object):Object /* undefined */ {  return null; }

}
}
