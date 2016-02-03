package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class GeocoderResult {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function GeocoderResult() {
        super();
    }

    /**
     * @see JSType - [(Array<(google.maps.GeocoderAddressComponent|null)>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var address_components:Array;

    /**
     * @see JSType - [string] 
     * @see [google_maps_api_v3_11]
     */
    public var formatted_address:String;

    /**
     * @see JSType - [(Array<string>|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var types:Array;

    /**
     * @see JSType - [(google.maps.GeocoderGeometry|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var geometry:google.maps.GeocoderGeometry;

}
}
