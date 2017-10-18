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
 * @constructor extends google.maps.MVCObject */
public class Marker extends google.maps.MVCObject {

    /**
     * @param opt_opts [(Object|google.maps.MarkerOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function Marker(opt_opts:Object = null) {
        super();
		
		_options = opt_opts;
    }
	
	private var _options:Object;
	private var _animation:Animation;
	private var _position:LatLng;
	private var _icon:Object;
	private var _shape:Object;
	private var _shadow:Object;
	private var _title:String;
	private var _draggable:Boolean;
	private var _zIndex:Number;
	private var _visible:Boolean;
	private var _cursor:String;
	private var _flat:Boolean;
	private var _map:Object;
	private var _clickable:Boolean;

    /**
     * @see JSType - [(number|string)] 
     * @see [google_maps_api_v3_11]
     */
    public static var MAX_ZINDEX:Object;

    /**
     * @param animation [(google.maps.Animation|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setAnimation(animation:google.maps.Animation):Object /* undefined */ {
		_animation:animation;
		return undefined;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getPosition():google.maps.LatLng {
		return _position;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Icon|google.maps.Symbol|null|string)} 
     */
    public function getIcon():Object {
		return _icon;
	}

    /**
     * @param shape [(google.maps.MarkerShape|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setShape(shape:Object):Object /* undefined */ {
		_shape = shape;
		return undefined;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Icon|google.maps.Symbol|null|string)} 
     */
    public function getShadow():Object {
		return _shadow;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function getTitle():String {
		return _title;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function getDraggable():Boolean {
		return _draggable;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MarkerShape|null)} 
     */
    public function getShape():Object {
		return _shape;
	}

    /**
     * @param zIndex [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setZIndex(zIndex:Number):Object /* undefined */ {
		_zIndex = zIndex;
		return undefined;
	}

    /**
     * @param flag [(boolean|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setDraggable(flag:Boolean):Object /* undefined */ {
		_draggable = flag;
		return undefined;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Animation|null)} 
     */
    public function getAnimation():google.maps.Animation {
		return _animation;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getZIndex():Number {
		return _zIndex;
	}

    /**
     * @param visible [boolean] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setVisible(visible:Boolean):Object /* undefined */ {
		_visible = visible;
		return undefined;
	}

    /**
     * @param cursor [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setCursor(cursor:String):Object /* undefined */ {
		_cursor = cursor;
		return undefined;
	}

    /**
     * @param latlng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPosition(latlng:google.maps.LatLng):Object /* undefined */ {
		_position = latlng;
		return undefined;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function getFlat():Boolean {
		return _flat;
	}

    /**
     * @param map [(google.maps.Map|google.maps.StreetViewPanorama|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setMap(map:Object):Object /* undefined */ {
		_map = map;
		return undefined;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Map|google.maps.StreetViewPanorama|null)} 
     */
    public function getMap():Object {
		return _map;
	}

    /**
     * @param flag [boolean] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setClickable(flag:Boolean):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function getVisible():Boolean {
		return _visible;
	}

    /**
     * @param shadow [(google.maps.Icon|google.maps.Symbol|null|string)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setShadow(shadow:Object):Object /* undefined */ {
		_shadow = shadow;
		return undefined;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function getCursor():String {
		return _cursor;
	}

    /**
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function getClickable():Boolean {
		return _clickable;
	}

    /**
     * @param flag [boolean] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setFlat(flag:Boolean):Object /* undefined */ {
		_flat = flag;
		return undefined;
	}

    /**
     * @param title [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setTitle(title:String):Object /* undefined */ {
		_title = title;
		return undefined;
	}

    /**
     * @param options [(Object|google.maps.MarkerOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {
		_options = options;
		return undefined;
	}

    /**
     * @param icon [(google.maps.Icon|google.maps.Symbol|null|string)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setIcon(icon:Object):Object /* undefined */ {
		_icon = icon;
		return undefined;
	}

}
}
