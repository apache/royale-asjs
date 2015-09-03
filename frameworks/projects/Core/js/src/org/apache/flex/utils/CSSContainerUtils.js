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

goog.provide('org.apache.flex.utils.CSSContainerUtils');

goog.require('org.apache.flex.geom.Rectangle');
goog.require('org.apache.flex.utils.CSSUtils');



/**
 * @constructor
 */
org.apache.flex.utils.CSSContainerUtils = function() {
};


/**
 * @export
 * @param {Object} object The strand whose border offsets are required.
 * @return {org.apache.flex.geom.Rectangle} The four border widths.
 */
org.apache.flex.utils.CSSContainerUtils.getBorderMetrics = function(object) {
  var style = getComputedStyle(object.element);
  var borderLeft = org.apache.flex.utils.CSSUtils.toNumber(style['border-left-width'], object.width);
  var borderRight = org.apache.flex.utils.CSSUtils.toNumber(style['border-right-width'], object.width);
  var borderTop = org.apache.flex.utils.CSSUtils.toNumber(style['border-top-width'], object.width);
  var borderBottom = org.apache.flex.utils.CSSUtils.toNumber(style['border-bottom-width'], object.width);
  return new org.apache.flex.geom.Rectangle(borderLeft, borderTop, borderRight - borderLeft, borderBottom - borderTop);
};


/**
 * @export
 * @param {Object} object The strand whose padding offsets are required.
 * @return {org.apache.flex.geom.Rectangle} The four padding widths.
 */
org.apache.flex.utils.CSSContainerUtils.getPaddingMetrics = function(object) {
  var style = getComputedStyle(object.element);
  var paddingLeft = org.apache.flex.utils.CSSUtils.toNumber(style['padding-left'], object.width);
  var paddingRight = org.apache.flex.utils.CSSUtils.toNumber(style['padding-right'], object.width);
  var paddingTop = org.apache.flex.utils.CSSUtils.toNumber(style['padding-top'], object.width);
  var paddingBottom = org.apache.flex.utils.CSSUtils.toNumber(style['padding-bottom'], object.width);
  return new org.apache.flex.geom.Rectangle(paddingLeft, paddingTop,
                                            paddingRight - paddingLeft, paddingBottom - paddingTop);
};


/**
 * @export
 * @param {Object} object The strand whose border and padding offsets are required.
 * @return {org.apache.flex.geom.Rectangle} The four border padding widths.
 */
org.apache.flex.utils.CSSContainerUtils.getBorderAndPaddingMetrics = function(object) {
  var style = getComputedStyle(object.element);
  var borderLeft = org.apache.flex.utils.CSSUtils.toNumber(style['border-left-width'], object.width);
  var borderRight = org.apache.flex.utils.CSSUtils.toNumber(style['border-right-width'], object.width);
  var borderTop = org.apache.flex.utils.CSSUtils.toNumber(style['border-top-width'], object.width);
  var borderBottom = org.apache.flex.utils.CSSUtils.toNumber(style['border-bottom-width'], object.width);
  var paddingLeft = org.apache.flex.utils.CSSUtils.toNumber(style['padding-left'], object.width);
  var paddingRight = org.apache.flex.utils.CSSUtils.toNumber(style['padding-right'], object.width);
  var paddingTop = org.apache.flex.utils.CSSUtils.toNumber(style['padding-top'], object.width);
  var paddingBottom = org.apache.flex.utils.CSSUtils.toNumber(style['padding-bottom'], object.width);
  paddingLeft += borderLeft;
  paddingRight += borderRight;
  paddingTop += borderTop;
  paddingBottom += borderBottom;
  return new org.apache.flex.geom.Rectangle(paddingLeft, paddingTop,
                                            paddingRight - paddingLeft, paddingBottom - paddingTop);
};
