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

goog.provide('org.apache.flex.utils.PointUtils');

goog.require('org.apache.flex.geom.Point');



/**
 * @constructor
 */
org.apache.flex.utils.PointUtils = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.utils.PointUtils.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'PointUtils',
                qName: 'org.apache.flex.utils.PointUtils' }] };


/**
 * @export
 * @param {org.apache.flex.geom.Point} point The Point to be converted.
 * @param {Object} local The object used as reference.
 * @return {org.apache.flex.geom.Point} The converted Point.
 */
org.apache.flex.utils.PointUtils.globalToLocal =
    function(point, local) {
  var x = point.x, y = point.y;
  var element = local.element;

  do {
    x -= element.offsetLeft;
    y -= element.offsetTop;
    if (local.hasOwnProperty('parent')) {
      local = local.parent;
      element = local.element;
    } else {
      element = null;
    }
  }
  while (element);
  return new org.apache.flex.geom.Point(x, y);
};


/**
 * @export
 * @param {org.apache.flex.geom.Point} point The Point to be converted.
 * @param {Object} local The object used as reference.
 * @return {org.apache.flex.geom.Point} The converted Point.
 */
org.apache.flex.utils.PointUtils.localToGlobal =
    function(point, local) {
  var x = point.x, y = point.y;
  var element = local.element;

  do {
    x += element.offsetLeft;
    y += element.offsetTop;
    element = element.offsetParent;
  }
  while (element);
  return new org.apache.flex.geom.Point(x, y);
};
