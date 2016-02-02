package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class DirectionsRenderer extends google.maps.MVCObject {

    /**
     * @param opt_opts [(Object<?,string>|google.maps.DirectionsRendererOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function DirectionsRenderer(opt_opts:Object = null) {
        super();
    }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {number} 
     */
    public function getRouteIndex():Number { return 0; }

    /**
     * @param routeIndex [number] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setRouteIndex(routeIndex:Number):Object /* undefined */ {  return null; }

    /**
     * @param panel [(Node|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setPanel(panel:Node):Object /* undefined */ {  return null; }

    /**
     * @param options [(Object<?,string>|google.maps.DirectionsRendererOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {  return null; }

    /**
     * @param directions [(google.maps.DirectionsResult|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setDirections(directions:google.maps.DirectionsResult):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.DirectionsResult|null)} 
     */
    public function getDirections():google.maps.DirectionsResult {  return null; }

    /**
     * @param map [(google.maps.Map|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setMap(map:google.maps.Map):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(Node|null)} 
     */
    public function getPanel():Node {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Map|null)} 
     */
    public function getMap():google.maps.Map {  return null; }

}
}
