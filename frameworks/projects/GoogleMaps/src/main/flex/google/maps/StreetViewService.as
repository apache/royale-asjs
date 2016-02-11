package google.maps {

/**
 * @see [google_maps_api_v3_11]
 * @constructor  */
public class StreetViewService {

    /**
     * @see [google_maps_api_v3_11]
     */
    public function StreetViewService() {
        super();
    }

    /**
     * @param latlng [(google.maps.LatLng|null)] 
     * @param radius [number] 
     * @param callback [function ((google.maps.StreetViewPanoramaData|null), (google.maps.StreetViewStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getPanoramaByLocation(latlng:google.maps.LatLng, radius:Number, callback:Object):Object /* undefined */ {  return null; }

    /**
     * @param pano [string] 
     * @param callback [function ((google.maps.StreetViewPanoramaData|null), (google.maps.StreetViewStatus|null)): ?] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function getPanoramaById(pano:String, callback:Object):Object /* undefined */ {  return null; }

}
}
