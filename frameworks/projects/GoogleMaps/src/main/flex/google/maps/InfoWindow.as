package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class InfoWindow extends google.maps.MVCObject {

    /**
     * @param opt_opts [(Object<?,string>|google.maps.InfoWindowOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function InfoWindow(opt_opts:Object = null) {
        super();
    }

    /**
     * @param zIndex [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setZIndex(zIndex:Number):Object /* undefined */ {  return null; }

    /**
     * @param opt_map [(google.maps.Map|google.maps.StreetViewPanorama|null|undefined)] 
     * @param opt_anchor [(google.maps.MVCObject|null|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function open(opt_map:Object = null, opt_anchor:google.maps.MVCObject = null):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(Node|null|string)} 
     */
    public function getContent():Object {  return null; }

    /**
     * @param options [(Object<?,string>|google.maps.InfoWindowOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getZIndex():Number { return 0; }

    /**
     * @param position [(google.maps.LatLng|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPosition(position:google.maps.LatLng):Object /* undefined */ {  return null; }

    /**
     * @param content [(Node|null|string)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setContent(content:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLng|null)} 
     */
    public function getPosition():google.maps.LatLng {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function close():Object /* undefined */ {  return null; }

}
}
