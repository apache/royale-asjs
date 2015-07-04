/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 FalconJX will inject html into the index.html file.  Surround with
 "inject_html" tag as follows:

 <inject_html>
    <script type="text/javascript" src="cordova.js"></script>
 </inject_html>
 */

/**
 * org_apache_cordova_camera_Camera
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_cordova_camera_Camera');



/**
 * @constructor
 */
org_apache_cordova_camera_Camera = function() {
  this.pictureSourceType = org_apache_cordova_camera_Camera.PictureSourceType.PHOTOLIBRARY;
  this.destinationType = org_apache_cordova_camera_Camera.DestinationType.DATA_URL;
  this.mediaType = org_apache_cordova_camera_Camera.MediaType.PICTURE;
  this.encodingType = org_apache_cordova_camera_Camera.EncodingType.JPEG;
  this.direction = org_apache_cordova_camera_Camera.Direction.BACK;
};


/**
 * @type {Object}
 */
org_apache_cordova_camera_Camera.DestinationType = {DATA_URL: 0, FILE_URI: 1, NATIVE_URI: 2};


/**
 * @type {Object}
 */
org_apache_cordova_camera_Camera.PictureSourceType = {PHOTOLIBRARY: 0, CAMERA: 1, SAVEDPHOTOALBUM: 2};


/**
 * @type {Object}
 */
org_apache_cordova_camera_Camera.EncodingType = {JPEG: 0, PNG: 1};


/**
 * @type {Object}
 */
org_apache_cordova_camera_Camera.MediaType = {PICTURE: 0, VIDEO: 1, ALLMEDIA: 2};


/**
 * @type {Object}
 */
org_apache_cordova_camera_Camera.Direction = {BACK: 0, FRONT: 1};


/**
 * @type {number}
 */
//org_apache_cordova_camera_Camera.prototype.pictureSourceType;


/**
 * @type {number}
 */
//org_apache_cordova_camera_Camera.prototype.destinationType;


/**
 * @type {number}
 */
//org_apache_cordova_camera_Camera.prototype.mediaType;


/**
 * @type {number}
 */
//org_apache_cordova_camera_Camera.prototype.encodingType;


/**
 * @type {number}
 */
//org_apache_cordova_camera_Camera.prototype.direction;


/**
 * @export
 * @param {Function} cameraSuccess
 * @param {Function} cameraError
 * @param {Object} cameraOptions
 */
org_apache_cordova_camera_Camera.prototype.getPicture = function(cameraSuccess, cameraError, cameraOptions) {
  navigator.camera.getPicture(cameraSuccess, cameraError, cameraOptions);
};


/**
 * @export
 * @param {Function} cameraSuccess
 * @param {Function} cameraError
 */
org_apache_cordova_camera_Camera.prototype.cleanup = function(cameraSuccess, cameraError) {
  navigator.camera.cleanup();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_cordova_camera_Camera.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'Camera', qName: 'org_apache_cordova_camera_Camera'}]
};
