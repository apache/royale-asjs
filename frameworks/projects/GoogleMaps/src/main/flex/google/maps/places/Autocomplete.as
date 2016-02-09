package google.maps.places {

import google.maps.MVCObject;
import google.maps.LatLngBounds;
import google.pseudo.HTMLInputElement;

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class Autocomplete extends google.maps.MVCObject {

    /**
     * @param inputField [(HTMLInputElement|null)] 
     * @param opt_opts [(Object<?,string>|google.maps.places.AutocompleteOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function Autocomplete(inputField:HTMLInputElement, opt_opts:Object = null) {
        super();
    }

    /**
     * @param restrictions [(google.maps.places.ComponentRestrictions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setComponentRestrictions(restrictions:google.maps.places.ComponentRestrictions):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.LatLngBounds|null)} 
     */
    public function getBounds():google.maps.LatLngBounds {  return null; }

    /**
     * @param bounds [(google.maps.LatLngBounds|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setBounds(bounds:google.maps.LatLngBounds):Object /* undefined */ {  return null; }

    /**
     * @param types [(Array<string>|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setTypes(types:Array):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.places.PlaceResult|null)} 
     */
    public function getPlace():google.maps.places.PlaceResult {  return null; }

}
}
