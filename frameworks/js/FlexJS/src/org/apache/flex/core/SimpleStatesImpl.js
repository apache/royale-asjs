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

goog.provide('org_apache_flex_core_SimpleStatesImpl');

goog.require('mx_states_AddItems');
goog.require('mx_states_SetEventHandler');
goog.require('mx_states_SetProperty');
goog.require('mx_states_State');
goog.require('org_apache_flex_core_IBead');
goog.require('org_apache_flex_core_IStatesImpl');
goog.require('org_apache_flex_core_IStrand');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @implements {org_apache_flex_core_IBead}
 * @implements {org_apache_flex_core_IStatesImpl}
 */
org_apache_flex_core_SimpleStatesImpl = function() {
  org_apache_flex_core_SimpleStatesImpl.base(this, 'constructor');

  /**
   * @private
   * @type {org_apache_flex_core_IStrand}
   */
  this.strand_ = null;
};
goog.inherits(org_apache_flex_core_SimpleStatesImpl,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_SimpleStatesImpl.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleStatesImpl',
                qName: 'org_apache_flex_core_SimpleStatesImpl' }],
      interfaces: [org_apache_flex_core_IBead,
                   org_apache_flex_core_IStatesImpl] };


/**
 * @expose
 * @param {org_apache_flex_core_IStrand} value The new host.
 */
org_apache_flex_core_SimpleStatesImpl.prototype.set_strand =
    function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    if (this.strand_.addEventListener) {
      this.strand_.addEventListener('currentStateChange',
          goog.bind(this.stateChangeHandler_, this));
      this.strand_.addEventListener('initComplete',
          goog.bind(this.initialStateHandler_, this));
    }
  }
};


/**
 * @private
 * @param {Object} event The event.
 */
org_apache_flex_core_SimpleStatesImpl.prototype.initialStateHandler_ =
    function(event) {
    /**
     *  @type {Object}
    **/
    var host = this.strand_;
    this.dispatchEvent(new org_apache_flex_events_ValueChangeEvent('currentStateChange',
        false, false, null,
        host.get_currentState()));
  };


/**
 * @private
 * @param {Object} event The event.
 */
org_apache_flex_core_SimpleStatesImpl.prototype.stateChangeHandler_ =
    function(event) {
  var arr, doc, p, s;

  doc = event.target;
  arr = doc.get_states();
  for (p in arr) {
    s = arr[p];
    if (s.name === event.oldValue) {
      this.revert_(s);
      break;
    }
  }

  for (p in arr) {
    s = arr[p];
    if (s.name === event.newValue) {
      this.apply_(s);
      break;
    }
  }
};


/**
 * @private
 * @param {mx_states_State} s The State to revert.
 */
org_apache_flex_core_SimpleStatesImpl.prototype.revert_ = function(s) {
  var arr, item, o, p, q, target;
  /**
   * @type {org_apache_flex_core_UIBase}
   */
  var parent;
  arr = s.overrides;
  for (p in arr) {
    o = arr[p];
    if (org_apache_flex_utils_Language.is(o, mx_states_AddItems)) {
      for (q in o.items) {
        item = o.items[q];

        parent = o.document;
        if (o.destination) {
          if (typeof(o.document['get_' + o.destination]) === 'function') {
            parent = o.document['get_' + o.destination]();
          } else {
            parent = o.document[o.destination];
          }
        }

        parent.removeElement(item);
        parent.dispatchEvent(
            new org_apache_flex_events_Event('childrenAdded'));
      }
    } else if (org_apache_flex_utils_Language.is(o, mx_states_SetProperty)) {
      if (typeof(o.document['get_' + o.target]) === 'function') {
        target = o.document['get_' + o.target]();
      } else {
        target = o.document[o.target];
      }

      if (typeof(target['set_' + o.name]) === 'function') {
        target['set_' + o.name](o.previousValue);
      } else {
        target[o.name] = o.previousValue;
      }
    } else if (org_apache_flex_utils_Language.is(o, mx_states_SetEventHandler)) {
      if (typeof(o.document['get_' + o.target]) === 'function') {
        target = o.document['get_' + o.target]();
      } else {
        target = o.document[o.target];
      }
      target.removeEventListener(o.name, o.handlerFunction);
    }
  }
};


/**
 * @private
 * @param {mx_states_State} s The State to apply.
 */
org_apache_flex_core_SimpleStatesImpl.prototype.apply_ = function(s) {
  var arr, child, index, item, o, p, q, target;
  /**
   * type {org_apache_flex_core_UIBase}
   */
  var parent;
  arr = s.overrides;
  for (p in arr) {
    o = arr[p];
    if (org_apache_flex_utils_Language.is(o, mx_states_AddItems)) {
      if (!o.items) {
        o.items = o.itemsDescriptor.items;
        if (o.items == null) {
          o.items =
              org_apache_flex_utils_MXMLDataInterpreter.generateMXMLArray(o.document,
                                    null, o.itemsDescriptor.descriptor);
          o.itemsDescriptor.items = o.items;
        }
      }

      for (q in o.items) {
        item = o.items[q];

        parent = o.document;
        if (o.destination) {
          if (typeof(o.document['get_' + o.destination]) === 'function') {
            parent = o.document['get_' + o.destination]();
          } else {
            parent = o.document[o.destination];
          }
        }

        if (o.relativeTo) {
          if (typeof(o.document['get_' + o.relativeTo]) === 'function') {
            child = o.document['get_' + o.relativeTo]();
          } else {
            child = o.document[o.relativeTo];
          }

          index = parent.getElementIndex(child);
          if (o.position === 'after') {
            index++;
          }

          parent.addElementAt(item, index);
        } else {
          parent.addElement(item);
        }

        parent.dispatchEvent(
            new org_apache_flex_events_Event('childrenAdded'));
      }
    }
    else if (org_apache_flex_utils_Language.is(o, mx_states_SetProperty))
    {
      if (typeof(o.document['get_' + o.target]) === 'function') {
        target = o.document['get_' + o.target]();
      } else {
        target = o.document[o.target];
      }

      if (typeof(target['get_' + o.name]) === 'function') {
        o.previousValue = target['get_' + o.name]();
      } else {
        o.previousValue = target[o.name];
      }

      if (typeof(target['set_' + o.name]) === 'function') {
        target['set_' + o.name](o.value);
      } else {
        target[o.name] = o.value;
      }
    } else if (org_apache_flex_utils_Language.is(o, mx_states_SetEventHandler)) {
      if (typeof(o.document['get_' + o.target]) === 'function') {
        target = o.document['get_' + o.target]();
      } else {
        target = o.document[o.target];
      }
      target.addEventListener(o.name, o.handlerFunction);
    }
  }
};
