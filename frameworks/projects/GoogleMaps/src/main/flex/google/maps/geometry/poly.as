package google.maps.geometry {

import google.maps.LatLng;
import google.maps.Polygon;

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class poly {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function poly():void {  }

    /**
     * @param point [(google.maps.LatLng|null)] 
     * @param polygon [(google.maps.Polygon|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public static function containsLocation(point:google.maps.LatLng, polygon:google.maps.Polygon):Boolean {  return null; }

    /**
     * @param point [(google.maps.LatLng|null)] 
     * @param poly [(google.maps.Polygon|google.maps.Polyline|null)] 
     * @param opt_tolerance [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public static function isLocationOnEdge(point:google.maps.LatLng, poly:Object, opt_tolerance:Number = 0):Boolean {  return null; }

}
}
