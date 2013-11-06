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

goog.provide('org.apache.flex.core.ViewBaseDataBinding');

goog.require('org.apache.flex.binding.ConstantBinding');
goog.require('org.apache.flex.binding.GenericBinding');
goog.require('org.apache.flex.binding.PropertyWatcher');
goog.require('org.apache.flex.binding.SimpleBinding');
goog.require('org.apache.flex.events.Event');


/**
 * @constructor
 */
org.apache.flex.core.ViewBaseDataBinding = function() {

  /**
   * @private
   * @type {Object}
   */
  this.strand_ = null;

  /**
   * @protected
   * @type {Object}
   */
  this.deferredBindings = {};

};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBaseDataBinding}
 * @param {Object} value The new host.
 */
org.apache.flex.core.ViewBaseDataBinding.prototype.set_strand =
    function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('initComplete',
        goog.bind(this.initCompleteHandler, this));
  }
};


/**
 * @protected
 * @this {org.apache.flex.core.ViewBaseDataBinding}
 * @param {Object} event The event.
 */
org.apache.flex.core.ViewBaseDataBinding.prototype.initCompleteHandler =
    function(event) {

    var prop;
    var fieldWatcher;
    var sb;
    var bindingData = this.strand_['_bindings'];
    var n = bindingData[0];
    var bindings = [];
    var i;
    var index = 1;
    for (i = 0; i < n; i++)
    {
        var binding = {};
        binding.source = bindingData[index++];
        binding.destFunc = bindingData[index++];
        binding.destination = bindingData[index++];
        bindings.push(binding);
    }
    var watchers = this.decodeWatcher(bindingData.slice(index));
    for (i = 0; i < n; i++)
    {
        binding = bindings[i];
        // try to determine if it is an array
        if (typeof(binding.source) == 'object' &&
            typeof(binding.source.slice) == 'function')
        {
            if (binding.source[0] == 'applicationModel')
            {
                if (binding.source.length == 2 &&
                    binding.destination.length == 2)
                {
                    var destination;
                    // can be simplebinding or constantbinding
                    var modelWatcher =
                            watchers.watcherMap['applicationModel'];
                    var childMap = modelWatcher.children.watcherMap;
                    fieldWatcher = childMap[binding.source[1]];
                    if (typeof(fieldWatcher.eventNames) == 'string')
                    {
                        sb = new org.apache.flex.binding.SimpleBinding();
                        sb.destinationPropertyName =
                                    binding.destination[1];
                        sb.eventName = fieldWatcher.eventNames;
                        sb.sourceID = binding.source[0];
                        sb.sourcePropertyName = binding.source[1];
                        sb.setDocument(this.strand_);
                        prop = binding.destination[0];
                        
                        if (typeof(this.strand_['get_' +
                                    prop]) == 'function')
                                destination = this.strand_[
                                        'get_' + prop]();
                        else
                            destination = this.strand_[prop];

                        if (destination)
                              destination.addBead(sb);
                        else
                        {
                            this.deferredBindings[prop] =
                                    sb;
                            this.strand_.addEventListener('valueChange',
                                    this.deferredBindingsHandler);
                        }
                    }
                    else if (fieldWatcher.eventNames == null)
                    {
                        var cb;
                        cb = org.apache.flex.binding.ConstantBinding;
                        cb = new cb();
                        cb.destinationPropertyName =
                                binding.destination[1];
                        cb.sourceID = binding.source[0];
                        cb.sourcePropertyName = binding.source[1];
                        cb.setDocument(this.strand_);
                        prop = binding.destination[0];
                        if (typeof(this.strand_['get_' +
                                    prop]) == 'function')
                                destination = this.strand_[
                                        'get_' + prop]();
                        else
                            destination = this.strand_[prop];

                        if (destination)
                                destination.addBead(cb);
                        else
                        {
                            this.deferredBindings[prop] =
                                cb;
                            this.strand_.addEventListener('valueChange',
                                this.deferredBindingsHandler);
                        }
                    }
                }
            }
        }
        else if (typeof(binding.source) == 'string')
        {
            fieldWatcher = watchers.watcherMap[binding.source];
            if (typeof(fieldWatcher.eventNames) == 'string')
            {
                sb = new org.apache.flex.binding.SimpleBinding();
                sb.destinationPropertyName = binding.destination[1];
                sb.eventName = fieldWatcher.eventNames;
                sb.sourcePropertyName = binding.source;
                sb.setDocument(this.strand_);
                prop = binding.destination[0];
                if (typeof(this.strand_['get_' +
                                prop]) == 'function')
                    destination = this.strand_[
                                'get_' + prop]();
                else
                    destination = this.strand_[prop];

                if (destination)
                    destination.addBead(sb);
                else
                {
                    this.deferredBindings[prop] = sb;
                    this.strand_.addEventListener('valueChange',
                                this.deferredBindingsHandler);
                }
            }
        }
        else
        {
            this.makeGenericBinding(binding, i, watchers);
        }
    }
};


