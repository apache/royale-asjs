package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class MVCObject {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function MVCObject() {
        super();
		_dictionary = new Object();
    }
	
	private var _dictionary:Object;

    /**
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function unbindAll():Object /* undefined */ {
		return undefined;
	}

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {*} 
     */
    public function get(key:String):* {
		if (_dictionary.hasOwnProperty(key)) {
			return _dictionary[key];
		}
		else {
			return undefined;
		}
	}

    /**
     * @param values [(Object|null|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setValues(values:Object):Object /* undefined */ {
		for (var id:String in values) {
			_dictionary[id] = values[id];
		}
		return undefined;
	}

    /**
     * @param key [string] 
     * @param value [?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function set(key:String, value:Object /* ? */):Object /* undefined */ {
		_dictionary[key] = value;
		return undefined;
	}

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function notify(key:String):Object /* undefined */ {  return null; }

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function unbind(key:String):Object /* undefined */ {  return null; }

    /**
     * @param key [string] 
     * @param target [(google.maps.MVCObject|null)] 
     * @param opt_targetKey [(null|string|undefined)] 
     * @param opt_noNotify [(boolean|undefined)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function bindTo(key:String, target:google.maps.MVCObject, opt_targetKey:String = '', opt_noNotify:Boolean = false):Object /* undefined */ {  return null; }

    /**
     * @param eventName [string] 
     * @param handler [Function] 
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.MapsEventListener|null)} 
     */
    public function addListener(eventName:String, handler:Function /* Function */):google.maps.MapsEventListener {  return null; }

    /**
     * @param key [string] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function changed(key:String):Object /* undefined */ {  return null; }

}
}
