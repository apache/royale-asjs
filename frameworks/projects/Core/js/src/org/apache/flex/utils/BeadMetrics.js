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

goog.provide('org_apache_flex_utils_BeadMetrics');

goog.require('org_apache_flex_core_UIMetrics');



/**
 * @constructor
 */
org_apache_flex_utils_BeadMetrics = function() {
};


/**
 * @expose
 * @param {org_apache_flex_core_IStrand} strand The strand whose bounds are required.
 * @return {org_apache_flex_core_UIMetrics} The bounding box.
 */
org_apache_flex_utils_BeadMetrics.getMetrics = function(strand) {
  var box = new org_apache_flex_core_UIMetrics();
  var style = strand.element.style;
  if (style['padding']) {
    box.top = Number(style.padding);
    box.left = Number(style.padding);
    box.right = Number(style.padding);
    box.bottom = Number(style.padding);
  } else {
    if (style['padding_top']) box.top = Number(style.padding_top);
    if (style['padding_left']) box.left = Number(style.padding_left);
    if (style['padding_right']) box.right = Number(style.padding_right);
    if (style['padding_bottom']) box.bottom = Number(style.padding_bottom);
  }
  return box;
};