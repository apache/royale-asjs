/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* MapView isn't really the view, but is a bead used to trigger
   the loading of the map JS files */

goog.provide('org.apache.flex.maps.google.beads.MapView');



/**
 * @constructor
 */
org.apache.flex.maps.google.beads.MapView = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.maps.google.beads.MapView.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'MapView',
           qName: 'org.apache.flex.maps.google.beads.MapView' }],
    interfaces: [org.apache.flex.core.IBeadView] };


Object.defineProperties(org.apache.flex.maps.google.beads.MapView.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.maps.google.beads.MapView} */
        set: function(value) {
            this.strand_ = value;

            var token = this.strand_.token;
            var src = 'https://maps.googleapis.com/maps/api/js?v=3.exp';
            if (token)
              src += '&key=' + token;
            src += '&libraries=places&sensor=false&callback=mapInit';

            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = src;

            window.mapView = this;
            window['mapInit'] = function() {
                this.mapView.strand_.finishInitalization();
            };
            document.head.appendChild(script);
        }
    }
});

