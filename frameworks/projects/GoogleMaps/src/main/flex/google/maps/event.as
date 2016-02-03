package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class event {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function event():void {  }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param var_args [*] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function trigger(instance:Object, eventName:String, ...var_args):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function clearInstanceListeners(instance:Object):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @param opt_capture [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addDomListenerOnce(instance:Object, eventName:String, handler:Function /* Function */, opt_capture:Boolean = false):google.maps.MapsEventListener {  return null; }

    /**
     * @param listener [(google.maps.MapsEventListener|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function removeListener(listener:google.maps.MapsEventListener):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addListener(instance:Object, eventName:String, handler:Function /* Function */):google.maps.MapsEventListener {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addListenerOnce(instance:Object, eventName:String, handler:Function /* Function */):google.maps.MapsEventListener {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public static function clearListeners(instance:Object, eventName:String):Object /* undefined */ {  return null; }

    /**
     * @param instance [(Object|null)] 
     * @param eventName [string] 
     * @param handler [Function] 
     * @param opt_capture [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public static function addDomListener(instance:Object, eventName:String, handler:Function /* Function */, opt_capture:Boolean = false):google.maps.MapsEventListener {  return null; }

}
}
