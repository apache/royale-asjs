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

goog.provide('org.apache.flex.utils.Language');



/**
 * @constructor
 */
org.apache.flex.utils.Language = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.utils.Language.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Language',
                qName: 'org.apache.flex.utils.Language'}] };


/**
 * as()
 *
 * @export
 * @param {?} leftOperand The lefthand operand of the
 *                        binary as operator in AS3.
 * @param {?} rightOperand The righthand operand of the
 *                         binary operator in AS3.
 * @param {?=} opt_coercion The cast is a coercion,
 *                          throw expception if it fails.
 * @return {?} Returns the lefthand operand if it is of the
 *             type of the righthand operand, otherwise null.
 */
org.apache.flex.utils.Language.as = function(leftOperand, rightOperand, opt_coercion) {
  var error, itIs, message;

  opt_coercion = (opt_coercion !== undefined) ? opt_coercion : false;

  itIs = org.apache.flex.utils.Language.is(leftOperand, rightOperand);

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
 * @export
 * @param {?} value The value to be cast.
 * @return {number}
 */
org.apache.flex.utils.Language._int = function(value) {
  return value >> 0;
};


/**
 * is()
 *
 * @export
 * @param {?} leftOperand The lefthand operand of the
 *     binary as operator in AS3.
 * @param {?} rightOperand The righthand operand of the
 *     binary operator in AS3.
 * @return {boolean}
 */
org.apache.flex.utils.Language.is = function(leftOperand, rightOperand) {
  var superClass;

  if (leftOperand == null || rightOperand == null)
    return false;
  if (leftOperand instanceof rightOperand)
    return true;
  if (rightOperand === Object)
    return true; // every value is an Object in ActionScript except null and undefined (caught above)
  if (typeof leftOperand === 'string')
    return rightOperand === String;
  if (typeof leftOperand === 'number')
    return rightOperand === Number;
  if (typeof leftOperand === 'boolean')
    return rightOperand === Boolean;
  if (rightOperand === Array)
    return Array.isArray(leftOperand);

  if (leftOperand.FLEXJS_CLASS_INFO === undefined)
    return false; // could be a function but not an instance
  if (leftOperand.FLEXJS_CLASS_INFO.interfaces) {
    if (org.apache.flex.utils.Language.checkInterfaces(leftOperand)) {
      return true;
    }
  }

  superClass = leftOperand.constructor.superClass_;
  if (superClass) {
    while (superClass && superClass.FLEXJS_CLASS_INFO) {
      if (superClass.FLEXJS_CLASS_INFO.interfaces) {
        if (org.apache.flex.utils.Language.checkInterfaces(superClass)) {
          return true;
        }
      }
      superClass = superClass.constructor.superClass_;
    }
  }

  return false;
};

/**
 * Helper function for is()
 * 
 * @private
 * @param {?} leftOperand
 * @param {?} rightOperand
 * @return {boolean}
 */
org.apache.flex.utils.Language.checkInterfaces = function(leftOperand, rightOperand) {
  var i, interfaces;

  interfaces = leftOperand.FLEXJS_CLASS_INFO.interfaces;
  for (i = interfaces.length - 1; i > -1; i--) {
    if (interfaces[i] === rightOperand) {
      return true;
    }

    if (interfaces[i].prototype.FLEXJS_CLASS_INFO.interfaces) {
      var isit = org.apache.flex.utils.Language.checkInterfaces(interfaces[i].prototype, rightOperand);
      if (isit) return true;
    }
  }

  return false;
};

/**
 * Implementation of "classDef is Class"
 * 
 * @export
 * @param {?} classDef A possible Class definition
 * @return {boolean} Returns true if classDef is a Class definition.
 */
org.apache.flex.utils.Language.isClass = function(classDef) {
  return typeof classDef === 'function'
    && classDef.prototype
    && classDef.prototype.constructor === classDef;
};

/**
 * Implementation of "classDef as Class"
 * 
 * @export
 * @param {?} classDef A possible Class definition
 * @return {boolean} Returns classDef if it is a Class, otherwise null.
 */
org.apache.flex.utils.Language.asClass = function(classDef) {
  return isClass(classDef) ? classDef : null;
};

/**
 * trace()
 *
 * @export
 * @param {...Object} var_args The message(s) to be written to the console.
 */
org.apache.flex.utils.Language.trace = function(var_args) {
  var theConsole;

  theConsole = goog.global.console;

  if (theConsole === undefined && window.console !== undefined)
    theConsole = window.console;

  try {
    if (theConsole && theConsole.log) {
      theConsole.log.apply(theConsole, arguments);
    }
  } catch (e) {
    // ignore; at least we tried ;-)
  }
};


/**
 * uint()
 *
 * @export
 * @param {?} value The value to be cast.
 * @return {number}
 */
org.apache.flex.utils.Language.uint = function(value) {
  return value >>> 0;
};


/**
 * preincrement handles ++foo
 *
 * @export
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org.apache.flex.utils.Language.preincrement = function(obj, prop) {
  var value = obj[prop] + 1;
  obj[prop] = value;
  return value;
};


/**
 * predecrement handles --foo
 *
 * @export
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org.apache.flex.utils.Language.predecrement = function(obj, prop) {
  var value = obj[prop] - 1;
  obj[prop] = value;
  return value;
};


/**
 * postincrement handles foo++
 *
 * @export
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org.apache.flex.utils.Language.postincrement = function(obj, prop) {
  var value = obj[prop];
  obj[prop] = value + 1;
  return value;
};


/**
 * postdecrement handles foo--
 *
 * @export
 * @param {Object} obj The object with the getter/setter.
 * @param {string} prop The name of a property.
 * @return {number}
 */
org.apache.flex.utils.Language.postdecrement = function(obj, prop) {
  var value = obj[prop];
  obj[prop] = value - 1;
  return value;
};


/**
 * superGetter calls the getter on the given class' superclass.
 *
 * @export
 * @param {Object} clazz The class.
 * @param {Object} pthis The this pointer.
 * @param {string} prop The name of the getter.
 * @return {Object}
 */
org.apache.flex.utils.Language.superGetter = function(clazz, pthis, prop) {
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
 * @export
 * @param {Object} clazz The class.
 * @param {Object} pthis The this pointer.
 * @param {string} prop The name of the getter.
 * @param {Object} value The value.
 */
org.apache.flex.utils.Language.superSetter = function(clazz, pthis, prop, value) {
  var superClass = clazz.superClass_;
  var superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
  while (superdesc == null)
  {
    superClass = superClass.constructor.superClass_;
    superdesc = Object.getOwnPropertyDescriptor(superClass, prop);
  }
  superdesc.set.apply(pthis, [value]);
};


/**
 * caches closures and returns the one closure
 *
 * @export
 * @param {Function} fn The method on the instance.
 * @param {Object} object The instance.
 * @param {string} boundMethodName The name to use to cache the closure.
 * @return {Function} The closure.
 */
org.apache.flex.utils.Language.closure = function(fn, object, boundMethodName) {
  if (object.hasOwnProperty(boundMethodName)) {
    return object[boundMethodName];
  }
  var boundMethod = goog.bind(fn, object);
  Object.defineProperty(object, boundMethodName, {
    value: boundMethod
  });
  return boundMethod;
};
