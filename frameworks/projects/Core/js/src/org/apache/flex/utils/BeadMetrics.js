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

goog.provide('org.apache.flex.utils.BeadMetrics');

goog.require('org.apache.flex.core.UIMetrics');



/**
 * @constructor
 */
org.apache.flex.utils.BeadMetrics = function() {
};


/**
 * @export
 * @param {org.apache.flex.core.IStrand} strand The strand whose bounds are required.
 * @return {org.apache.flex.core.UIMetrics} The bounding box.
 */
org.apache.flex.utils.BeadMetrics.getMetrics = function(strand) {
  var box = new org.apache.flex.core.UIMetrics();
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
  if (style['margin']) {
    box.marginLeft = Number(style.margin);
    box.marginTop = Number(style.margin);
    box.marginRight = Number(style.margin);
    box.marginBottom = Number(style.margin);
  } else {
    if (style['margin_top']) box.marginTop = Number(style.margin_top);
    if (style['margin_left']) box.marginLeft = Number(style.margin_left);
    if (style['margin_bottom']) box.marginBottom = Number(style.margin_bottom);
    if (style['margin_right']) box.marginRight = Number(style.margin_right);
  }
  return box;
};
