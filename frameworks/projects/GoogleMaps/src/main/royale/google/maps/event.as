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
public class event {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function event():void {  }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param var_args [*] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function trigger(instance:Object, eventName:String, ...var_args):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function clearInstanceListeners(instance:Object):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @param opt_capture [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addDomListenerOnce(instance:Object, eventName:String, handler:Function /* Function */, opt_capture:Boolean = false):google.maps.MapsEventListener {  return null; }

    /**
     * @param listener [(google.maps.MapsEventListener|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function removeListener(listener:google.maps.MapsEventListener):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addListener(instance:Object, eventName:String, handler:Function /* Function */):google.maps.MapsEventListener {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addListenerOnce(instance:Object, eventName:String, handler:Function /* Function */):google.maps.MapsEventListener {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function clearListeners(instance:Object, eventName:String):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @param opt_capture [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addDomListener(instance:Object, eventName:String, handler:Function /* Function */, opt_capture:Boolean = false):google.maps.MapsEventListener {  return null; }

}
}
