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

goog.provide('org.apache.flex.binding.ChainBinding');
goog.provide('org.apache.flex.binding.ChainWatcher');



/**
 * @constructor
 */
org.apache.flex.binding.ChainBinding = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.ChainBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChainBinding',
                qName: 'org.apache.flex.binding.ChainBinding'}] };


/**
 * @protected
 * @type {Object}
 */
org.apache.flex.binding.ChainBinding.prototype.document = null;


/**
 * @export
 * @type {Object}
 */
org.apache.flex.binding.ChainBinding.prototype.destination = null;


/**
 * @export
 * @type {Object}
 */
org.apache.flex.binding.ChainBinding.prototype.value = null;


/**
 * @export
 * @type {Object}
 */
org.apache.flex.binding.ChainBinding.prototype.source = null;


/**
 */
org.apache.flex.binding.ChainBinding.prototype.applyBinding = function() {
  var chainSet = this.evaluateSourceChain();
  if (chainSet)
    this.applyValue();
};


/**
 * @return {boolean} True if chain complete.
 */
org.apache.flex.binding.ChainBinding.prototype.evaluateSourceChain = function() {
  var propName;
  var n = this.source.length;
  var obj = this.document;
  for (var i = 0; i < n - 1; i++) {
    propName = this.source[i];
    var propObj;
    propObj = obj[propName];
    var watcher = new org.apache.flex.binding.ChainWatcher(propName, this.applyBinding);
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
org.apache.flex.binding.ChainBinding.prototype.applyValue = function() {
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
 * @export
 * @param {Object} document The MXML object.
 */
org.apache.flex.binding.ChainBinding.prototype.setDocument = function(document) {
  this.document = document;
};



/**
 * @constructor
 * @param {string} propName The name of the property to watch.
 * @param {function()} cb The callback function.
 */
org.apache.flex.binding.ChainWatcher = function(propName, cb) {
  this.propertyName = propName;
  this.callback = cb;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.ChainWatcher.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChainWatcher',
                qName: 'org.apache.flex.binding.ChainWatcher'}] };


/**
 * @protected
 * @type {string}
 */
org.apache.flex.binding.ChainWatcher.prototype.propertyName = '';


/**
 * @protected
 * @type {?function()}
 */
org.apache.flex.binding.ChainWatcher.prototype.callback = null;


/**
 * @export
 * @param {Object} event The event object.
 */
org.apache.flex.binding.ChainWatcher.prototype.handler = function(event) {
  if (event.propertyName != this.propertyName)
    return;
  if (event.oldValue != null)
    event.oldValue.removeEventListener('valueChange', this.handler);
  this.callback();
};


Object.defineProperties(org.apache.flex.binding.ChainBinding.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.binding.ChainBinding} */
        set: function(value) {
            this.applyBinding();
        }
    }
});
