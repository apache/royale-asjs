package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class GroundOverlay extends google.maps.MVCObject {

    /**
     * @param url [string] 
     * @param bounds [(google.maps.LatLngBounds|null)] 
     * @param opt_opts [(Object<?,string>|google.maps.GroundOverlayOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function GroundOverlay(url:String, bounds:google.maps.LatLngBounds, opt_opts:Object = null) {
        super();
    }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function getUrl():String {  return null; }

    /**
     * @param opacity [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOpacity(opacity:Number):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLngBounds|null)} 
     */
    public function getBounds():google.maps.LatLngBounds {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getOpacity():Number { return 0; }

    /**
     * @param map [(google.maps.Map|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setMap(map:google.maps.Map):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Map|null)} 
     */
    public function getMap():google.maps.Map {  return null; }

}
}
