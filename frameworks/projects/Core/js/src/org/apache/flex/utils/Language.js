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

goog.provide('org_apache_flex_utils_Language');



/**
 * @constructor
 */
org_apache_flex_utils_Language = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_Language.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Language',
                qName: 'org_apache_flex_utils_Language'}] };


/**
 * as()
 *
 * @expose
 * @param {?} leftOperand The lefthand operand of the
 *                        binary as operator in AS3.
 * @param {?} rightOperand The righthand operand of the
 *                         binary operator in AS3.
 * @param {?=} opt_coercion The cast is a coercion,
 *                          throw expception if it fails.
 * @return {?} Returns the lefthand operand if it is of the
 *             type of the righthand operand, otherwise null.
 */
org_apache_flex_utils_Language.as = function(leftOperand, rightOperand, opt_coercion) {
  var error, itIs, message;

  opt_coercion = (opt_coercion !== undefined) ? opt_coercion : false;

  itIs = org_apache_flex_utils_Language.is(leftOperand, rightOperand);

  if (!itIs && opt_coercion) {
    message = 'Type Coercion failed';
    if (TypeError) {
      error = new TypeError(message);
    } else {
      error = new Error(message);
    }
    throw error;
  }

  return (itIs) ? leftOperand : null;
};


/**
 * int()
 *
 * @expose
 * @param {?} value The value to be cast.
 * @return {number}
 */
org_apache_flex_utils_Language._int = function(value) {
  return value >> 0;
};


/**
 * is()
 *
 * @expose
 * @param {?} leftOperand The lefthand operand of the
 *     binary as operator in AS3.
 * @param {?} rightOperand The righthand operand of the
 *     binary operator in AS3.
 * @return {boolean}
 */
org_apache_flex_utils_Language.is = function(leftOperand, rightOperand) {
  var checkInterfaces, superClass;

  if (!leftOperand)
    return false;

  if (leftOperand && !rightOperand) {
    return false;
  }

  checkInterfaces = function(left) {
    var i, interfaces;

    interfaces = left.FLEXJS_CLASS_INFO.interfaces;
    for (i = interfaces.length - 1; i > -1; i--) {
      if (interfaces[i] === rightOperand) {
        return true;
      }

      if (interfaces[i].prototype.FLEXJS_CLASS_INFO.interfaces) {
        var isit = checkInterfaces(new interfaces[i]());
        if (isit) return true;
      }
    }

    return false;
  };

  if ((rightOperand === String && typeof leftOperand === 'string') ||
      (leftOperand instanceof /** @type {Object} */(rightOperand))) {
    return true;
  }
  if (typeof leftOperand === 'string')
    return false; // right was not String otherwise exit above
  if (typeof leftOperand === 'number')
    return rightOperand === Number;
  if (rightOperand === Array && Array.isArray(leftOperand))
    return true;
  if (leftOperand.FLEXJS_CLASS_INFO === undefined)
    return false; // could be a function but not an instance
  if (leftOperand.FLEXJS_CLASS_INFO.interfaces) {
    if (checkInterfaces(leftOperand)) {
      return true;
    }
  }

  superClass = leftOperand.constructor.superClass_;
  if (superClass) {
    while (superClass && superClass.FLEXJS_CLASS_INFO) {
      if (superClass.FLEXJS_CLASS_INFO.interfaces) {
        if (checkInterfaces(superClass)) {
          return true;
        }
      }
      superClass = superClass.constructor.superClass_;
    }
  }

  return false;
};


/**
 * trace()
 *
 * @expose
 * @param {...Object} var_args The message(s) to be written to the console.
 */
org_apache_flex_utils_Language.trace = function(var_args) {
  var theConsole;

  var msg = '';
  for (var i = 0; i < arguments.length; i++) {
    if (i > 0) msg += ' ';
    msg += arguments[i];
  }

  theConsole = goog.global.console;

  if (theConsole === undefined && window.console !== undefined)
    theConsole = window.console;

  try {
    if (theConsole && theConsole.log) {
      theConsole.log(msg);
    }
  } catch (e) {
    // ignore; at least we tried ;-)
  }
};


/**
 * uint()
 *
 * @expose
 * @param {?} value The value to be cast.
 * @return {number}
 */
org_apache_flex_utils_Language.uint = function(value) {
  return value >>> 0;
};


/**
 * preincrement handles --foo
 *
 * @expose
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org_apache_flex_utils_Language.preincrement = function(obj, prop) {
  var value = obj[prop] + 1;
  obj[prop] = value;
  return value;
};


/**
 * predecrement handles ++foo
 *
 * @expose
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org_apache_flex_utils_Language.predecrement = function(obj, prop) {
  var value = obj[prop] - 1;
  obj[prop] = value;
  return value;
};


/**
 * postincrement handles foo++
 *
 * @expose
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org_apache_flex_utils_Language.postincrement = function(obj, prop) {
  var value = obj[prop];
  obj[prop] = value + 1;
  return value;
};


/**
 * postdecrement handles foo++
 *
 * @expose
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org_apache_flex_utils_Language.postdecrement = function(obj, prop) {
  var value = obj[prop];
  obj[prop] = value + 1;
  return value;
};


/**
 * superGetter calls the getter on the given class' superclass.
 *
 * @expose
 * @param {Object} clazz The class.
 * @param {Object} pthis The this pointer.
 * @param {string} prop The name of the getter.
 * @return {Object}
 */
org_apache_flex_utils_Language.superGetter = function(clazz, pthis, prop) {
  var superClass = clazz.superClass_;
  var superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
  while (superdesc == null)
  {
    superClass = superClass.constructor.superClass_;
    superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
  }
  return superdesc.get.call(pthis);
};


/**
 * superSetter calls the setter on the given class' superclass.
 *
 * @expose
 * @param {Object} clazz The class.
 * @param {Object} pthis The this pointer.
 * @param {string} prop The name of the getter.
 * @param {Object} value The value.
 */
org_apache_flex_utils_Language.superSetter = function(clazz, pthis, prop, value) {
  var superClass = clazz.superClass_;
  var superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
  while (superdesc == null)
  {
    superClass = superClass.constructor.superClass_;
    superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
  }
  superdesc.set.apply(pthis, [value]);
};
