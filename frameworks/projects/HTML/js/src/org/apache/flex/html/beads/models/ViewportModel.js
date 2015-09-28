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

goog.provide('org.apache.flex.html.beads.models.ViewportModel');

goog.require('org.apache.flex.core.IStrand');
goog.require('org.apache.flex.core.IViewportModel');
goog.require('org.apache.flex.events.Event');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.IViewportModel}
 */
org.apache.flex.html.beads.models.ViewportModel = function() {
  org.apache.flex.html.beads.models.ViewportModel.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.beads.models.ViewportModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.models.ViewportModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ViewportModel',
                qName: 'org.apache.flex.html.beads.models.ViewportModel' }],
    interfaces: [org.apache.flex.core.IViewportModel]
    };


/**
 * @private
 * @type {Object}
 */
org.apache.flex.html.beads.models.ViewportModel.prototype.strand_ = null;


/**
 * @type {org.apache.flex.geom.Rectangle}
 */
org.apache.flex.html.beads.models.ViewportModel.prototype.borderMetrics = null;


/**
 * @type {org.apache.flex.geom.Rectangle}
 */
org.apache.flex.html.beads.models.ViewportModel.prototype.chromeMetrics = null;


/**
 * @type {number}
 */
org.apache.flex.html.beads.models.ViewportModel.prototype.verticalScrollPosition = NaN;


/**
 * @type {number}
 */
org.apache.flex.html.beads.models.ViewportModel.prototype.horizontalScrollPosition = NaN;


Object.defineProperties(org.apache.flex.html.beads.models.ViewportModel.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.models.ViewportModel} */
        set: function(value) {
            this.strand_ = value;
         },
        /** @this {org.apache.flex.html.beads.models.ViewportModel} */
         get: function() {
             return this.strand_;
        }
    }

});
