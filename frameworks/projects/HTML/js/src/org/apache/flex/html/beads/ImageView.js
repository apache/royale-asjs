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

goog.provide('org.apache.flex.html.beads.ImageView');


goog.require('org.apache.flex.html.beads.models.ImageModel');



/**
 * @constructor
 */
org.apache.flex.html.beads.ImageView = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.ImageView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageView',
                qName: 'org.apache.flex.html.beads.ImageView'}] };


Object.defineProperties(org.apache.flex.html.beads.ImageView.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.ImageView} */
        set: function(value) {
            this.strand_ = value;

            this.model = value.getBeadByType(
                org.apache.flex.html.beads.models.ImageModel);
            this.model.addEventListener('sourceChanged',
                goog.bind(this.sourceChangeHandler, this));
        }
    }
});


/**
 * @export
 * @param {Object} event The event triggered by the source change.
 */
org.apache.flex.html.beads.ImageView.prototype.
    sourceChangeHandler = function(event) {
  this.strand_.element.addEventListener('load',
      goog.bind(this.loadHandler, this));
  this.strand_.addEventListener('sizeChanged',
      goog.bind(this.sizeChangedHandler, this));
  this.strand_.element.src = this.model.source;
};


/**
 * @export
 * @param {Object} event The event triggered by the load.
 */
org.apache.flex.html.beads.ImageView.prototype.
    loadHandler = function(event) {
  this.strand_.parent.dispatchEvent('layoutNeeded');
};


/**
 * @export
 * @param {Object} event The event triggered by the size change.
 */
org.apache.flex.html.beads.ImageView.prototype.
    sizeChangedHandler = function(event) {
  var s = this.strand_.positioner.style;
  var l = NaN;
  var ls = s.left;
  if (typeof(ls) === 'string' && ls.length > 0)
    l = parseFloat(ls.substring(0, ls.length - 2));
  var r = NaN;
  var rs = s.right;
  if (typeof(rs) === 'string' && rs.length > 0)
    r = parseFloat(rs.substring(0, rs.length - 2));
  if (!isNaN(l) &&
      !isNaN(r)) {
    // if just using size constraints and image will not shrink or grow
    var computedWidth = this.strand_.positioner.offsetParent.offsetWidth -
                           l - r;
    s.width = computedWidth.toString() + 'px';
  }
  var t = NaN;
  var ts = s.top;
  if (typeof(ts) === 'string' && ts.length > 0)
    t = parseFloat(ts.substring(0, ts.length - 2));
  var b = NaN;
  var bs = s.right;
  if (typeof(bs) === 'string' && bs.length > 0)
    b = parseFloat(bs.substring(0, bs.length - 2));
  if (!isNaN(t) &&
      !isNaN(b)) {
    // if just using size constraints and image will not shrink or grow
    var computedHeight = this.strand_.positioner.offsetParent.offsetHeight -
                           t - b;
    s.height = computedHeight.toString() + 'px';
  }
};
