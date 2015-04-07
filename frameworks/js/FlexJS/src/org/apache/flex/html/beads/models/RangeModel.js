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

goog.provide('org_apache_flex_html_beads_models_RangeModel');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_html_beads_models_RangeModel = function() {
  org_apache_flex_html_beads_models_RangeModel.base(this, 'constructor');

  this.minimum_ = 0;
  this.maximum_ = 100;
  this.value_ = 0;
  this.snapInterval_ = 1;
  this.stepSize_ = 1;
};
goog.inherits(org_apache_flex_html_beads_models_RangeModel,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_models_RangeModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'RangeModel',
                qName: 'org_apache_flex_html_beads_models_RangeModel'}],
      interfaces: [ org_apache_flex_core_IBeadModel] };


Object.defineProperties(org_apache_flex_html_beads_models_RangeModel.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    /** @expose */
    minimum: {
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        get: function() {
            return this.minimum_;
        },
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        set: function(value) {
            if (this.minimum_ != value) {
              this.minimum_ = value;
              this.dispatchEvent('minimumChange');
            }
        }
    },
    /** @expose */
    maximum: {
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        get: function() {
            return this.maximum_;
        },
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        set: function(value) {
            if (this.maximum_ != value) {
              this.maximum_ = value;
              this.dispatchEvent('maximumChange');
            }
        }
    },
    /** @expose */
    value: {
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        get: function() {
            return this.value_;
        },
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        set: function(newValue) {
            if (this.value_ != newValue) {

              // value must lie within the boundaries of minimum & maximum
              // and be on a step interval, so the value is adjusted to
              // what is coming in.
              newValue = Math.max(this.minimum_, newValue - this.stepSize_);
              newValue = Math.min(this.maximum_, newValue + this.stepSize_);
              this.value_ = this.snap(newValue);

              this.dispatchEvent('valueChange');
            }
        }
    },
    /** @expose */
    snapInterval: {
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        get: function() {
            return this.snapInterval_;
        },
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        set: function(value) {
            if (this.snapInterval_ != value) {
              this.snapInterval_ = value;
              this.dispatchEvent('snapIntervalChange');
            }
        }
    },
    /** @expose */
    stepSize: {
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        get: function() {
            return this.stepSize_;
        },
        /** @this {org_apache_flex_html_beads_models_RangeModel} */
        set: function(value) {
            if (this.stepSize_ != value) {
              this.stepSize_ = value;
              this.dispatchEvent('stepSizeChange');
            }
        }
    }
});


/**
 * @expose
 * @param {number} value The candidate number.
 * @return {number} Adjusted value.
 */
org_apache_flex_html_beads_models_RangeModel.prototype.
    snap = function(value) {
  var si = this.snapInterval_;
  var n = Math.round((value - this.minimum_) / si) *
                 si + this.minimum_;
  if (value > 0)
  {
    if (value - n < n + si - value)
      return n;
    return n + si;
  }
  if (value - n > n + si - value)
    return n + si;
  return n;
};

