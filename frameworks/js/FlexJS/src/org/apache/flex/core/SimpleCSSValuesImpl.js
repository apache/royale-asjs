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

goog.provide('org_apache_flex_core_SimpleCSSValuesImpl');

goog.require('org_apache_flex_core_IValuesImpl');



/**
 * @constructor
 * @implements {org_apache_flex_core_IValuesImpl};
 */
org_apache_flex_core_SimpleCSSValuesImpl = function() {
};


/**
 * @type {string}
 */
org_apache_flex_core_SimpleCSSValuesImpl.GLOBAL_SELECTOR = 'global';


/**
 * @type {string}
 */
org_apache_flex_core_SimpleCSSValuesImpl.UNIVERSAL_SELECTOR = '*';


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_SimpleCSSValuesImpl.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleCSSValuesImpl',
               qName: 'org_apache_flex_core_SimpleCSSValuesImpl'}],
    interfaces: [org_apache_flex_core_IValuesImpl]};


/**
 * @param {Object} thisObject The object to fetch a value for.
 * @param {string} valueName The name of the value to fetch.
 * @param {string=} opt_state The psuedo-state if any for.
 * @param {Object=} opt_attrs The object with name value pairs that
 *                       might make a difference.
 * @return {Object} The value.
 */
org_apache_flex_core_SimpleCSSValuesImpl.prototype.getValue =
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

  if (typeof(thisObject.get_style) === 'function')
  {
    var style = thisObject.style;
    if (style != null)
    {
      try {
         value = style[valueName];
      }
      catch (e) {
        value = undefined;
      }
      if (value !== undefined)
        return value;
    }
  }

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
  o = values[org_apache_flex_core_SimpleCSSValuesImpl.GLOBAL_SELECTOR];
  if (o)
    return o[valueName];
  o = values[org_apache_flex_core_SimpleCSSValuesImpl.UNIVERSAL_SELECTOR];
  if (o)
    return o[valueName];
  return undefined;
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
org_apache_flex_core_SimpleCSSValuesImpl.prototype.newInstance =
function(thisObject, valueName, opt_state, opt_attrs) {
  var f = this.getValue(thisObject, valueName, opt_state, opt_attrs);
  if (f)
    return new f();
  return null;
};


/**
 * @param {Object} mainclass The main class for the application.
 */
org_apache_flex_core_SimpleCSSValuesImpl.prototype.init = function(mainclass) {
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


/**
 * @param {string} styles The styles as HTML style syntax.
 * @return {Object} The styles object.
 */
org_apache_flex_core_SimpleCSSValuesImpl.prototype.parseStyles = function(styles) {
  var obj = {};
  var parts = styles.split(';');
  var l = parts.length;
  for (var i = 0; i < l; i++) {
    var part = parts[i];
    var pieces = part.split(':');
    var value = pieces[1];
    if (value == 'null')
      obj[pieces[0]] = null;
    else if (value == 'true')
      obj[pieces[0]] = true;
    else if (value == 'false')
      obj[pieces[0]] = false;
    else {
      var n = Number(value);
      if (isNaN(n)) {
        if (value.indexOf("'") === 0)
          value = value.substring(1, value.length - 1);
        obj[pieces[0]] = value;
      }
      else
        obj[pieces[0]] = n;
    }
  }
  return obj;
};


/**
 * The styles that apply to each UI widget
 */
org_apache_flex_core_SimpleCSSValuesImpl.perInstanceStyles = {
   'backgroundColor': 1,
   'backgroundImage': 1,
   'color': 1,
   'fontFamily': 1,
   'fontWeight': 1,
   'fontSize': 1,
   'fontStyle': 1
};


/**
 * The styles that use color format #RRGGBB
 */
org_apache_flex_core_SimpleCSSValuesImpl.colorStyles = {
   'backgroundColor': 1,
   'borderColor': 1,
   'color': 1
};


/**
 * @param {Object} thisObject The object to apply styles to;
 * @param {Object} styles The styles.
 */
org_apache_flex_core_SimpleCSSValuesImpl.prototype.applyStyles =
    function(thisObject, styles) {
  var styleList = org_apache_flex_core_SimpleCSSValuesImpl.perInstanceStyles;
  var colorStyles = org_apache_flex_core_SimpleCSSValuesImpl.colorStyles;
  for (var p in styles) {
    //if (styleList[p])
    var value = styles[p];
    if (typeof(value) == 'number') {
      if (colorStyles[p])
        value = '#' + value.toString(16);
      else
        value = value.toString() + 'px';
    }
    else if (p == 'backgroundImage') {
      if (p.indexOf('url') !== 0)
        value = 'url(' + value + ')';
    }
    thisObject.element.style[p] = value;
  }
};
