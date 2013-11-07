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

goog.provide('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 */
org.apache.flex.utils.MXMLDataInterpreter = function() {
};


/**
 * @param {Object} document The MXML object.
 * @param {Array} data The data array.
 * @return {Object} The generated object.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject =
    function(document, data) {
  var assingComp, Cls, comp, generateMXMLArray, generateMXMLObject, i, id, j, m,
      name, simple, value;

  i = 0;
  Cls = data[i++];
  comp = new Cls();

  generateMXMLArray =
      org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray;
  generateMXMLObject =
      org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject;

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

    assingComp = true;
    if (name === 'id') {
      document['set_' + value](comp);
      id = value;
    } else if (name === '_id') {
      document[value] = comp;
      id = value;
      assingComp = false;
    }

    if (assingComp) {
      if (typeof comp['set_' + name] === 'function') {
        comp['set_' + name](value);
      } else {
        comp[name] = value;
      }
    }
  }

  if (typeof comp.setDocument === 'function') {
    comp.setDocument(document, id);
  }

  return comp;
};


/**
 * @expose
 * @param {Object} document The MXML object.
 * @param {Object} parent The parent object.
 * @param {Array} data The data array.
 * @param {Boolean=} opt_recursive Whether to create objects in children.
 * @return {Array} The generated array.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray =
    function(document, parent, data, opt_recursive) {
  var bead, beadOffset, beads, children, Cls, comp, comps, generateMXMLArray,
      generateMXMLObject, i, id, j, k, l, m, n, name, self, simple, value;

  if (opt_recursive === undefined) {
    opt_recursive = true;
  }

  generateMXMLArray =
      org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray;
  generateMXMLObject =
      org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject;

  comps = [];

  n = data.length;
  i = 0;
  while (i < n) {
    Cls = data[i++];
    comp = new Cls();

    id = null;

    m = data[i++]; // num props
    if (m > 0 && data[0] === 'model') {
      m--;
      name = data[i++];
      simple = data[i++];
      value = data[i++];

      if (simple === null) {
        value = generateMXMLArray(document, parent, value, opt_recursive);
      } else if (simple === false) {
        value = generateMXMLObject(document, value);
      }

      if (typeof comp['set_' + name] === 'function') {
        comp['set_' + name](value);
      } else {
        comp[name] = value;
      }

      // (erikdebruin) There are no components with the 'get_strand' method...
      /*
      if (typeof value.addBead === 'function' &&
          typeof comp.get_strand === 'function') {
        comp.addBead(value);
      }
      */
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
        value = generateMXMLArray(document, null, value, opt_recursive);
      } else if (simple === false) {
        value = generateMXMLObject(document, value);
      }

      if (name === 'id') {
        id = value;
      }

      if (name === 'document' && !comp.document) {
        comp.document = document;
      } else if (name === '_id') {
        id = value; // and don't assign to comp
      } else {
        if (typeof(comp['set_' + name]) === 'function') {
          comp['set_' + name](value);
        } else {
          comp[name] = value;
        }
      }
    }

    if (beadOffset > -1)
    {
      name = data[i++];
      simple = data[i++];
      value = data[i++];

      if (simple === null) {
        value = generateMXMLArray(document, null, value, opt_recursive);
      } else if (simple === false) {
        value = generateMXMLObject(document, value);
      } else {
        if (typeof(comp['set_' + name]) === 'function') {
          comp['set_' + name](value);
        } else {
          comp[name] = value;
        }
      }

      beads = value;
      l = beads.length;
      for (k = 0; k < l; k++) {
        bead = beads[k];
        comp.addBead(bead);
      }
    }

    m = data[i++]; // num styles
    for (j = 0; j < m; j++) {
      name = data[i++];
      simple = data[i++];
      value = data[i++];

      if (simple === null) {
        value = generateMXMLArray(document, null, value, opt_recursive);
      } else if (simple === false) {
        value = generateMXMLObject(document, value);
      }

      comp.setStyle(name, value);
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

    if (parent) {
      parent.addElement(comp);
    }

    children = data[i++];
    if (children) {
      if (opt_recursive) {
        self = org.apache.flex.utils.MXMLDataInterpreter;
        self.generateMXMLInstances(
            document, comp, children, opt_recursive);
        if (typeof comp.childrenAdded === 'function')
          comp.childrenAdded();
      } else {
        comp.setMXMLDescriptor(children);
      }
    }

    if (id) {
      if (typeof(document['set_' + id]) === 'function') {
        document['set_' + id](comp);
      } else {
        document[id] = comp;
      }
    }

    if (typeof(comp.setDocument) === 'function') {
      comp.setDocument(document, id);
    }

    comps.push(comp);
  }

  return comps;
};


/**
 * @expose
 * @param {Object} document The MXML object.
 * @param {Object} parent The parent object.
 * @param {Array} data The data array.
 * @param {Boolean} recursive Whether to create objects in children.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances =
    function(document, parent, data, recursive) {
  if (data) {
    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray(
        document, parent, data, recursive);
  }
};


/**
 * @expose
 * @param {Object} host The MXML object.
 * @param {Array} data The data array.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties =
    function(host, data) {
  var bead, beadOffset, beads, generateMXMLArray, generateMXMLObject, i, id, j,
      k, l, m, name, simple, value;

  if (!data) {
    return;
  }

  i = 0;
  id = null;

  generateMXMLArray =
      org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray;
  generateMXMLObject =
      org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject;

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
      value = generateMXMLArray(host, null, value, true);
    } else if (simple === false) {
      value = generateMXMLObject(host, value);
    }

    if (name === 'id') {
      id = value;
    }

    if (name === '_id') {
      id = value; // and don't assign
    } else {
      if (typeof(host['set_' + name]) === 'function') {
        host['set_' + name](value);
      } else {
        host[name] = value;
      }
    }
  }

  if (beadOffset > -1) {
    name = data[i++];
    simple = data[i++];
    value = data[i++];

    if (simple === null) {
      value = generateMXMLArray(host, null, value, true);
    } else if (simple === false) {
      value = generateMXMLObject(host, value);
    } else {
      if (typeof(host['set_' + name]) === 'function') {
        host['set_' + name](value);
      } else {
        host[name] = value;
      }
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
      value = generateMXMLArray(host, null, value, true);
    } else if (simple === false) {
      value = generateMXMLObject(host, value);
    }

    if (typeof(host['set_' + name]) === 'function') {
      host['set_' + name](value);
    } else {
      host[name] = value;
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
                value = generateMXMLArray(host, null, value, false);
            else if (simple === false)
                value = generateMXMLObject(host, value);
            if (typeof(host['set_' + name]) == 'function')
                host['set_' + name](value);
            else
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
