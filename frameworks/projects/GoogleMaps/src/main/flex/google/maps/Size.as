package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class Size {

    /**
     * @param width [number] 
     * @param height [number] 
     * @param opt_widthUnit [(string|undefined)] 
     * @param opt_heightUnit [(string|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function Size(width:Number, height:Number, opt_widthUnit:String = '', opt_heightUnit:String = '') {
        super();
    }

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var height:Number;

    /**
     * @see JSType - [number] 
     * @see [google_maps_api_v3_11]
     */
    public var width:Number;

    /**
     * @param other [(google.maps.Size|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {boolean} 
     */
    public function equals(other:google.maps.Size):Boolean {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {string} 
     */
    public function toString():String {  return null; }

}
}
