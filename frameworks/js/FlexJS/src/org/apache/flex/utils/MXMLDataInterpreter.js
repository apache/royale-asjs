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

goog.provide('org.apache.flex.utils.MXMLDataInterpreter');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.utils.MXMLDataInterpreter = function() {
    org.apache.flex.FlexObject.call(this);

};
goog.inherits(org.apache.flex.utils.MXMLDataInterpreter,
                org.apache.flex.FlexObject);

/**
 * @param {object} document The MXML object.
 * @param {Array} data The data array.
 * @return {object} The generated object.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject =
                                                    function(document, data) {
        var i = 0;
        var cls = data[i++];
        var comp = new cls();

        var m;
        var j;
        var name;
        var simple;
        var value;
        var id;

        var generateMXMLArray = org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray;
        var generateMXMLObject = org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject;
        
        m = data[i++]; // num props
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(document, null, value);
            else if (simple == false)
                value = generateMXMLObject(document, value);
            if (name == 'id')
            {
                document['set_' + value](comp);
                id = value;
            }
            else if (name == '_id')
            {
                document[value] = comp;
                id = value;
                continue; // skip assignment to comp
            }
            if (typeof(comp['set_' + name]) == 'function')
                comp['set_' + name](value);
            else
                comp[name] = value;
        }
        if (typeof(comp.setDocument) == 'function')
            comp.setDocument(document, id);
        return comp;
};

/**
 * @expose
 * @param {Object} document The MXML object.
 * @param {Object} parent The parent object.
 * @param {Array} data The data array.
 * @param {Boolean} recursive Whether to create objects in children.
 * @return {Array} The generated array.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray =
                                function(document, parent, data, recursive) {
        if (typeof(recursive) == 'undefined')
            recursive = true;

        var generateMXMLArray = org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray;
        var generateMXMLObject = org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject;

        var comps = [];

        var n = data.length;
        var i = 0;
        while (i < n)
        {
            var cls = data[i++];
            var comp = new cls();

            if (parent)
            {
                comp.addToParent(parent.element);
            }

            var m;
            var j;
            var name;
            var simple;
            var value;
            var id = null;

            m = data[i++]; // num props
            if (m > 0 && data[0] == 'model')
            {
                m--;
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, parent,
                                                value, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value);
                if (typeof(comp['set_' + name]) == 'function')
                    comp['set_' + name](value);
                else
                    comp[name] = value;
                if (typeof(value.addBead) == 'function' &&
                    typeof(comp.get_strand) == 'function')
                    comp.addBead(value);
            }
            if (typeof(comp.initModel) == 'function')
                comp.initModel();
            var beadOffset = i + (m - 1) * 3;
            if (m > 0 && data[beadOffset] == 'beads')
            {
                m--;
            }
            else
                beadOffset = -1;
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value);
                if (name == 'id')
                    id = value;
                if (name == 'document' && !comp.document)
                    comp.document = document;
                else if (name == '_id')
                    id = value; // and don't assign to comp
                else
                {
                    if (typeof(comp['set_' + name]) == 'function')
                        comp['set_' + name](value);
                    else
                        comp[name] = value;
                }
            }
            if (beadOffset > -1)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value);
                else
                {
                if (typeof(comp['set_' + name]) == 'function')
                    comp['set_' + name](value);
                else
                    comp[name] = value;
                }
                var beads = value;
                var l = beads.length;
                for (var k = 0; k < l; k++)
                {
                    var bead = beads[k];
                    comp.addBead(bead);
                }
            }
            m = data[i++]; // num styles
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value);
                comp.setStyle(name, value);
            }
            if (typeof(comp.initSkin) == 'function')
            {
                comp.initSkin();
            }

            /*
            m = data[i++]; // num effects
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value);
                comp.setStyle(name, value);
            }
            */
            
            m = data[i++]; // num events
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                value = data[i++];
                comp.addEventListener(name, 
                    org.apache.flex.FlexGlobal.createProxy(document, value));
            }

            var children = data[i++];
            if (children)
            {
                if (recursive)
                    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(document, comp, children, recursive);
                else
                    comp.setMXMLDescriptor(children);
            }

            if (id)
            {
                if (typeof(document['set_' + id]) == 'function')
                    document['set_' + id](comp);
                else
                    document[id] = comp;
            }

            if (typeof(comp.setDocument) == 'function')
                comp.setDocument(document, id);
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
    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray(
                                document, parent, data, recursive);
};

/**
 * @expose
 * @param {Object} host The MXML object.
 * @param {Array} data The data array.
 */
org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties =
                                                    function(host, data) {
        var i = 0;
        var m;
        var j;
        var name;
        var simple;
        var value;
        var id = null;
        
        var generateMXMLArray = org.apache.flex.utils.MXMLDataInterpreter.generateMXMLArray;
        var generateMXMLObject = org.apache.flex.utils.MXMLDataInterpreter.generateMXMLObject;

        m = data[i++]; // num props
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value, false);
            else if (simple == false)
                value = generateMXMLObject(host, value);
            if (name == 'id')
                id = value;
            if (name == '_id')
                id = value; // and don't assign
            else
            {
                if (typeof(host['set_' + name]) == 'function')
                    host['set_' + name](value);
                else
                    host[name] = value;
            }
        }
        m = data[i++]; // num styles
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value, false);
            else if (simple == false)
                value = generateMXMLObject(host, value);
            if (typeof(host['set_' + name]) == 'function')
                host['set_' + name](value);
            else
                host[name] = value;
        }

        /*
        m = data[i++]; // num effects
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value, false);
            else if (simple == false)
                value = generateMXMLObject(host, value);
            if (typeof(host['set_' + name]) == 'function')
                host['set_' + name](value);
            else
                host[name] = value;
        }
        */
        
        m = data[i++]; // num events
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            value = data[i++];
            host.addEventListener(name, 
                org.apache.flex.FlexGlobal.createProxy(host, value));
        }
};
