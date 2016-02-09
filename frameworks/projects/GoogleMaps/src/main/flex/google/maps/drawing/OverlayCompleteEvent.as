package google.maps.drawing {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class OverlayCompleteEvent {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function OverlayCompleteEvent() {
        super();
    }

    /**
     * @see JSType - [(google.maps.Circle|google.maps.Marker|google.maps.Polygon|google.maps.Polyline|google.maps.Rectangle|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var overlay:Object;

    /**
     * @see JSType - [(google.maps.drawing.OverlayType|null)] 
     * @see [google_maps_api_v3_11]
     */
    public var type:google.maps.drawing.OverlayType;

}
}
