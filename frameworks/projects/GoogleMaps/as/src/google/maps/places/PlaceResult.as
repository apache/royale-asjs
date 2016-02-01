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
     * @see JSType - [(Array<(google.maps.places.PlaceReview|null)>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var reviews:Array;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var website:String;

    /**
     * @see JSType - [(Array<(google.maps.places.PlaceAspectRating|null)>|null)] 
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
     * @see JSType - [(Array<(google.maps.places.PlacePhoto|null)>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var photos:Array;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var vicinity:String;

    /**
     * @see JSType - [(Array<string>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var html_attributions:Array;

    /**
     * @see JSType - [(Array<(google.maps.GeocoderAddressComponent|null)>|null)] 
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
     * @see JSType - [(Array<string>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var types:Array;

}
}
