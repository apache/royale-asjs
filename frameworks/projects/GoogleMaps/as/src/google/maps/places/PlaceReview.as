package google.maps.places {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class PlaceReview {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function PlaceReview() {
        super();
    }

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var text:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var author_url:String;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var author_name:String;

    /**
     * @see JSType - [(Array<(google.maps.places.PlaceAspectRating|null)>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var aspects:Array;

}
}
