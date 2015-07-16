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

goog.provide('org.apache.flex.binding.GenericBinding');

goog.require('org.apache.flex.binding.BindingBase');
goog.require('org.apache.flex.events.ValueChangeEvent');



/**
 * @constructor
 * @extends {org.apache.flex.binding.BindingBase}
 */
org.apache.flex.binding.GenericBinding = function() {
  org.apache.flex.binding.GenericBinding.base(this, 'constructor');
};
goog.inherits(org.apache.flex.binding.GenericBinding,
    org.apache.flex.binding.BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.GenericBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'GenericBinding',
                qName: 'org.apache.flex.binding.GenericBinding'}] };


/**
 * @export
 * @type {Object}
 */
org.apache.flex.binding.GenericBinding.prototype.destinationData = null;


/**
 * @export
 * @type {?function(?): ?}
 */
org.apache.flex.binding.GenericBinding.prototype.destinationFunction = null;


Object.defineProperties(org.apache.flex.binding.GenericBinding.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.binding.GenericBinding} */
        set: function(value) {
            this.destination = value;

            try {
              var val = this.getValueFromSource();
              this.applyValue(val);
            } catch (e) {
            }
        }
    }
});


/**
 * @export
 * @return {Object} The value from the source as specified.
 */
org.apache.flex.binding.GenericBinding.prototype.getValueFromSource =
    function() {
  var obj;
  if (typeof(this.source) == 'object' &&
      typeof(this.source.slice) == 'function')
  {
    var arr = this.source;
    var n = arr.length;
    obj = this.document[arr[0]];
    if (obj == null)
      return null;
    for (var i = 1; i < n; i++)
    {
      obj = obj[arr[i]];
      if (obj == null)
        return null;
    }
    return obj;
  }
  else if (typeof(this.source) == 'function')
  {
    var fn = this.source;
    obj = fn.apply(this.document);
    return obj;
  }
  else if (typeof(this.source) == 'string')
  {
    obj = this.document[this.source];
    return obj;
  }
  return null;
};


/**
 * @export
 * @param {Object} value The value from the source as specified.
 */
org.apache.flex.binding.GenericBinding.prototype.applyValue =
    function(value) {
  if (this.destinationFunction != null)
  {
    this.destinationFunction.apply(this.document, [value]);
  }
  else if (typeof(this.destinationData) == 'object')
  {
    var arr = this.destinationData;
    var n = arr.length;
    var obj;
    var getter = arr[0];
    obj = this.document[arr[0]];
    if (obj == null) {
       this.document.addEventListener(
           org.apache.flex.events.ValueChangeEvent.VALUE_CHANGE,
           goog.bind(this.destinationChangeHandler, this));
       return;
    }
    for (var i = 1; i < n - 1; i++)
    {
      getter = arr[i];
       obj = obj[arr[i]];
      if (obj == null)
        return;
    }
    var setter = arr[n - 1];
      obj[arr[n - 1]] = value;
  }
};


/**
 * @export
 * @param {Object} value The value from the source as specified.
 */
org.apache.flex.binding.GenericBinding.prototype.valueChanged =
    function(value) {

  try {
    var val = this.getValueFromSource();
    this.applyValue(val);
  } catch (e) {
  }
};


/**
 * @export
 * @param {Object} event The change event.
 */
org.apache.flex.binding.GenericBinding.prototype.destinationChangeHandler =
    function(event) {
  if (event.propertyName == this.destinationData[0])
    this.valueChanged(null);
};

