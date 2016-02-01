package google.maps.places {

import google.maps.LatLng;
import google.maps.LatLngBounds;

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class PlaceGeometry {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function PlaceGeometry() {
        super();
    }

    /**
     * @see JSType - [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var viewport:google.maps.LatLngBounds;

    /**
     * @see JSType - [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var location:google.maps.LatLng;

}
}
