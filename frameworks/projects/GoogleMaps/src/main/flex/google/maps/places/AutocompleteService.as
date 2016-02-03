package google.maps.places {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class AutocompleteService {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function AutocompleteService() {
        super();
    }

    /**
     * @param request [(Object<?,string>|google.maps.places.AutocompletionRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.AutocompletePrediction|null)>|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getPlacePredictions(request:Object, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param request [(Object<?,string>|google.maps.places.QueryAutocompletionRequest|null)] 
     * @param callback [function ((Array<(google.maps.places.QueryAutocompletePrediction|null)>|null), (google.maps.places.PlacesServiceStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getQueryPredictions(request:Object, callback:Object):Object /* undefined */ {  return null; }

}
}
