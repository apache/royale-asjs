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

goog.provide('org_apache_flex_effects_PlatformWiper');

goog.require('org_apache_flex_geom_Rectangle');



/**
 * @constructor
 */
org_apache_flex_effects_PlatformWiper = function() {

  /**
   * @private
   * @type {Object}
   */
  this.target_ = null;


  /**
   * @private
   * @type {Object}
   */
  this.overflow_ = null;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_effects_PlatformWiper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'PlatformWiper',
                qName: 'org_apache_flex_effects_PlatformWiper'}] };


Object.defineProperties(org_apache_flex_effects_PlatformWiper.prototype, {
    /** @export */
    target: {
        /** @this {org_apache_flex_effects_PlatformWiper} */
        set: function(target) {
            if (target == null) {
              if (this.overflow_ == null)
                delete this.target_.positioner.style.overflow;
              else
                this.target_.positioner.style.overflow = this.overflow_;
            }
            this.target_ = target;
            if (target != null) {
              this.overflow_ = this.target_.positioner.style.overflow;
            }
        }
    },
    /** @export */
    visibleRect: {
        /** @this {org_apache_flex_effects_PlatformWiper} */
        set: function(rect) {
            /*
            var styleString = 'rect(';
            styleString += rect.top.toString() + 'px,';
            styleString += rect.width.toString() + 'px,';
            styleString += rect.height.toString() + 'px,';
            styleString += rect.left.toString() + 'px)';
            this.target_.positioner.style.clip = styleString;
            */
            this.target_.positioner.style.height = rect.height.toString() + 'px';
            this.target_.positioner.style.overflow = 'hidden';
        }
    }
});
