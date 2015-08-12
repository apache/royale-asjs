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
goog.require('org.apache.flex.utils.CSSUtils');



/**
 * @constructor
 */
org.apache.flex.utils.BeadMetrics = function() {
};


/**
 * @export
 * @param {Object} object The strand whose bounds are required.
 * @return {org.apache.flex.core.UIMetrics} The bounding box.
 */
org.apache.flex.utils.BeadMetrics.getMetrics = function(object) {
  var box = new org.apache.flex.core.UIMetrics();
  var style = getComputedStyle(object.element);
  var borderThickness = style['border-width'];
  var borderStyle = style['border-style'];
  var border = style['border'];
  var borderOffset;
  if (borderStyle == 'none')
    borderOffset = 0;
  else if (borderThickness != null) {
    if (typeof(borderThickness) === 'string')
      borderOffset = org.apache.flex.utils.CSSUtils.toNumber(borderThickness, object.width);
    else
      borderOffset = borderThickness;
    if (isNaN(borderOffset)) borderOffset = 0;
  }
  else {// no style and/or no width
    border = style['border'];
    if (border != null) {
      if (typeof(border) !== 'string') {
         borderOffset = org.apache.flex.utils.CSSUtils.toNumber(border[0], object.width);
         borderStyle = border[1];
       }
       else if (border == 'none')
         borderOffset = 0;
       else if (typeof(border) === 'string')
         borderOffset = org.apache.flex.utils.CSSUtils.toNumber(border, object.width);
       else
         borderOffset = Number(border);
     }
     else // no border style set at all so default to none
       borderOffset = 0;
   }

  if (style['padding'] != null) {
    var p = style['padding'];
    box.top = org.apache.flex.utils.CSSUtils.getTopValue(style['padding_top'], p, object.height) + borderOffset;
    box.left = org.apache.flex.utils.CSSUtils.getLeftValue(style['padding_left'], p, object.width) + borderOffset;
    box.right = org.apache.flex.utils.CSSUtils.getRightValue(style['padding_right'], p, object.width) + borderOffset;
    box.bottom = org.apache.flex.utils.CSSUtils.getBottomValue(style['padding_bottom'], p, object.height) +
        borderOffset;
  }
  if (style['margin'] != null) {
    var m = style['margin'];
    box.marginTop = org.apache.flex.utils.CSSUtils.getTopValue(style['margin_top'], m, object.height);
    box.marginLeft = org.apache.flex.utils.CSSUtils.getLeftValue(style['margin_left'], m, object.width);
    box.marginBottom = org.apache.flex.utils.CSSUtils.getBottomValue(style['margin_bottom'], m, object.height);
    box.marginRight = org.apache.flex.utils.CSSUtils.getRightValue(style['margin_right'], m, object.width);
  }
  return box;
};
