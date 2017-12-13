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
public class MVCObject {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function MVCObject() {
        super();
		_dictionary = new Object();
    }
	
	private var _dictionary:Object;

    /**
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function unbindAll():Object /* undefined */ {
		return undefined;
	}

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {*} 
     */
    public function get(key:String):* {
		if (_dictionary.hasOwnProperty(key)) {
			return _dictionary[key];
		}
		else {
			return undefined;
		}
	}

    /**
     * @param values [(Object|null|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setValues(values:Object):Object /* undefined */ {
		for (var id:String in values) {
			_dictionary[id] = values[id];
		}
		return undefined;
	}

    /**
     * @param key [string] 
     * @param value [?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function set(key:String, value:Object /* ? */):Object /* undefined */ {
		_dictionary[key] = value;
		return undefined;
	}

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function notify(key:String):Object /* undefined */ {  return null; }

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function unbind(key:String):Object /* undefined */ {  return null; }

    /**
     * @param key [string] 
     * @param target [(google.maps.MVCObject|null)] 
     * @param opt_targetKey [(null|string|undefined)] 
     * @param opt_noNotify [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function bindTo(key:String, target:google.maps.MVCObject, opt_targetKey:String = '', opt_noNotify:Boolean = false):Object /* undefined */ {  return null; }

    /**
     * @param eventName [string] 
     * @param handler [Function] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public function addListener(eventName:String, handler:Function /* Function */):google.maps.MapsEventListener {  return null; }

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function changed(key:String):Object /* undefined */ {  return null; }

}
}
