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

goog.provide('org.apache.flex.core.SimpleCSSValuesImpl');

goog.require('org.apache.flex.core.IValuesImpl');



/**
 * @constructor
 * @implements {org.apache.flex.core.IValuesImpl};
 */
org.apache.flex.core.SimpleCSSValuesImpl = function() {
};


/**
 * @type {string}
 */
org.apache.flex.core.SimpleCSSValuesImpl.GLOBAL_SELECTOR = 'global';


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.SimpleCSSValuesImpl.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleCSSValuesImpl',
               qName: 'org.apache.flex.core.SimpleCSSValuesImpl'}],
    interfaces: [org.apache.flex.core.IValuesImpl]};


/**
 * @param {Object} thisObject The object to fetch a value for.
 * @param {string} valueName The name of the value to fetch.
 * @param {string=} opt_state The psuedo-state if any for.
 * @param {Object=} opt_attrs The object with name value pairs that
 *                       might make a difference.
 * @return {Object} The value.
 */
org.apache.flex.core.SimpleCSSValuesImpl.prototype.getValue =
    function(thisObject, valueName, opt_state, opt_attrs) {
  var c = valueName.indexOf('-');
  while (c != -1)
  {
    valueName = valueName.substr(0, c) +
        valueName.charAt(c + 1).toUpperCase() +
        valueName.substr(c + 2);
    c = valueName.indexOf('-');
  }

  var values = this.values;
  var value;
  var o;
  var cName;
  var selectorName;

  if ('className' in thisObject)
  {
    cName = thisObject.className;
    if (opt_state)
    {
      selectorName = cName + ':' + opt_state;
      o = values['.' + selectorName];
      if (o)
      {
        value = o[valueName];
        if (value !== undefined)
          return value;
      }
    }

    o = values['.' + cName];
    if (o)
    {
      value = o[valueName];
      if (value !== undefined)
        return value;
    }
  }

  cName = thisObject.FLEXJS_CLASS_INFO.names[0].qName;
  if (opt_state)
  {
    selectorName = cName + ':' + opt_state;
    o = values['.' + selectorName];
    if (o)
    {
      value = o[valueName];
      if (value !== undefined)
        return value;
    }
  }

  o = values['.' + cName];
  if (o)
  {
    value = o[valueName];
    if (value !== undefined)
      return value;
  }

  while (cName != 'Object')
  {
    if (opt_state)
    {
      selectorName = cName + ':' + opt_state;
      o = values[selectorName];
      if (o)
      {
        value = o[valueName];
        if (value !== undefined)
          return value;
      }
    }

    o = values[cName];
    if (o)
    {
      value = o[valueName];
      if (value !== undefined)
        return value;
    }
    thisObject = thisObject.constructor.superClass_;
    if (!thisObject || !thisObject.FLEXJS_CLASS_INFO)
      break;

    cName = thisObject.FLEXJS_CLASS_INFO.names[0].qName;
  }
  o = values[org.apache.flex.core.SimpleCSSValuesImpl.GLOBAL_SELECTOR];
  if (o !== undefined)
  {
    value = o[valueName];
    if (value !== undefined)
      return value;
  }
  o = values['*'];
  return o[valueName];
};


/**
 * @param {Object} thisObject The object to fetch a value for.
 * @param {string} valueName The name of the value to fetch.
 * @param {string=} opt_state The psuedo-state if any for.
 * @param {Object=} opt_attrs The object with name value pairs that
 *                       might make a difference.
 * @return {Object} The value.
 * @suppress {checkTypes}
 */
org.apache.flex.core.SimpleCSSValuesImpl.prototype.newInstance =
function(thisObject, valueName, opt_state, opt_attrs) {
  var f = this.getValue(thisObject, valueName, opt_state, opt_attrs);
  if (f)
    return new f();
  return null;
};


/**
 * @param {Object} mainclass The main class for the application.
 */
org.apache.flex.core.SimpleCSSValuesImpl.prototype.init = function(mainclass) {
  var cssData = mainclass.cssData;
  var values = this.values;
  if (values == null)
    values = {};

  if (cssData) {
    var n = cssData.length;
    var i = 0;
    while (i < n)
    {
      var numMQ = cssData[i++];
      if (numMQ > 0)
      {
        // skip MediaQuery tests for now
        i += numMQ;
      }
      var numSel = cssData[i++];
      var props = {};
      for (var j = 0; j < numSel; j++)
      {
        var selName = cssData[i++];
        if (values[selName])
          props = values[selName];
        values[selName] = props;
      }
      var numProps = cssData[i++];
      for (j = 0; j < numProps; j++)
      {
        var propName = cssData[i++];
        var propValue = cssData[i++];
        props[propName] = propValue;
      }
    }
  }

  this.values = values;
};
