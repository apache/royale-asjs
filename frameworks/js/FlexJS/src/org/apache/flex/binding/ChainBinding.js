/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_binding_ChainBinding');
goog.provide('org_apache_flex_binding_ChainWatcher');



/**
 * @constructor
 */
org_apache_flex_binding_ChainBinding = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_binding_ChainBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChainBinding',
                qName: 'org_apache_flex_binding_ChainBinding'}] };


/**
 * @protected
 * @type {Object}
 */
org_apache_flex_binding_ChainBinding.prototype.document = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_binding_ChainBinding.prototype.destination = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_binding_ChainBinding.prototype.value = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_binding_ChainBinding.prototype.source = null;


/**
 * @expose
 * @param {Object} value The strand (owner) of the bead.
 */
org_apache_flex_binding_ChainBinding.prototype.set_strand = function(value) {
  this.applyBinding();
};


/**
 */
org_apache_flex_binding_ChainBinding.prototype.applyBinding = function() {
  var chainSet = this.evaluateSourceChain();
  if (chainSet)
    this.applyValue();
};


/**
 * @return {boolean} True if chain complete.
 */
org_apache_flex_binding_ChainBinding.prototype.evaluateSourceChain = function() {
  var propName;
  var n = this.source.length;
  var obj = this.document;
  for (var i = 0; i < n - 1; i++) {
    propName = this.source[i];
    var propObj;
    propObj = obj[propName];
    var watcher = new org_apache_flex_binding_ChainWatcher(propName, this.applyBinding);
    obj.addEventListener('valueChange', watcher.handler);
    if (propObj == null)
      return false;
    obj = propObj;
  }
  propName = this.source[n - 1];
  var self = this;
  function valueChangeHandler(event) {
    if (event.propertyName != propName)
      return;
    self.value = event.newValue;
    self.applyValue();
  }
  obj.addEventListener('valueChange', valueChangeHandler);

  // we have a complete chain, get the value
  this.value = obj[propName];
  return true;
};


/**
 */
org_apache_flex_binding_ChainBinding.prototype.applyValue = function() {
  var destinationName, n, obj, self;
  function handler(event) {
    if (event.propertyName != propName)
      return;
    if (event.oldValue != null)
      event.oldValue.removeEventListener('valueChange', handler);
    self.applyValue();
  }
  if (typeof(this.destination) === 'string') {
    destinationName = this.destination;
    this.document[destinationName] = this.value;
    return;
  }

  n = this.destination.length;
  obj = this.document;
  self = this;
  for (var i = 0; i < n - 1; i++) {
    var propName = this.destination[i];
    var propObj;
    propObj = obj[propName];
    if (propObj == null) {
      obj.addEventListener('valueChange', handler);
      return;
    }
    obj = propObj;
  }
  obj[this.destination[n - 1]] = this.value;
};


/**
 * @expose
 * @param {Object} document The MXML object.
 */
org_apache_flex_binding_ChainBinding.prototype.setDocument = function(document) {
  this.document = document;
};



/**
 * @constructor
 * @param {string} propName The name of the property to watch.
 * @param {function()} cb The callback function.
 */
org_apache_flex_binding_ChainWatcher = function(propName, cb) {
  this.propertyName = propName;
  this.callback = cb;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_binding_ChainWatcher.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChainWatcher',
                qName: 'org_apache_flex_binding_ChainWatcher'}] };


/**
 * @protected
 * @type {string}
 */
org_apache_flex_binding_ChainWatcher.prototype.propertyName = '';


/**
 * @protected
 * @type {?function()}
 */
org_apache_flex_binding_ChainWatcher.prototype.callback = null;


/**
 * @expose
 * @param {Object} event The event object.
 */
org_apache_flex_binding_ChainWatcher.prototype.handler = function(event) {
  if (event.propertyName != this.propertyName)
    return;
  if (event.oldValue != null)
    event.oldValue.removeEventListener('valueChange', this.handler);
  this.callback();
};
