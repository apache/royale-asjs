package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MouseEvent */
public class PolyMouseEvent extends google.maps.MouseEvent {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function PolyMouseEvent() {
        super();
    }

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var edge:Number;

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var vertex:Number;

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var path:Number;

}
}
