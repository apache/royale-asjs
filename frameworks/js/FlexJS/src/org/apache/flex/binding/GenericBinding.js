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

goog.provide('org_apache_flex_binding_GenericBinding');

goog.require('org_apache_flex_binding_BindingBase');
goog.require('org_apache_flex_events_ValueChangeEvent');



/**
 * @constructor
 * @extends {org_apache_flex_binding_BindingBase}
 */
org_apache_flex_binding_GenericBinding = function() {
  org_apache_flex_binding_GenericBinding.base(this, 'constructor');
};
goog.inherits(org_apache_flex_binding_GenericBinding,
    org_apache_flex_binding_BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_binding_GenericBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'GenericBinding',
                qName: 'org_apache_flex_binding_GenericBinding'}] };


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_binding_GenericBinding.prototype.destinationData = null;


/**
 * @expose
 * @type {?function(?): ?}
 */
org_apache_flex_binding_GenericBinding.prototype.destinationFunction = null;


/**
 * @expose
 * @param {Object} value The strand (owner) of the bead.
 */
org_apache_flex_binding_GenericBinding.prototype.set_strand =
    function(value) {
  this.destination = value;

  try {
    var val = this.getValueFromSource();
    this.applyValue(val);
  } catch (e) {
  }
};


/**
 * @expose
 * @return {Object} The value from the source as specified.
 */
org_apache_flex_binding_GenericBinding.prototype.getValueFromSource =
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
 * @expose
 * @param {Object} value The value from the source as specified.
 */
org_apache_flex_binding_GenericBinding.prototype.applyValue =
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
           org_apache_flex_events_ValueChangeEvent.VALUE_CHANGE,
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
 * @expose
 * @param {Object} value The value from the source as specified.
 */
org_apache_flex_binding_GenericBinding.prototype.valueChanged =
    function(value) {

  try {
    var val = this.getValueFromSource();
    this.applyValue(val);
  } catch (e) {
  }
};


/**
 * @expose
 * @param {Object} event The change event.
 */
org_apache_flex_binding_GenericBinding.prototype.destinationChangeHandler =
    function(event) {
  if (event.propertyName == this.destinationData[0])
    this.valueChanged(null);
};