/**
 * @protected
 * @this {org.apache.flex.core.ViewBaseDataBinding}
 * @param {Object} binding The binding object.
 * @param {number} index The offset in the Binding database.
 * @param {Object} watchers The database of Watchers.
 */
org.apache.flex.core.ViewBaseDataBinding.prototype.makeGenericBinding =
        function(binding, index, watchers) {
    var gb = new org.apache.flex.binding.GenericBinding();
    gb.setDocument(this.strand_);
    gb.destinationData = binding.destination;
    gb.destinationFunction = binding.destFunc;
    gb.source = binding.source;
    this.setupWatchers(gb, index, watchers.watchers, null);
};

/**
 * @protected
 * @this {org.apache.flex.core.ViewBaseDataBinding}
 * @param {Object} gb The generic binding object.
 * @param {number} index The offset in the Binding database.
 * @param {Object} watchers The array of Watchers.
 * @param {Object} parentWatcher The parent Watcher or null if top.
 */
org.apache.flex.core.ViewBaseDataBinding.prototype.setupWatchers =
        function(gb, index, watchers, parentWatcher) {
    var i, n;
    n = watchers.length;
    for (i = 0; i < n; i++)
    {
        var watcher = watchers[i];
        if (watcher.bindings.indexOf(index) != -1)
        {
            var type = watcher.type;
            switch (type)
            {
                case 'property':
                {
                    var pw = new org.apache.flex.binding.PropertyWatcher(
                                this,
                                watcher.propertyName,
                                watcher.eventNames,
                                watcher.getterFunction);
                    watcher.watcher = pw;
                    if (parentWatcher)
                        pw.parentChanged(parentWatcher.value);
                    else
                        pw.parentChanged(this.strand_);
                    if (parentWatcher)
                        parentWatcher.addChild(pw);
                    if (watcher.children == null)
                        pw.addBinding(gb);
                    break;
                }
            }
            if (watcher.children)
            {
                this.setupWatchers(gb, index, watcher.children,
                    watcher.watcher);
            }
        }
    }
};

/**
 * @protected
 * @this {org.apache.flex.core.ViewBaseDataBinding}
 * @param {Object} bindingData The watcher data to decode.
 * @return {Object} The watcher tree structure.
 */
org.apache.flex.core.ViewBaseDataBinding.prototype.decodeWatcher =
    function(bindingData) {
    var watcherMap = {};
    var watchers = [];
    var n = bindingData.length - 1; // there is an extra null because
                                    // it is easier for the compiler
    var index = 0;
    var watcherData;
    while (index < n)
    {
        var watcherIndex = bindingData[index++];
        var type = bindingData[index++];
        switch (type)
        {
            case 0:
            {
                watcherData = { type: 'function' };
                watcherData.functionName = bindingData[index++];
                watcherData.paramFunction = bindingData[index++];
                watcherData.eventNames = bindingData[index++];
                watcherData.bindings = bindingData[index++];
                break;
            }
            case 1:
            {
                watcherData = { type: 'static' };
                watcherData.propertyName = bindingData[index++];
                watcherData.eventNames = bindingData[index++];
                watcherData.bindings = bindingData[index++];
                watcherData.getterFunction = bindingData[index++];
                watcherData.parentObj = bindingData[index++];
                watcherMap[watcherData.propertyName] = watcherData;
                break;
            }
            case 2:
            {
                watcherData = { type: 'property' };
                watcherData.propertyName = bindingData[index++];
                watcherData.eventNames = bindingData[index++];
                watcherData.bindings = bindingData[index++];
                watcherData.getterFunction = bindingData[index++];
                watcherMap[watcherData.propertyName] = watcherData;
                break;
            }
            case 3:
            {
                watcherData = { type: 'xml' };
                watcherData.propertyName = bindingData[index++];
                watcherData.bindings = bindingData[index++];
                watcherMap[watcherData.propertyName] = watcherData;
                break;
            }
        }
        watcherData.children = bindingData[index++];
        if (watcherData.children != null)
        {
            watcherData.children = this.decodeWatcher(watcherData.children);
        }
        watcherData.index = watcherIndex;
        watchers.push(watcherData);
    }
    return { watchers: watchers, watcherMap: watcherMap };
};

/**
 * @protected
 * @this {org.apache.flex.core.ViewBaseDataBinding}
 * @param {Object} event The event.
 */
org.apache.flex.core.ViewBaseDataBinding.prototype.deferredBindingsHandler =
function(event) {
    var p;
    for (p in this.deferredBindings)
    {
        if (typeof(this.strand_['get_' + p]) == 'function')
        {
            var destination = this.strand_['get_' + p]();
            destination.addBead(this.deferredBindings[p]);
            delete deferredBindings[p];
        }
        else if (this.strand_[p] != null)
        {
            var destination = this.strand_[p];
            destination.addBead(this.deferredBindings[p]);
            delete deferredBindings[p];
        }
    }
};

