/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 */
org_apache_flex_utils_MXMLDataInterpreter = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_MXMLDataInterpreter.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'MXMLDataInterpreter',
                qName: 'org_apache_flex_utils_MXMLDataInterpreter'}] };


/**
 * @param {Object} document The MXML object.
 * @param {Array} data The data array.
 * @return {Object} The generated object.
 */
org_apache_flex_utils_MXMLDataInterpreter.generateMXMLObject =
    function(document, data) {
  var assignComp, Cls, comp, generateMXMLArray, generateMXMLObject, i, id, j, m,
      name, simple, value;

  i = 0;
  Cls = data[i++];
  comp = new Cls();

  generateMXMLArray =
      org_apache_flex_utils_MXMLDataInterpreter.generateMXMLArray;
  generateMXMLObject =
      org_apache_flex_utils_MXMLDataInterpreter.generateMXMLObject;

  if (comp.addBead)
    org_apache_flex_utils_MXMLDataInterpreter.initializeStrandBasedObject(document, null, comp, data, i);
  else {
    m = data[i++]; // num props
    for (j = 0; j < m; j++) {
      name = data[i++];
      simple = data[i++];
      value = data[i++];

      if (simple === null) {
        value = generateMXMLArray(document, null, value);
      } else if (simple === false) {
        value = generateMXMLObject(document, value);
      }

      if (name === 'id') {
        document[value] = comp;
        id = value;
      }

      if (name == 'document' && !comp.document) {
        comp.document = document;
      }
      else if (name === '_id') {
        document[value] = comp;
        id = value;
      }
      else if (name === 'id') {
		try {
          comp.id = value;
		} catch (e) {};
      }
      else {
        comp[name] = value;
      }
    }

    if (typeof comp.setDocument === 'function') {
      comp.setDocument(document, id);
    }
  }

  return comp;
};


/**
 * @expose
 * @param {Object} document The MXML object.
 * @param {Object} parent The parent object.
 * @param {Array} data The data array.
 * @return {Array} The generated array.
 */
org_apache_flex_utils_MXMLDataInterpreter.generateMXMLArray =
    function(document, parent, data) {
  var comps = [];

  var n = data.length;
  var i = 0;
  while (i < n) {
    var cls = data[i++];
    var comp = new cls();

    i = org_apache_flex_utils_MXMLDataInterpreter.initializeStrandBasedObject(document, parent, comp, data, i);

    comps.push(comp);
  }
  return comps;
};


/**
 * @expose
 * @param {Object} document The MXML object.
 * @param {Object} parent The parent object.
 * @param {Object} comp The component being initialized.
 * @param {Array} data The data array.
 * @param {number} i The offset into data.
 * @return {number} The new offset into the data.
 */
