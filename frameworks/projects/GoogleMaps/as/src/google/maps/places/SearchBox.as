package google.maps.places {

import google.maps.MVCObject;
import google.maps.LatLngBounds;
import google.pseudo.Node;
import google.pseudo.HTMLInputElement;

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class SearchBox extends google.maps.MVCObject {

    /**
     * @param inputField [(HTMLInputElement|null)] 
     * @param opt_opts [(Object<?,string>|google.maps.places.SearchBoxOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function SearchBox(inputField:HTMLInputElement, opt_opts:Object = null) {
        super();
    }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(Array<(google.maps.places.PlaceResult|null)>|null)} 
     */
    public function getPlaces():Array {  return null; }

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

}
}
