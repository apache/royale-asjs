package google.maps.geometry {

import google.maps.LatLng;

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class spherical {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function spherical():void {  }

    /**
     * @param from [(google.maps.LatLng|null)] 
     * @param distance [number] 
     * @param heading [number] 
     * @param opt_radius [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public static function computeOffset(from:google.maps.LatLng, distance:Number, heading:Number, opt_radius:Number = 0):google.maps.LatLng {  return null; }

    /**
     * @param from [(google.maps.LatLng|null)] 
     * @param to [(google.maps.LatLng|null)] 
     * @param opt_radius [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public static function computeDistanceBetween(from:google.maps.LatLng, to:google.maps.LatLng, opt_radius:Number = 0):Number { return 0; }

    /**
     * @param to [(google.maps.LatLng|null)] 
     * @param distance [number] 
     * @param heading [number] 
     * @param opt_radius [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public static function computeOffsetOrigin(to:google.maps.LatLng, distance:Number, heading:Number, opt_radius:Number = 0):google.maps.LatLng {  return null; }

    /**
     * @param from [(google.maps.LatLng|null)] 
     * @param to [(google.maps.LatLng|null)] 
     * @param fraction [number] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public static function interpolate(from:google.maps.LatLng, to:google.maps.LatLng, fraction:Number):google.maps.LatLng {  return null; }

    /**
     * @param path [(Array<(google.maps.LatLng|null)>|google.maps.MVCArray|null)] 
     * @param opt_radius [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public static function computeLength(path:Object, opt_radius:Number = 0):Number { return 0; }

    /**
     * @param loop [(Array<(google.maps.LatLng|null)>|google.maps.MVCArray|null)] 
     * @param opt_radius [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public static function computeSignedArea(loop:Object, opt_radius:Number = 0):Number { return 0; }

    /**
     * @param from [(google.maps.LatLng|null)] 
     * @param to [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public static function computeHeading(from:google.maps.LatLng, to:google.maps.LatLng):Number { return 0; }

    /**
     * @param path [(Array<(google.maps.LatLng|null)>|google.maps.MVCArray|null)] 
     * @param opt_radius [(number|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public static function computeArea(path:Object, opt_radius:Number = 0):Number { return 0; }

}
}
