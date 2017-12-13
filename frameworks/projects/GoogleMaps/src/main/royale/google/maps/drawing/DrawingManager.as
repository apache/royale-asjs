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
package google.maps.drawing {

import google.maps.Map;
import google.maps.MVCObject;

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class DrawingManager extends google.maps.MVCObject {

    /**
     * @param opt_options [(Object<?,string>|google.maps.drawing.DrawingManagerOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function DrawingManager(opt_options:Object = null) {
        super();
    }

    /**
     * @param drawingMode [(google.maps.drawing.OverlayType|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setDrawingMode(drawingMode:google.maps.drawing.OverlayType):Object /* undefined */ {  return null; }

    /**
     * @param options [(Object<?,string>|google.maps.drawing.DrawingManagerOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.drawing.OverlayType|null)} 
     */
    public function getDrawingMode():google.maps.drawing.OverlayType {  return null; }

    /**
     * @param map [(google.maps.Map|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setMap(map:google.maps.Map):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Map|null)} 
     */
    public function getMap():google.maps.Map {  return null; }

}
}
