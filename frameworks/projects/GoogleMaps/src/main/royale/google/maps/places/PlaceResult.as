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
public class PlaceResult {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function PlaceResult() {
        super();
    }

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var icon:String;

    /**
     * @see JSType - [(Array((google.maps.places.PlaceReview|null))|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var reviews:Array;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var website:String;

    /**
     * @see JSType - [(Array((google.maps.places.PlaceAspectRating|null))|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var aspects:Array;

    /**
     * @see JSType - [boolean] 
     * @see [google_maps_api_v3_11]
     */
    public var permanently_closed:Boolean;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var review_summary:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var international_phone_number:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var url:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var reference:String;

    /**
     * @see JSType - [(google.maps.places.PlaceGeometry|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var geometry:google.maps.places.PlaceGeometry;

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var price_level:Number;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var id:String;

    /**
     * @see JSType - [(Array((google.maps.places.PlacePhoto|null))|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var photos:Array;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var vicinity:String;

    /**
     * @see JSType - [(Array(string)|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var html_attributions:Array;

    /**
     * @see JSType - [(Array((google.maps.GeocoderAddressComponent|null))|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var address_components:Array;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var name:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var formatted_address:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var formatted_phone_number:String;

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var rating:Number;

    /**
     * @see JSType - [(Array(string)|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var types:Array;

}
}
