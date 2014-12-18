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

goog.provide('org.apache.flex.effects.PlatformWiper');

goog.require('org.apache.flex.geom.Rectangle');



/**
 * @constructor
 */
org.apache.flex.effects.PlatformWiper = function() {

  /**
   * @private
   * @type {Object}
   */
  this.target_ = null;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.effects.PlatformWiper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'PlatformWiper',
                qName: 'org.apache.flex.effects.PlatformWiper'}] };


/**
 * @expose
 * Sets the target for the Wipe.
 * @param {Object} target The target for the Wipe effect.
 */
org.apache.flex.effects.PlatformWiper.prototype.set_target =
    function(target) {
  if (target == null)
      delete this.target_.positioner.style.clip;
  this.target_ = target;
};


/**
 * @expose
 * Clips the Object.
 * @param {org.apache.flex.geom.Rectangle} rect The visible area.
 */
org.apache.flex.effects.PlatformWiper.prototype.set_visibleRect =
    function(rect) {
  var styleString = 'rect(';
  styleString += rect.top.toString() + 'px,';
  styleString += rect.width.toString() + 'px,';
  styleString += rect.height.toString() + 'px,';
  styleString += rect.left.toString() + 'px,)';
  this.target_.positioner.style.clip = styleString;
};
