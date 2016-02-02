package google.maps.places {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class PlacesService {

    /**
     * @param attrContainer [(HTMLDivElement|google.maps.Map|null)] 
     * @see [google_maps_api_v3_11]
     */
    public function PlacesService(attrContainer:Object) {
        super();
    }

    /**
     * @param request [(Object<?,string>|google.maps.places.PlaceDetailsRequest|null)] 
     * @param callback [function ((google.maps.places.PlaceResult|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getDetails(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.RadarSearchRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.PlaceResult|null)>|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function radarSearch(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.PlaceSearchRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.PlaceResult|null)>|null), (google.maps.places.PlacesServiceStatus|null), (google.maps.places.PlaceSearchPagination|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function nearbySearch(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.TextSearchRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.PlaceResult|null)>|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function textSearch(request:Object, callback:Object):Object /* undefined */ {  return null; }

}
}
