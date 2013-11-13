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



/**
 * @constructor
 */
org.apache.flex.core.SimpleCSSValuesImpl = function() {
};


/**
 * @param {Object} thisObject The object to fetch a value for.
 * @param {string} valueName The name of the value to fetch.
 * @param {string} state The psuedo-state if any for.
 * @param {Object} attrs The object with name value pairs that
 *                       might make a difference.
 * @return {Object} The value.
 */
org.apache.flex.core.SimpleCSSValuesImpl.prototype.getValue =
    function(thisObject, valueName, state, attrs) {
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
  var className;
  var selectorName;

  if (thisObject.hasOwnProperty('className'))
  {
    className = thisObject.className;
    if (state)
    {
      selectorName = className + ':' + state;
      o = values['.' + selectorName];
      if (o)
      {
        value = o[valueName];
        if (value !== undefined)
          return value;
      }
    }

    o = values['.' + className];
    if (o)
    {
      value = o[valueName];
      if (value !== undefined)
        return value;
    }
  }

  className = this.getQualifiedClassName(thisObject);
  while (className != 'Object')
  {
    if (state)
    {
      selectorName = className + ':' + state;
      o = values[selectorName];
      if (o)
      {
        value = o[valueName];
        if (value !== undefined)
          return value;
      }
    }

    o = values[className];
    if (o)
    {
      value = o[valueName];
      if (value !== undefined)
        return value;
    }
    thisObject = thisObject.__proto__;
    if (thisObject.__proto__ == null)
      break;
    className = this.getQualifiedClassName(thisObject);
  }
  o = values['global'];
  if (o != undefined)
  {
    value = o[valueName];
    if (value !== undefined)
      return value;
  }
  o = values['*'];
  return o[valueName];
};


/**
 * @param {Object} thisObject The object to get a name for.
 * @return {?string} The CSS selector name or null.
 */
org.apache.flex.core.SimpleCSSValuesImpl.prototype.getQualifiedClassName =
    function(thisObject) {
  // relies on the values parser to populate the package tree
  var proto = thisObject.__proto__;
  if (proto.hasOwnProperty('__css__package_parent'))
  {
    var s = proto.__css__name;
    while (true)
    {
      proto = proto.__css__package_parent;
      if (proto == window || proto == undefined)
        return s;
      s = proto.__css__name + '.' + s;
    }
  }
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
        if (selName.indexOf('.') != 0 &&
            selName != '*' && selName != 'global')
        {
          // should be a type selector
          var parts = selName.split('.');
          var numParts = parts.length;
          var part = window;
          for (var k = 0; k < numParts; k++)
          {
            var partName = parts[k];
            var subpart = part[partName];
            if (subpart == undefined)
              break;
            // assume last part is ctor func
            if (k == numParts - 1)
              subpart = subpart.prototype;
            subpart.__css__package_parent = part;
            subpart.__css__name = partName;
            part = subpart;
          }
        }
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
