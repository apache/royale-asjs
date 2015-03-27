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
 * org_apache_flex_core_graphics_LinearGradient
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_graphics_LinearGradient');
goog.require('org_apache_flex_core_graphics_GradientBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_graphics_GradientBase}
 * @implements {org_apache_flex_core_graphics_IFill}
 */
org_apache_flex_core_graphics_LinearGradient = function() {
  org_apache_flex_core_graphics_LinearGradient.base(this, 'constructor');
};
goog.inherits(org_apache_flex_core_graphics_LinearGradient, org_apache_flex_core_graphics_GradientBase);


/**
 * @type {number}
 */
org_apache_flex_core_graphics_LinearGradient.prototype._scaleX = 1.0;


Object.defineProperties(org_apache_flex_core_graphics_LinearGradient.prototype, {
    'scaleX': {
        /** @this {org_apache_flex_core_graphics_LinearGradient} */
        get: function() {
            return this._scaleX;
        },
        /** @this {org_apache_flex_core_graphics_LinearGradient} */
        set: function(value) {
            this._scaleX = value;
        }
    }
});


/**
 * addFillAttrib()
 *
 * @expose
 * @param {org_apache_flex_core_graphics_GraphicShape} value The GraphicShape object on which the fill must be added.
 * @return {string}
 */
org_apache_flex_core_graphics_LinearGradient.prototype.addFillAttrib = function(value) {
  //Create and add a linear gradient def
  var svgNS = value.element.namespaceURI;
  var grad = document.createElementNS(svgNS, 'linearGradient');
  var gradientId = this.newId;
  grad.setAttribute('id', gradientId);

  //Set x1, y1, x2, y2 of gradient
  grad.setAttribute('x1', '0%');
  grad.setAttribute('y1', '0%');
  grad.setAttribute('x2', '100%');
  grad.setAttribute('y2', '0%');

  //Apply rotation to the gradient if rotation is a number
  if (this.rotation)
  {
    grad.setAttribute('gradientTransform', 'rotate(' + this.rotation + ' 0.5 0.5)');
  }

  //Process gradient entries and create a stop for each entry
  var entries = this.entries;
  for (var i = 0; i < entries.length; i++)
  {
    var gradientEntry = entries[i];
    var stop = document.createElementNS(svgNS, 'stop');
    //Set Offset
    stop.setAttribute('offset', String(gradientEntry.ratio * 100) + '%');
    //Set Color
    var color = Number(gradientEntry.color).toString(16);
    if (color.length == 1) color = '00' + color;
    if (color.length == 2) color = '00' + color;
    if (color.length == 4) color = '00' + color;
    stop.setAttribute('stop-color', '#' + String(color));
    //Set Alpha
    stop.setAttribute('stop-opacity', String(gradientEntry.alpha));

    grad.appendChild(stop);
  }

  //Add defs element if not available already
  //Add newly created gradient to defs element
  var defs = value.element.querySelector('defs') ||
      value.element.insertBefore(document.createElementNS(svgNS, 'defs'), value.element.firstChild);
  defs.appendChild(grad);

  //Return the fill attribute
  return 'fill:url(#' + gradientId + ')';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_LinearGradient.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'LinearGradient', qName: 'org_apache_flex_core_graphics_LinearGradient'}],
    interfaces: [org_apache_flex_core_graphics_IFill]
  };
