package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class MapCanvasProjection extends google.maps.MVCObject {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function MapCanvasProjection() {
        super();
    }

    /**
     * @param latLng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Point|null)} 
     */
    public function fromLatLngToDivPixel(latLng:google.maps.LatLng):google.maps.Point {  return null; }

    /**
     * @param pixel [(google.maps.Point|null)] 
     * @param opt_nowrap [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function fromContainerPixelToLatLng(pixel:google.maps.Point, opt_nowrap:Boolean = false):google.maps.LatLng {  return null; }

    /**
     * @param latLng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Point|null)} 
     */
    public function fromLatLngToContainerPixel(latLng:google.maps.LatLng):google.maps.Point {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getWorldWidth():Number { return 0; }

    /**
     * @param pixel [(google.maps.Point|null)] 
     * @param opt_nowrap [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function fromDivPixelToLatLng(pixel:google.maps.Point, opt_nowrap:Boolean = false):google.maps.LatLng {  return null; }

}
}
