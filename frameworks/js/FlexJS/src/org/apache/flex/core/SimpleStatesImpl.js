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

goog.provide('org.apache.flex.core.SimpleStatesImpl');

goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 */
org.apache.flex.core.SimpleStatesImpl = function() {
  goog.base(this);

  /**
   * @private
   * @type {Object}
   */
  this.strand_ = null;
};
goog.inherits(org.apache.flex.core.SimpleStatesImpl,
    org.apache.flex.events.EventDispatcher);


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.core.SimpleStatesImpl.prototype.set_strand =
    function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('currentStateChanged',
        goog.bind(this.stateChangeHandler, this));
  }
};


/**
 * @protected
 * @param {Object} event The event.
 */
org.apache.flex.core.SimpleStatesImpl.prototype.stateChangeHandler =
    function(event) {
  var s, p;
  var doc = event.target;
  var arr = doc.get_states();
  for (p in arr)
  {
    s = arr[p];
    if (s.name == event.oldValue)
    {
      this.revert(s);
      break;
    }
  }
  for (p in arr)
  {
    s = arr[p];
    if (s.name == event.newValue)
    {
      this.applyState(s);
      break;
    }
  }
};


/**
 * @protected
 * @param {Object} s The State to revert.
 */
org.apache.flex.core.SimpleStatesImpl.prototype.revert = function(s) {
  var p, o;
  var arr = s.overrides;
  for (p in arr)
  {
    o = arr[p];
    if (o.type == 'AddItems')
    {
      for (var q in o.items)
      {
        var item = o.items[q];
        var parent;
        if (typeof(o.document['get_' + o.destination]) == 'function')
          parent = o.document['get_' + o.destination]();
        else
          parent = o.document[o.destination];
        parent.removeElement(item);
        parent.dispatchEvent(
            new org.apache.flex.events.Event('childrenAdded'));
      }
    }
    else if (o.type == 'SetProperty')
    {
      var target;
      if (typeof(o.document['get_' + o.target]) == 'function')
        target = o.document['get_' + o.target]();
      else
        target = o.document[o.target];
      if (typeof(target['set_' + o.name]) == 'function')
        target['set_' + o.name](o.previousValue);
      else
        target[o.name] = o.previousValue;
    }
  }
};


/**
 * @protected
 * @param {Object} s The State to apply.
 */
org.apache.flex.core.SimpleStatesImpl.prototype.applyState = function(s) {
  var o, p;
  var arr = s.overrides;
  for (p in arr)
  {
    o = arr[p];
    if (o.type == 'AddItems')
    {
      if (o.items == null)
      {
        //TODO (aharui).  This array should be deferred
        //var di = org.apache.flex.utils.MXMLDataInterpreter;
        //o.items = di.generateMXMLArray(o.document,
        //                                null, o.itemsDescriptor, true);
        o.items = o.itemsDescriptor;
      }
      for (var q in o.items)
      {
        var item = o.items[q];
        var parent;
        if (typeof(o.document['get_' + o.destination]) == 'function')
          parent = o.document['get_' + o.destination]();
        else
          parent = o.document[o.destination];
        if (o.relativeTo != null)
        {
          var child;
          if (typeof(o.document['get_' + o.relativeTo]) == 'function')
            child = o.document['get_' + o.relativeTo]();
          else
            child = o.document[o.relativeTo];
          var index = parent.getElementIndex(child);
          if (o.position == 'after')
            index++;
          parent.addElementAt(item, index);
        }
        else
        {
          parent.addElement(item);
        }
        parent.dispatchEvent(
            new org.apache.flex.events.Event('childrenAdded'));
      }
    }
    else if (o.type == 'SetProperty')
    {
      var target;
      if (typeof(o.document['get_' + o.target]) == 'function')
        target = o.document['get_' + o.target]();
      else
        target = o.document[o.target];
      if (typeof(target['get_' + o.name]) == 'function')
        o.previousValue = target['get_' + o.name]();
      else
        o.previousValue = target[o.name];
      if (typeof(target['set_' + o.name]) == 'function')
        target['set_' + o.name](o.value);
      else
        target[o.name] = o.value;
    }
  }
};