org_apache_flex_utils_MXMLDataInterpreter.initializeStrandBasedObject =
    function(document, parent, comp, data, i) {
  var bead, beadOffset, beads, children, Cls, generateMXMLArray,
      generateMXMLObject, id, j, k, l, m, n, name, self, simple, value, dispatchBeadsAdded;

  generateMXMLArray =
      org_apache_flex_utils_MXMLDataInterpreter.generateMXMLArray;
  generateMXMLObject =
      org_apache_flex_utils_MXMLDataInterpreter.generateMXMLObject;

  id = null;

  m = data[i++]; // num props
  if (m > 0 && data[0] === 'model') {
    m--;
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(document, parent, value);
    } else if (simple === false) {
      value = generateMXMLObject(document, value);
    }

    comp[name] = value;
  }

  beadOffset = i + (m - 1) * 3;
  if (m > 0 && data[beadOffset] === 'beads') {
    m--;
  } else {
    beadOffset = -1;
  }

  for (j = 0; j < m; j++) {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(document, null, value);
    } else if (simple === false) {
      value = generateMXMLObject(document, value);
    }

    if (name === 'id') {
      id = value;
      document[value] = comp;
    }

    if (name === 'document' && !comp.document) {
      comp.document = document;
    } else if (name === '_id') {
      id = value; // and don't assign to comp
    } else if (name === 'id') {
      try {
        comp.id = value;
      } catch (e) {};
    } else {
      comp[name] = value;
    }
  }

  if (beadOffset > -1)
  {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(document, null, value);
    } else if (simple === false) {
      value = generateMXMLObject(document, value);
    }
    comp[name] = value;
  }

  m = data[i++]; // num styles
  for (j = 0; j < m; j++) {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(document, null, value);
    } else if (simple === false) {
      value = generateMXMLObject(document, value);
    }

    if (comp.setStyle) {
      comp.setStyle(name, value);
    }
  }

    /*
    m = data[i++]; // num effects
    for (j = 0; j < m; j++)
    {
      name = data[i++];
      simple = data[i++];
      value = data[i++];
      if (simple === null)
        value = generateMXMLArray(document, null, value, opt_recursive);
      else if (simple === false)
        value = generateMXMLObject(document, value);
      comp.setStyle(name, value);
    }
    */

  m = data[i++]; // num events
  for (j = 0; j < m; j++) {
    name = data[i++];
    value = data[i++];

    comp.addEventListener(name, goog.bind(value, document));
  }

  children = data[i++];
  if (children && comp['setMXMLDescriptor']) {
    comp['setMXMLDescriptor'](document, children);
  }
  if (parent && org_apache_flex_utils_Language.is(comp,
      org_apache_flex_core_IUIBase)) {
    parent.addElement(comp);
  }

  if (children) {
    if (!comp['setMXMLDescriptor']) {
      self = org_apache_flex_utils_MXMLDataInterpreter;
      self.generateMXMLInstances(
            document, comp, children);
      if (typeof comp.childrenAdded === 'function')
        comp.childrenAdded();
    }
  }

  if (id) {
    document[id] = comp;
  }

  if (typeof(comp.setDocument) === 'function') {
    comp.setDocument(document, id);
  }

  if (goog.isFunction(comp.finalizeElement)) {
    comp.finalizeElement();
  }

  return i;
};


/**
 * @expose
 * @param {Object} document The MXML object.
 * @param {Object} parent The parent object.
 * @param {Array} data The data array.
 */
org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances =
    function(document, parent, data) {
  if (data) {
    org_apache_flex_utils_MXMLDataInterpreter.generateMXMLArray(
        document, parent, data);
  }
};


/**
 * @expose
 * @param {Object} host The MXML object.
 * @param {Array} data The data array.
 */
org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties =
    function(host, data) {
  var bead, beadOffset, beads, generateMXMLArray, generateMXMLObject, i, id, j,
      k, l, m, name, simple, value;

  if (!data) {
    return;
  }

  i = 0;
  id = null;

  generateMXMLArray =
      org_apache_flex_utils_MXMLDataInterpreter.generateMXMLArray;
  generateMXMLObject =
      org_apache_flex_utils_MXMLDataInterpreter.generateMXMLObject;

  m = data[i++]; // num props
  beadOffset = i + (m - 1) * 3;
  if (m > 0 && data[beadOffset] === 'beads') {
    m--;
  } else {
    beadOffset = -1;
  }

  for (j = 0; j < m; j++) {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(host, null, value);
    } else if (simple === false) {
      value = generateMXMLObject(host, value);
    }

    if (name === 'id') {
      id = value;
    }

    if (name === '_id') {
      id = value; // and don't assign
    } else {
      host[name] = value;
    }
  }

  if (beadOffset > -1) {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(host, null, value);
    } else if (simple === false) {
      value = generateMXMLObject(host, value);
    }

    beads = value;
    l = beads.length;
    for (k = 0; k < l; k++) {
      bead = beads[k];
      host.addBead(bead);
    }
  }

  m = data[i++]; // num styles
  for (j = 0; j < m; j++) {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(host, null, value);
    } else if (simple === false) {
      value = generateMXMLObject(host, value);
    }

    host[name] = value;
  }

  /*
        m = data[i++]; // num effects
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple === null)
                value = generateMXMLArray(host, null, value, false);
            else if (simple === false)
                value = generateMXMLObject(host, value);
            host[name] = value;
        }
      */

  m = data[i++]; // num events
  for (j = 0; j < m; j++) {
    name = data[i++];
    value = data[i++];
    host.addEventListener(name, goog.bind(value, host));
  }
};
