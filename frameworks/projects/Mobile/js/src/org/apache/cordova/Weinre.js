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


/**
 * org.apache.cordova.Application
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.cordova.Weinre');



/**
 * @constructor
 */
org.apache.cordova.Weinre = function() {
};


Object.defineProperties(org.apache.cordova.Weinre.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.cordova.Weinre} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    /** @export */
    guid: {
        /** @this {org.apache.cordova.Weinre} */
        set: function(value) {

            var scriptNode = document.createElement('SCRIPT');
            scriptNode.type = 'text/javascript';
            scriptNode.src = 'http://debug.phonegap.com/target/target-script-min.js#' + value;

            var headNode = document.getElementsByTagName('HEAD');
            if (headNode[0] != null)
              headNode[0].appendChild(scriptNode);
        }
    }
});


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.cordova.Weinre.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'Weinre', qName: 'org.apache.cordova.Weinre'}]
};
