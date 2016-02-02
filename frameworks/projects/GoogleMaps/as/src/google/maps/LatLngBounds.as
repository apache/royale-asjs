package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class LatLngBounds {

    /**
     * @param opt_sw [(google.maps.LatLng|null|undefined)] 
     * @param opt_ne [(google.maps.LatLng|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function LatLngBounds(opt_sw:google.maps.LatLng = null, opt_ne:google.maps.LatLng = null) {
        super();
    }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getNorthEast():google.maps.LatLng {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function isEmpty():Boolean {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function toSpan():google.maps.LatLng {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getCenter():google.maps.LatLng {  return null; }

    /**
     * @param other [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function equals(other:google.maps.LatLngBounds):Boolean {  return null; }

    /**
     * @param point [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLngBounds|null)} 
     */
    public function extend(point:google.maps.LatLng):google.maps.LatLngBounds {  return null; }

    /**
     * @param other [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLngBounds|null)} 
     */
    public function union(other:google.maps.LatLngBounds):google.maps.LatLngBounds {  return null; }

    /**
     * @param other [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function intersects(other:google.maps.LatLngBounds):Boolean {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function toString():String {  return null; }

    /**
     * @param latLng [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function contains(latLng:google.maps.LatLng):Boolean {  return null; }

    /**
     * @param opt_precision [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function toUrlValue(opt_precision:Number = 0):String {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getSouthWest():google.maps.LatLng {  return null; }

}
}
