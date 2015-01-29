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

goog.provide('org_apache_flex_events_MouseEvent');

goog.require('goog.events.BrowserEvent');



/**
 * @constructor
 * @extends {goog.events.BrowserEvent}
 *
 * This is a shim class.  As long as you don't test
 * with "is" or "as", your code should work even
 * if the runtime is actually sending a native
 * browser MouseEvent
 */
org_apache_flex_events_MouseEvent = function() {
  org_apache_flex_events_MouseEvent.base(this, 'constructor');
};
goog.inherits(org_apache_flex_events_MouseEvent,
    goog.events.BrowserEvent);


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.ROLL_OVER = 'rollover';


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.ROLL_OUT = 'rollout';


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.MOUSE_OVER = 'mouseover';


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.MOUSE_OUT = 'mouseout';


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.MOUSE_UP = 'mouseup';


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.MOUSE_DOWN = 'mousedown';


/**
 * @type {string}
 */
org_apache_flex_events_MouseEvent.MOUSE_MOVE = 'mousemove';


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_events_MouseEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'MouseEvent',
                qName: 'org_apache_flex_events_MouseEvent' }] };


/**
 * @return {boolean}
 */
org_apache_flex_events_MouseEvent.installRollOverMixin = function() {
  window.addEventListener(org_apache_flex_events_MouseEvent.MOUSE_OVER,
    org_apache_flex_events_MouseEvent.mouseOverHandler);
  return true;
};


/**
 * @param {Event} e The event.
 * RollOver/RollOut is entirely implemented in mouseOver because
 * when a parent and child share an edge, you only get a mouseout
 * for the child and not the parent and you need to send rollout
 * to both.  A similar issue exists for rollover.
 */
org_apache_flex_events_MouseEvent.mouseOverHandler = function(e) {
  var j, m, outs, me, parent;
  var target = e.target.flexjs_wrapper;
  if (target === undefined)
    return; // probably over the html tag
  var targets = org_apache_flex_events_MouseEvent.targets;
  var index = targets.indexOf(target);
  if (index != -1) {
    // get all children
    outs = targets.slice(index + 1);
    m = outs.length;
    for (j = 0; j < m; j++) {
      me = org_apache_flex_events_MouseEvent.makeMouseEvent(
               org_apache_flex_events_MouseEvent.ROLL_OUT, e);
      outs[j].element.dispatchEvent(me);
    }
    org_apache_flex_events_MouseEvent.targets = targets.slice(0, index + 1);
  }
  else {
    var newTargets = [target];
    if (target.get_parent === undefined)
      parent = null;
    else
      parent = target.parent;
    while (parent) {
      index = targets.indexOf(parent);
      if (index == -1) {
        newTargets.unshift(parent);
        if (parent.get_parent === undefined)
          break;
        parent = parent.parent;
      }
      else {
        outs = targets.slice(index + 1);
        m = outs.length;
        for (j = 0; j < m; j++) {
          me = org_apache_flex_events_MouseEvent.makeMouseEvent(
                   org_apache_flex_events_MouseEvent.ROLL_OUT, e);
          outs[j].element.dispatchEvent(me);
        }
        targets = targets.slice(0, index + 1);
        break;
      }
    }
    var n = newTargets.length;
    for (var i = 0; i < n; i++) {
      me = org_apache_flex_events_MouseEvent.makeMouseEvent(
                   org_apache_flex_events_MouseEvent.ROLL_OVER, e);
      newTargets[i].element.dispatchEvent(me);
    }
    org_apache_flex_events_MouseEvent.targets = targets.concat(newTargets);
  }
};


/**
 * @type {boolean}
 */
org_apache_flex_events_MouseEvent.rollOverMixin =
    org_apache_flex_events_MouseEvent.installRollOverMixin();


/**
 * @type {Object}
 */
org_apache_flex_events_MouseEvent.targets = [];


/**
 * @param {string} type The event type.
 * @param {Event} e The mouse event.
 * @return {MouseEvent} The new event.
 */
org_apache_flex_events_MouseEvent.makeMouseEvent = function(type, e) {
  var out = new MouseEvent(type);
  out.initMouseEvent(type, false, false);
  out.screenX = e.screenX;
  out.screenY = e.screenY;
  out.ctrlKey = e.ctrlKey;
  out.shiftKey = e.shiftKey;
  out.altKey = e.altKey;
  return out;
};
