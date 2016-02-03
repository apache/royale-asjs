package google.maps.drawing {

import google.maps.Map;
import google.maps.MVCObject;

/**
 * @see [google_maps_api_v3_11]
 * @constructor extends google.maps.MVCObject */
public class DrawingManager extends google.maps.MVCObject {

    /**
     * @param opt_options [(Object<?,string>|google.maps.drawing.DrawingManagerOptions|null|undefined)] 
     * @see [google_maps_api_v3_11]
     */
    public function DrawingManager(opt_options:Object = null) {
        super();
    }

    /**
     * @param drawingMode [(google.maps.drawing.OverlayType|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setDrawingMode(drawingMode:google.maps.drawing.OverlayType):Object /* undefined */ {  return null; }

    /**
     * @param options [(Object<?,string>|google.maps.drawing.DrawingManagerOptions|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setOptions(options:Object):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.drawing.OverlayType|null)} 
     */
    public function getDrawingMode():google.maps.drawing.OverlayType {  return null; }

    /**
     * @param map [(google.maps.Map|null)] 
     * @see [google_maps_api_v3_11]
     * @returns {undefined} 
     */
    public function setMap(map:google.maps.Map):Object /* undefined */ {  return null; }

    /**
     * @see [google_maps_api_v3_11]
     * @returns {(google.maps.Map|null)} 
     */
    public function getMap():google.maps.Map {  return null; }

}
}
