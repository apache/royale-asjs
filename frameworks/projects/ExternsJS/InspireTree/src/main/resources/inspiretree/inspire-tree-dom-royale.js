/**
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
 
/* Inspire Tree DOM
 * @version 4.0.6
 * https://github.com/helion3/inspire-tree-dom
 * @copyright Copyright 2015 Helion3, and other contributors
 * @license Licensed under MIT
 *          see https://github.com/helion3/inspire-tree-dom/blob/master/LICENSE
 */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('lodash'), require('inspire-tree')) :
    typeof define === 'function' && define.amd ? define(['lodash', 'inspire-tree'], factory) :
    (global.InspireTreeDOM = factory(global._,global.InspireTree));
}(this, (function (_,InspireTree) { 'use strict';

    InspireTree = InspireTree && InspireTree.hasOwnProperty('default') ? InspireTree['default'] : InspireTree;

    var NO_OP = '$NO_OP';
    var ERROR_MSG = 'a runtime error occured! Use Inferno in development environment to find the error.';
    var isBrowser = !!(typeof window !== 'undefined' && window.document);
    var isArray = Array.isArray;
    function isStringOrNumber(o) {
        var type = typeof o;
        return type === 'string' || type === 'number';
    }
    function isNullOrUndef(o) {
        return isUndefined(o) || isNull(o);
    }
    function isInvalid(o) {
        return isNull(o) || o === false || isTrue(o) || isUndefined(o);
    }
    function isFunction(o) {
        return typeof o === 'function';
    }
    function isString(o) {
        return typeof o === 'string';
    }
    function isNumber(o) {
        return typeof o === 'number';
    }
    function isNull(o) {
        return o === null;
    }
    function isTrue(o) {
        return o === true;
    }
    function isUndefined(o) {
        return o === void 0;
    }
    function throwError(message) {
        if (!message) {
            message = ERROR_MSG;
        }
        throw new Error(("Inferno Error: " + message));
    }
    function combineFrom(first, second) {
        var out = {};
        if (first) {
            for (var key in first) {
                out[key] = first[key];
            }
        }
        if (second) {
            for (var key$1 in second) {
                out[key$1] = second[key$1];
            }
        }
        return out;
    }

    var keyPrefix = '$';
    function getVNode(childFlags, children, className, flags, key, props, ref, type) {
        return {
            childFlags: childFlags,
            children: children,
            className: className,
            dom: null,
            flags: flags,
            key: key === void 0 ? null : key,
            parentVNode: null,
            props: props === void 0 ? null : props,
            ref: ref === void 0 ? null : ref,
            type: type
        };
    }
    function createVNode(flags, type, className, children, childFlags, props, key, ref) {
        var childFlag = childFlags === void 0 ? 1 /* HasInvalidChildren */ : childFlags;
        var vNode = getVNode(childFlag, children, className, flags, key, props, ref, type);
        if (childFlag === 0 /* UnknownChildren */) {
            normalizeChildren(vNode, vNode.children);
        }
        return vNode;
    }
    function createComponentVNode(flags, type, props, key, ref) {
        if ((flags & 2 /* ComponentUnknown */) > 0) {
            flags = type.prototype && isFunction(type.prototype.render) ? 4 /* ComponentClass */ : 8 /* ComponentFunction */;
        }
        // set default props
        var defaultProps = type.defaultProps;
        if (!isNullOrUndef(defaultProps)) {
            if (!props) {
                props = {}; // Props can be referenced and modified at application level so always create new object
            }
            for (var prop in defaultProps) {
                if (isUndefined(props[prop])) {
                    props[prop] = defaultProps[prop];
                }
            }
        }
        if ((flags & 8 /* ComponentFunction */) > 0) {
            var defaultHooks = type.defaultHooks;
            if (!isNullOrUndef(defaultHooks)) {
                if (!ref) {
                    // As ref cannot be referenced from application level, we can use the same refs object
                    ref = defaultHooks;
                }
                else {
                    for (var prop$1 in defaultHooks) {
                        if (isUndefined(ref[prop$1])) {
                            ref[prop$1] = defaultHooks[prop$1];
                        }
                    }
                }
            }
        }
        var vNode = getVNode(1 /* HasInvalidChildren */, null, null, flags, key, props, ref, type);
        var optsVNode = options.createVNode;
        if (isFunction(optsVNode)) {
            optsVNode(vNode);
        }
        return vNode;
    }
    function createTextVNode(text, key) {
        return getVNode(1 /* HasInvalidChildren */, isNullOrUndef(text) ? '' : text, null, 16 /* Text */, key, null, null, null);
    }
    function normalizeProps(vNode) {
        var props = vNode.props;
        if (props) {
            var flags = vNode.flags;
            if (flags & 481 /* Element */) {
                if (props.children !== void 0 && isNullOrUndef(vNode.children)) {
                    normalizeChildren(vNode, props.children);
                }
                if (props.className !== void 0) {
                    vNode.className = props.className || null;
                    props.className = undefined;
                }
            }
            if (props.key !== void 0) {
                vNode.key = props.key;
                props.key = undefined;
            }
            if (props.ref !== void 0) {
                if (flags & 8 /* ComponentFunction */) {
                    vNode.ref = combineFrom(vNode.ref, props.ref);
                }
                else {
                    vNode.ref = props.ref;
                }
                props.ref = undefined;
            }
        }
        return vNode;
    }
    function directClone(vNodeToClone) {
        var newVNode;
        var flags = vNodeToClone.flags;
        if (flags & 14 /* Component */) {
            var props;
            var propsToClone = vNodeToClone.props;
            if (!isNull(propsToClone)) {
                props = {};
                for (var key in propsToClone) {
                    props[key] = propsToClone[key];
                }
            }
            newVNode = createComponentVNode(flags, vNodeToClone.type, props, vNodeToClone.key, vNodeToClone.ref);
        }
        else if (flags & 481 /* Element */) {
            newVNode = createVNode(flags, vNodeToClone.type, vNodeToClone.className, vNodeToClone.children, vNodeToClone.childFlags, vNodeToClone.props, vNodeToClone.key, vNodeToClone.ref);
        }
        else if (flags & 16 /* Text */) {
            newVNode = createTextVNode(vNodeToClone.children, vNodeToClone.key);
        }
        else if (flags & 1024 /* Portal */) {
            newVNode = vNodeToClone;
        }
        return newVNode;
    }
    function createVoidVNode() {
        return createTextVNode('', null);
    }
    function _normalizeVNodes(nodes, result, index, currentKey) {
        for (var len = nodes.length; index < len; index++) {
            var n = nodes[index];
            if (!isInvalid(n)) {
                var newKey = currentKey + keyPrefix + index;
                if (isArray(n)) {
                    _normalizeVNodes(n, result, 0, newKey);
                }
                else {
                    if (isStringOrNumber(n)) {
                        n = createTextVNode(n, newKey);
                    }
                    else {
                        var oldKey = n.key;
                        var isPrefixedKey = isString(oldKey) && oldKey[0] === keyPrefix;
                        if (!isNull(n.dom) || isPrefixedKey) {
                            n = directClone(n);
                        }
                        if (isNull(oldKey) || isPrefixedKey) {
                            n.key = newKey;
                        }
                        else {
                            n.key = currentKey + oldKey;
                        }
                    }
                    result.push(n);
                }
            }
        }
    }
    function normalizeChildren(vNode, children) {
        var newChildren;
        var newChildFlags = 1 /* HasInvalidChildren */;
        // Don't change children to match strict equal (===) true in patching
        if (isInvalid(children)) {
            newChildren = children;
        }
        else if (isString(children)) {
            newChildFlags = 2 /* HasVNodeChildren */;
            newChildren = createTextVNode(children);
        }
        else if (isNumber(children)) {
            newChildFlags = 2 /* HasVNodeChildren */;
            newChildren = createTextVNode(children + '');
        }
        else if (isArray(children)) {
            var len = children.length;
            if (len === 0) {
                newChildren = null;
                newChildFlags = 1 /* HasInvalidChildren */;
            }
            else {
                // we assign $ which basically means we've flagged this array for future note
                // if it comes back again, we need to clone it, as people are using it
                // in an immutable way
                // tslint:disable-next-line
                if (Object.isFrozen(children) || children['$'] === true) {
                    children = children.slice();
                }
                newChildFlags = 8 /* HasKeyedChildren */;
                for (var i = 0; i < len; i++) {
                    var n = children[i];
                    if (isInvalid(n) || isArray(n)) {
                        newChildren = newChildren || children.slice(0, i);
                        _normalizeVNodes(children, newChildren, i, '');
                        break;
                    }
                    else if (isStringOrNumber(n)) {
                        newChildren = newChildren || children.slice(0, i);
                        newChildren.push(createTextVNode(n, keyPrefix + i));
                    }
                    else {
                        var key = n.key;
                        var isNullDom = isNull(n.dom);
                        var isNullKey = isNull(key);
                        var isPrefixed = !isNullKey && key[0] === keyPrefix;
                        if (!isNullDom || isNullKey || isPrefixed) {
                            newChildren = newChildren || children.slice(0, i);
                            if (!isNullDom || isPrefixed) {
                                n = directClone(n);
                            }
                            if (isNullKey || isPrefixed) {
                                n.key = keyPrefix + i;
                            }
                            newChildren.push(n);
                        }
                        else if (newChildren) {
                            newChildren.push(n);
                        }
                    }
                }
                newChildren = newChildren || children;
                newChildren.$ = true;
            }
        }
        else {
            newChildren = children;
            if (!isNull(children.dom)) {
                newChildren = directClone(children);
            }
            newChildFlags = 2 /* HasVNodeChildren */;
        }
        vNode.children = newChildren;
        vNode.childFlags = newChildFlags;
        return vNode;
    }
    var options = {
        afterRender: null,
        beforeRender: null,
        createVNode: null,
        renderComplete: null
    };

    var xlinkNS = 'http://www.w3.org/1999/xlink';
    var xmlNS = 'http://www.w3.org/XML/1998/namespace';
    var svgNS = 'http://www.w3.org/2000/svg';
    var namespaces = {
        'xlink:actuate': xlinkNS,
        'xlink:arcrole': xlinkNS,
        'xlink:href': xlinkNS,
        'xlink:role': xlinkNS,
        'xlink:show': xlinkNS,
        'xlink:title': xlinkNS,
        'xlink:type': xlinkNS,
        'xml:base': xmlNS,
        'xml:lang': xmlNS,
        'xml:space': xmlNS
    };

    // We need EMPTY_OBJ defined in one place.
    // Its used for comparison so we cant inline it into shared
    var EMPTY_OBJ = {};
    var LIFECYCLE = [];
    function appendChild(parentDom, dom) {
        parentDom.appendChild(dom);
    }
    function insertOrAppend(parentDom, newNode, nextNode) {
        if (isNullOrUndef(nextNode)) {
            appendChild(parentDom, newNode);
        }
        else {
            parentDom.insertBefore(newNode, nextNode);
        }
    }
    function documentCreateElement(tag, isSVG) {
        if (isSVG === true) {
            return document.createElementNS(svgNS, tag);
        }
        return document.createElement(tag);
    }
    function replaceChild(parentDom, newDom, lastDom) {
        parentDom.replaceChild(newDom, lastDom);
    }
    function removeChild(parentDom, dom) {
        parentDom.removeChild(dom);
    }
    function callAll(arrayFn) {
        var listener;
        while ((listener = arrayFn.shift()) !== undefined) {
            listener();
        }
    }

    var attachedEventCounts = {};
    var attachedEvents = {};
    function handleEvent(name, nextEvent, dom) {
        var eventsLeft = attachedEventCounts[name];
        var eventsObject = dom.$EV;
        if (nextEvent) {
            if (!eventsLeft) {
                attachedEvents[name] = attachEventToDocument(name);
                attachedEventCounts[name] = 0;
            }
            if (!eventsObject) {
                eventsObject = dom.$EV = {};
            }
            if (!eventsObject[name]) {
                attachedEventCounts[name]++;
            }
            eventsObject[name] = nextEvent;
        }
        else if (eventsObject && eventsObject[name]) {
            attachedEventCounts[name]--;
            if (eventsLeft === 1) {
                document.removeEventListener(normalizeEventName(name), attachedEvents[name]);
                attachedEvents[name] = null;
            }
            eventsObject[name] = nextEvent;
        }
    }
    function dispatchEvents(event, target, isClick, name, eventData) {
        var dom = target;
        while (!isNull(dom)) {
            // Html Nodes can be nested fe: span inside button in that scenario browser does not handle disabled attribute on parent,
            // because the event listener is on document.body
            // Don't process clicks on disabled elements
            if (isClick && dom.disabled) {
                return;
            }
            var eventsObject = dom.$EV;
            if (eventsObject) {
                var currentEvent = eventsObject[name];
                if (currentEvent) {
                    // linkEvent object
                    eventData.dom = dom;
                    if (currentEvent.event) {
                        currentEvent.event(currentEvent.data, event);
                    }
                    else {
                        currentEvent(event);
                    }
                    if (event.cancelBubble) {
                        return;
                    }
                }
            }
            dom = dom.parentNode;
        }
    }
    function normalizeEventName(name) {
        return name.substr(2).toLowerCase();
    }
    function stopPropagation() {
        this.cancelBubble = true;
        if (!this.immediatePropagationStopped) {
            this.stopImmediatePropagation();
        }
    }
    function attachEventToDocument(name) {
        var docEvent = function (event) {
            var type = event.type;
            var isClick = type === 'click' || type === 'dblclick';
            if (isClick && event.button !== 0) {
                // Firefox incorrectly triggers click event for mid/right mouse buttons.
                // This bug has been active for 12 years.
                // https://bugzilla.mozilla.org/show_bug.cgi?id=184051
                event.stopPropagation();
                return false;
            }
            event.stopPropagation = stopPropagation;
            // Event data needs to be object to save reference to currentTarget getter
            var eventData = {
                dom: document
            };
            Object.defineProperty(event, 'currentTarget', {
                configurable: true,
                get: function get() {
                    return eventData.dom;
                }
            });
            dispatchEvents(event, event.target, isClick, name, eventData);
            return;
        };
        document.addEventListener(normalizeEventName(name), docEvent);
        return docEvent;
    }

    function isSameInnerHTML(dom, innerHTML) {
        var tempdom = document.createElement('i');
        tempdom.innerHTML = innerHTML;
        return tempdom.innerHTML === dom.innerHTML;
    }
    function isSamePropsInnerHTML(dom, props) {
        return Boolean(props && props.dangerouslySetInnerHTML && props.dangerouslySetInnerHTML.__html && isSameInnerHTML(dom, props.dangerouslySetInnerHTML.__html));
    }

    function triggerEventListener(props, methodName, e) {
        if (props[methodName]) {
            var listener = props[methodName];
            if (listener.event) {
                listener.event(listener.data, e);
            }
            else {
                listener(e);
            }
        }
        else {
            var nativeListenerName = methodName.toLowerCase();
            if (props[nativeListenerName]) {
                props[nativeListenerName](e);
            }
        }
    }
    function createWrappedFunction(methodName, applyValue) {
        var fnMethod = function (e) {
            e.stopPropagation();
            var vNode = this.$V;
            // If vNode is gone by the time event fires, no-op
            if (!vNode) {
                return;
            }
            var props = vNode.props || EMPTY_OBJ;
            var dom = vNode.dom;
            if (isString(methodName)) {
                triggerEventListener(props, methodName, e);
            }
            else {
                for (var i = 0; i < methodName.length; i++) {
                    triggerEventListener(props, methodName[i], e);
                }
            }
            if (isFunction(applyValue)) {
                var newVNode = this.$V;
                var newProps = newVNode.props || EMPTY_OBJ;
                applyValue(newProps, dom, false, newVNode);
            }
        };
        Object.defineProperty(fnMethod, 'wrapped', {
            configurable: false,
            enumerable: false,
            value: true,
            writable: false
        });
        return fnMethod;
    }

    function isCheckedType(type) {
        return type === 'checkbox' || type === 'radio';
    }
    var onTextInputChange = createWrappedFunction('onInput', applyValueInput);
    var wrappedOnChange = createWrappedFunction(['onClick', 'onChange'], applyValueInput);
    /* tslint:disable-next-line:no-empty */
    function emptywrapper(event) {
        event.stopPropagation();
    }
    emptywrapper.wrapped = true;
    function inputEvents(dom, nextPropsOrEmpty) {
        if (isCheckedType(nextPropsOrEmpty.type)) {
            dom.onchange = wrappedOnChange;
            dom.onclick = emptywrapper;
        }
        else {
            dom.oninput = onTextInputChange;
        }
    }
    function applyValueInput(nextPropsOrEmpty, dom) {
        var type = nextPropsOrEmpty.type;
        var value = nextPropsOrEmpty.value;
        var checked = nextPropsOrEmpty.checked;
        var multiple = nextPropsOrEmpty.multiple;
        var defaultValue = nextPropsOrEmpty.defaultValue;
        var hasValue = !isNullOrUndef(value);
        if (type && type !== dom.type) {
            dom.setAttribute('type', type);
        }
        if (!isNullOrUndef(multiple) && multiple !== dom.multiple) {
            dom.multiple = multiple;
        }
        if (!isNullOrUndef(defaultValue) && !hasValue) {
            dom.defaultValue = defaultValue + '';
        }
        if (isCheckedType(type)) {
            if (hasValue) {
                dom.value = value;
            }
            if (!isNullOrUndef(checked)) {
                dom.checked = checked;
            }
        }
        else {
            if (hasValue && dom.value !== value) {
                dom.defaultValue = value;
                dom.value = value;
            }
            else if (!isNullOrUndef(checked)) {
                dom.checked = checked;
            }
        }
    }

    function updateChildOptionGroup(vNode, value) {
        var type = vNode.type;
        if (type === 'optgroup') {
            var children = vNode.children;
            var childFlags = vNode.childFlags;
            if (childFlags & 12 /* MultipleChildren */) {
                for (var i = 0, len = children.length; i < len; i++) {
                    updateChildOption(children[i], value);
                }
            }
            else if (childFlags === 2 /* HasVNodeChildren */) {
                updateChildOption(children, value);
            }
        }
        else {
            updateChildOption(vNode, value);
        }
    }
    function updateChildOption(vNode, value) {
        var props = vNode.props || EMPTY_OBJ;
        var dom = vNode.dom;
        // we do this as multiple may have changed
        dom.value = props.value;
        if ((isArray(value) && value.indexOf(props.value) !== -1) || props.value === value) {
            dom.selected = true;
        }
        else if (!isNullOrUndef(value) || !isNullOrUndef(props.selected)) {
            dom.selected = props.selected || false;
        }
    }
    var onSelectChange = createWrappedFunction('onChange', applyValueSelect);
    function selectEvents(dom) {
        dom.onchange = onSelectChange;
    }
    function applyValueSelect(nextPropsOrEmpty, dom, mounting, vNode) {
        var multiplePropInBoolean = Boolean(nextPropsOrEmpty.multiple);
        if (!isNullOrUndef(nextPropsOrEmpty.multiple) && multiplePropInBoolean !== dom.multiple) {
            dom.multiple = multiplePropInBoolean;
        }
        var childFlags = vNode.childFlags;
        if ((childFlags & 1 /* HasInvalidChildren */) === 0) {
            var children = vNode.children;
            var value = nextPropsOrEmpty.value;
            if (mounting && isNullOrUndef(value)) {
                value = nextPropsOrEmpty.defaultValue;
            }
            if (childFlags & 12 /* MultipleChildren */) {
                for (var i = 0, len = children.length; i < len; i++) {
                    updateChildOptionGroup(children[i], value);
                }
            }
            else if (childFlags === 2 /* HasVNodeChildren */) {
                updateChildOptionGroup(children, value);
            }
        }
    }

    var onTextareaInputChange = createWrappedFunction('onInput', applyValueTextArea);
    var wrappedOnChange$1 = createWrappedFunction('onChange');
    function textAreaEvents(dom, nextPropsOrEmpty) {
        dom.oninput = onTextareaInputChange;
        if (nextPropsOrEmpty.onChange) {
            dom.onchange = wrappedOnChange$1;
        }
    }
    function applyValueTextArea(nextPropsOrEmpty, dom, mounting) {
        var value = nextPropsOrEmpty.value;
        var domValue = dom.value;
        if (isNullOrUndef(value)) {
            if (mounting) {
                var defaultValue = nextPropsOrEmpty.defaultValue;
                if (!isNullOrUndef(defaultValue) && defaultValue !== domValue) {
                    dom.defaultValue = defaultValue;
                    dom.value = defaultValue;
                }
            }
        }
        else if (domValue !== value) {
            /* There is value so keep it controlled */
            dom.defaultValue = value;
            dom.value = value;
        }
    }

    /**
     * There is currently no support for switching same input between controlled and nonControlled
     * If that ever becomes a real issue, then re design controlled elements
     * Currently user must choose either controlled or non-controlled and stick with that
     */
    function processElement(flags, vNode, dom, nextPropsOrEmpty, mounting, isControlled) {
        if (flags & 64 /* InputElement */) {
            applyValueInput(nextPropsOrEmpty, dom);
        }
        else if (flags & 256 /* SelectElement */) {
            applyValueSelect(nextPropsOrEmpty, dom, mounting, vNode);
        }
        else if (flags & 128 /* TextareaElement */) {
            applyValueTextArea(nextPropsOrEmpty, dom, mounting);
        }
        if (isControlled) {
            dom.$V = vNode;
        }
    }
    function addFormElementEventHandlers(flags, dom, nextPropsOrEmpty) {
        if (flags & 64 /* InputElement */) {
            inputEvents(dom, nextPropsOrEmpty);
        }
        else if (flags & 256 /* SelectElement */) {
            selectEvents(dom);
        }
        else if (flags & 128 /* TextareaElement */) {
            textAreaEvents(dom, nextPropsOrEmpty);
        }
    }
    function isControlledFormElement(nextPropsOrEmpty) {
        return nextPropsOrEmpty.type && isCheckedType(nextPropsOrEmpty.type) ? !isNullOrUndef(nextPropsOrEmpty.checked) : !isNullOrUndef(nextPropsOrEmpty.value);
    }

    function remove(vNode, parentDom) {
        unmount(vNode);
        if (parentDom && vNode.dom) {
            removeChild(parentDom, vNode.dom);
            // Let carbage collector free memory
            vNode.dom = null;
        }
    }
    function unmount(vNode) {
        var flags = vNode.flags;
        if (flags & 481 /* Element */) {
            var ref = vNode.ref;
            var props = vNode.props;
            if (isFunction(ref)) {
                ref(null);
            }
            var children = vNode.children;
            var childFlags = vNode.childFlags;
            if (childFlags & 12 /* MultipleChildren */) {
                unmountAllChildren(children);
            }
            else if (childFlags === 2 /* HasVNodeChildren */) {
                unmount(children);
            }
            if (!isNull(props)) {
                for (var name in props) {
                    switch (name) {
                        case 'onClick':
                        case 'onDblClick':
                        case 'onFocusIn':
                        case 'onFocusOut':
                        case 'onKeyDown':
                        case 'onKeyPress':
                        case 'onKeyUp':
                        case 'onMouseDown':
                        case 'onMouseMove':
                        case 'onMouseUp':
                        case 'onSubmit':
                        case 'onTouchEnd':
                        case 'onTouchMove':
                        case 'onTouchStart':
                            handleEvent(name, null, vNode.dom);
                            break;
                        default:
                            break;
                    }
                }
            }
        }
        else {
            var children$1 = vNode.children;
            // Safe guard for crashed VNode
            if (children$1) {
                if (flags & 14 /* Component */) {
                    var ref$1 = vNode.ref;
                    if (flags & 4 /* ComponentClass */) {
                        if (isFunction(children$1.componentWillUnmount)) {
                            children$1.componentWillUnmount();
                        }
                        if (isFunction(ref$1)) {
                            ref$1(null);
                        }
                        children$1.$UN = true;
                        if (children$1.$LI) {
                            unmount(children$1.$LI);
                        }
                    }
                    else {
                        if (!isNullOrUndef(ref$1) && isFunction(ref$1.onComponentWillUnmount)) {
                            ref$1.onComponentWillUnmount(vNode.dom, vNode.props || EMPTY_OBJ);
                        }
                        unmount(children$1);
                    }
                }
                else if (flags & 1024 /* Portal */) {
                    remove(children$1, vNode.type);
                }
            }
        }
    }
    function unmountAllChildren(children) {
        for (var i = 0, len = children.length; i < len; i++) {
            unmount(children[i]);
        }
    }
    function removeAllChildren(dom, children) {
        unmountAllChildren(children);
        dom.textContent = '';
    }

    function createLinkEvent(linkEvent, nextValue) {
        return function (e) {
            linkEvent(nextValue.data, e);
        };
    }
    function patchEvent(name, lastValue, nextValue, dom) {
        var nameLowerCase = name.toLowerCase();
        if (!isFunction(nextValue) && !isNullOrUndef(nextValue)) {
            var linkEvent = nextValue.event;
            if (linkEvent && isFunction(linkEvent)) {
                dom[nameLowerCase] = createLinkEvent(linkEvent, nextValue);
            }
        }
        else {
            var domEvent = dom[nameLowerCase];
            // if the function is wrapped, that means it's been controlled by a wrapper
            if (!domEvent || !domEvent.wrapped) {
                dom[nameLowerCase] = nextValue;
            }
        }
    }
    function getNumberStyleValue(style, value) {
        switch (style) {
            case 'animationIterationCount':
            case 'borderImageOutset':
            case 'borderImageSlice':
            case 'borderImageWidth':
            case 'boxFlex':
            case 'boxFlexGroup':
            case 'boxOrdinalGroup':
            case 'columnCount':
            case 'fillOpacity':
            case 'flex':
            case 'flexGrow':
            case 'flexNegative':
            case 'flexOrder':
            case 'flexPositive':
            case 'flexShrink':
            case 'floodOpacity':
            case 'fontWeight':
            case 'gridColumn':
            case 'gridRow':
            case 'lineClamp':
            case 'lineHeight':
            case 'opacity':
            case 'order':
            case 'orphans':
            case 'stopOpacity':
            case 'strokeDasharray':
            case 'strokeDashoffset':
            case 'strokeMiterlimit':
            case 'strokeOpacity':
            case 'strokeWidth':
            case 'tabSize':
            case 'widows':
            case 'zIndex':
            case 'zoom':
                return value;
            default:
                return value + 'px';
        }
    }
    // We are assuming here that we come from patchProp routine
    // -nextAttrValue cannot be null or undefined
    function patchStyle(lastAttrValue, nextAttrValue, dom) {
        var domStyle = dom.style;
        var style;
        var value;
        if (isString(nextAttrValue)) {
            domStyle.cssText = nextAttrValue;
            return;
        }
        if (!isNullOrUndef(lastAttrValue) && !isString(lastAttrValue)) {
            for (style in nextAttrValue) {
                // do not add a hasOwnProperty check here, it affects performance
                value = nextAttrValue[style];
                if (value !== lastAttrValue[style]) {
                    domStyle[style] = isNumber(value) ? getNumberStyleValue(style, value) : value;
                }
            }
            for (style in lastAttrValue) {
                if (isNullOrUndef(nextAttrValue[style])) {
                    domStyle[style] = '';
                }
            }
        }
        else {
            for (style in nextAttrValue) {
                value = nextAttrValue[style];
                domStyle[style] = isNumber(value) ? getNumberStyleValue(style, value) : value;
            }
        }
    }
    function patchProp(prop, lastValue, nextValue, dom, isSVG, hasControlledValue, lastVNode) {
        switch (prop) {
            case 'onClick':
            case 'onDblClick':
            case 'onFocusIn':
            case 'onFocusOut':
            case 'onKeyDown':
            case 'onKeyPress':
            case 'onKeyUp':
            case 'onMouseDown':
            case 'onMouseMove':
            case 'onMouseUp':
            case 'onSubmit':
            case 'onTouchEnd':
            case 'onTouchMove':
            case 'onTouchStart':
                handleEvent(prop, nextValue, dom);
                break;
            case 'children':
            case 'childrenType':
            case 'className':
            case 'defaultValue':
            case 'key':
            case 'multiple':
            case 'ref':
                break;
            case 'autoFocus':
                dom.autofocus = !!nextValue;
                break;
            case 'allowfullscreen':
            case 'autoplay':
            case 'capture':
            case 'checked':
            case 'controls':
            case 'default':
            case 'disabled':
            case 'hidden':
            case 'indeterminate':
            case 'loop':
            case 'muted':
            case 'novalidate':
            case 'open':
            case 'readOnly':
            case 'required':
            case 'reversed':
            case 'scoped':
            case 'seamless':
            case 'selected':
                dom[prop] = !!nextValue;
                break;
            case 'defaultChecked':
            case 'value':
            case 'volume':
                if (hasControlledValue && prop === 'value') {
                    return;
                }
                var value = isNullOrUndef(nextValue) ? '' : nextValue;
                if (dom[prop] !== value) {
                    dom[prop] = value;
                }
                break;
            case 'dangerouslySetInnerHTML':
                var lastHtml = (lastValue && lastValue.__html) || '';
                var nextHtml = (nextValue && nextValue.__html) || '';
                if (lastHtml !== nextHtml) {
                    if (!isNullOrUndef(nextHtml) && !isSameInnerHTML(dom, nextHtml)) {
                        if (!isNull(lastVNode)) {
                            if (lastVNode.childFlags & 12 /* MultipleChildren */) {
                                unmountAllChildren(lastVNode.children);
                            }
                            else if (lastVNode.childFlags === 2 /* HasVNodeChildren */) {
                                unmount(lastVNode.children);
                            }
                            lastVNode.children = null;
                            lastVNode.childFlags = 1 /* HasInvalidChildren */;
                        }
                        dom.innerHTML = nextHtml;
                    }
                }
                break;
            default:
                if (prop[0] === 'o' && prop[1] === 'n') {
                    patchEvent(prop, lastValue, nextValue, dom);
                }
                else if (isNullOrUndef(nextValue)) {
                    dom.removeAttribute(prop);
                }
                else if (prop === 'style') {
                    patchStyle(lastValue, nextValue, dom);
                }
                else if (isSVG && namespaces[prop]) {
                    // We optimize for isSVG being false
                    // If we end up in this path we can read property again
                    dom.setAttributeNS(namespaces[prop], prop, nextValue);
                }
                else {
                    dom.setAttribute(prop, nextValue);
                }
                break;
        }
    }
    function mountProps(vNode, flags, props, dom, isSVG) {
        var hasControlledValue = false;
        var isFormElement = (flags & 448 /* FormElement */) > 0;
        if (isFormElement) {
            hasControlledValue = isControlledFormElement(props);
            if (hasControlledValue) {
                addFormElementEventHandlers(flags, dom, props);
            }
        }
        for (var prop in props) {
            // do not add a hasOwnProperty check here, it affects performance
            patchProp(prop, null, props[prop], dom, isSVG, hasControlledValue, null);
        }
        if (isFormElement) {
            processElement(flags, vNode, dom, props, true, hasControlledValue);
        }
    }

    function createClassComponentInstance(vNode, Component, props, context) {
        var instance = new Component(props, context);
        vNode.children = instance;
        instance.$V = vNode;
        instance.$BS = false;
        instance.context = context;
        if (instance.props === EMPTY_OBJ) {
            instance.props = props;
        }
        instance.$UN = false;
        if (isFunction(instance.componentWillMount)) {
            instance.$BR = true;
            instance.componentWillMount();
            if (instance.$PSS) {
                var state = instance.state;
                var pending = instance.$PS;
                if (isNull(state)) {
                    instance.state = pending;
                }
                else {
                    for (var key in pending) {
                        state[key] = pending[key];
                    }
                }
                instance.$PSS = false;
                instance.$PS = null;
            }
            instance.$BR = false;
        }
        if (isFunction(options.beforeRender)) {
            options.beforeRender(instance);
        }
        var input = handleComponentInput(instance.render(props, instance.state, context), vNode);
        var childContext;
        if (isFunction(instance.getChildContext)) {
            childContext = instance.getChildContext();
        }
        if (isNullOrUndef(childContext)) {
            instance.$CX = context;
        }
        else {
            instance.$CX = combineFrom(context, childContext);
        }
        if (isFunction(options.afterRender)) {
            options.afterRender(instance);
        }
        instance.$LI = input;
        return instance;
    }
    function handleComponentInput(input, componentVNode) {
        if (isInvalid(input)) {
            input = createVoidVNode();
        }
        else if (isStringOrNumber(input)) {
            input = createTextVNode(input, null);
        }
        else {
            if (input.dom) {
                input = directClone(input);
            }
            if (input.flags & 14 /* Component */) {
                // if we have an input that is also a component, we run into a tricky situation
                // where the root vNode needs to always have the correct DOM entry
                // we can optimise this in the future, but this gets us out of a lot of issues
                input.parentVNode = componentVNode;
            }
        }
        return input;
    }

    function mount(vNode, parentDom, context, isSVG) {
        var flags = vNode.flags;
        if (flags & 481 /* Element */) {
            return mountElement(vNode, parentDom, context, isSVG);
        }
        if (flags & 14 /* Component */) {
            return mountComponent(vNode, parentDom, context, isSVG, (flags & 4 /* ComponentClass */) > 0);
        }
        if (flags & 512 /* Void */ || flags & 16 /* Text */) {
            return mountText(vNode, parentDom);
        }
        if (flags & 1024 /* Portal */) {
            mount(vNode.children, vNode.type, context, false);
            return (vNode.dom = mountText(createVoidVNode(), parentDom));
        }
    }
    function mountText(vNode, parentDom) {
        var dom = (vNode.dom = document.createTextNode(vNode.children));
        if (!isNull(parentDom)) {
            appendChild(parentDom, dom);
        }
        return dom;
    }
    function mountElement(vNode, parentDom, context, isSVG) {
        var flags = vNode.flags;
        var children = vNode.children;
        var props = vNode.props;
        var className = vNode.className;
        var ref = vNode.ref;
        var childFlags = vNode.childFlags;
        isSVG = isSVG || (flags & 32 /* SvgElement */) > 0;
        var dom = documentCreateElement(vNode.type, isSVG);
        vNode.dom = dom;
        if (!isNullOrUndef(className) && className !== '') {
            if (isSVG) {
                dom.setAttribute('class', className);
            }
            else {
                dom.className = className;
            }
        }
        if (!isNull(parentDom)) {
            appendChild(parentDom, dom);
        }
        if ((childFlags & 1 /* HasInvalidChildren */) === 0) {
            var childrenIsSVG = isSVG === true && vNode.type !== 'foreignObject';
            if (childFlags === 2 /* HasVNodeChildren */) {
                mount(children, dom, context, childrenIsSVG);
            }
            else if (childFlags & 12 /* MultipleChildren */) {
                mountArrayChildren(children, dom, context, childrenIsSVG);
            }
        }
        if (!isNull(props)) {
            mountProps(vNode, flags, props, dom, isSVG);
        }
        if (isFunction(ref)) {
            mountRef(dom, ref);
        }
        return dom;
    }
    function mountArrayChildren(children, dom, context, isSVG) {
        for (var i = 0, len = children.length; i < len; i++) {
            var child = children[i];
            if (!isNull(child.dom)) {
                children[i] = child = directClone(child);
            }
            mount(child, dom, context, isSVG);
        }
    }
    function mountComponent(vNode, parentDom, context, isSVG, isClass) {
        var dom;
        var type = vNode.type;
        var props = vNode.props || EMPTY_OBJ;
        var ref = vNode.ref;
        if (isClass) {
            var instance = createClassComponentInstance(vNode, type, props, context);
            vNode.dom = dom = mount(instance.$LI, null, instance.$CX, isSVG);
            mountClassComponentCallbacks(vNode, ref, instance);
            instance.$UPD = false;
        }
        else {
            var input = handleComponentInput(type(props, context), vNode);
            vNode.children = input;
            vNode.dom = dom = mount(input, null, context, isSVG);
            mountFunctionalComponentCallbacks(props, ref, dom);
        }
        if (!isNull(parentDom)) {
            appendChild(parentDom, dom);
        }
        return dom;
    }
    function createClassMountCallback(instance) {
        return function () {
            instance.componentDidMount();
        };
    }
    function mountClassComponentCallbacks(vNode, ref, instance) {
        if (isFunction(ref)) {
            ref(instance);
        }
        if (isFunction(instance.componentDidMount)) {
            LIFECYCLE.push(createClassMountCallback(instance));
        }
    }
    function createOnMountCallback(ref, dom, props) {
        return function () { return ref.onComponentDidMount(dom, props); };
    }
    function mountFunctionalComponentCallbacks(props, ref, dom) {
        if (!isNullOrUndef(ref)) {
            if (isFunction(ref.onComponentWillMount)) {
                ref.onComponentWillMount(props);
            }
            if (isFunction(ref.onComponentDidMount)) {
                LIFECYCLE.push(createOnMountCallback(ref, dom, props));
            }
        }
    }
    function mountRef(dom, value) {
        LIFECYCLE.push(function () { return value(dom); });
    }

    function hydrateComponent(vNode, dom, context, isSVG, isClass) {
        var type = vNode.type;
        var ref = vNode.ref;
        var props = vNode.props || EMPTY_OBJ;
        if (isClass) {
            var instance = createClassComponentInstance(vNode, type, props, context);
            var input = instance.$LI;
            hydrateVNode(input, dom, instance.$CX, isSVG);
            vNode.dom = input.dom;
            mountClassComponentCallbacks(vNode, ref, instance);
            instance.$UPD = false; // Mount finished allow going sync
        }
        else {
            var input$1 = handleComponentInput(type(props, context), vNode);
            hydrateVNode(input$1, dom, context, isSVG);
            vNode.children = input$1;
            vNode.dom = input$1.dom;
            mountFunctionalComponentCallbacks(props, ref, dom);
        }
    }
    function hydrateElement(vNode, dom, context, isSVG) {
        var children = vNode.children;
        var props = vNode.props;
        var className = vNode.className;
        var flags = vNode.flags;
        var ref = vNode.ref;
        isSVG = isSVG || (flags & 32 /* SvgElement */) > 0;
        if (dom.nodeType !== 1 || dom.tagName.toLowerCase() !== vNode.type) {
            var newDom = mountElement(vNode, null, context, isSVG);
            vNode.dom = newDom;
            replaceChild(dom.parentNode, newDom, dom);
        }
        else {
            vNode.dom = dom;
            var childNode = dom.firstChild;
            var childFlags = vNode.childFlags;
            if ((childFlags & 1 /* HasInvalidChildren */) === 0) {
                var nextSibling = null;
                while (childNode) {
                    nextSibling = childNode.nextSibling;
                    if (childNode.nodeType === 8) {
                        if (childNode.data === '!') {
                            dom.replaceChild(document.createTextNode(''), childNode);
                        }
                        else {
                            dom.removeChild(childNode);
                        }
                    }
                    childNode = nextSibling;
                }
                childNode = dom.firstChild;
                if (childFlags === 2 /* HasVNodeChildren */) {
                    if (isNull(childNode)) {
                        mount(children, dom, context, isSVG);
                    }
                    else {
                        nextSibling = childNode.nextSibling;
                        hydrateVNode(children, childNode, context, isSVG);
                        childNode = nextSibling;
                    }
                }
                else if (childFlags & 12 /* MultipleChildren */) {
                    for (var i = 0, len = children.length; i < len; i++) {
                        var child = children[i];
                        if (isNull(childNode)) {
                            mount(child, dom, context, isSVG);
                        }
                        else {
                            nextSibling = childNode.nextSibling;
                            hydrateVNode(child, childNode, context, isSVG);
                            childNode = nextSibling;
                        }
                    }
                }
                // clear any other DOM nodes, there should be only a single entry for the root
                while (childNode) {
                    nextSibling = childNode.nextSibling;
                    dom.removeChild(childNode);
                    childNode = nextSibling;
                }
            }
            else if (!isNull(dom.firstChild) && !isSamePropsInnerHTML(dom, props)) {
                dom.textContent = ''; // dom has content, but VNode has no children remove everything from DOM
                if (flags & 448 /* FormElement */) {
                    // If element is form element, we need to clear defaultValue also
                    dom.defaultValue = '';
                }
            }
            if (!isNull(props)) {
                mountProps(vNode, flags, props, dom, isSVG);
            }
            if (isNullOrUndef(className)) {
                if (dom.className !== '') {
                    dom.removeAttribute('class');
                }
            }
            else if (isSVG) {
                dom.setAttribute('class', className);
            }
            else {
                dom.className = className;
            }
            if (isFunction(ref)) {
                mountRef(dom, ref);
            }
        }
    }
    function hydrateText(vNode, dom) {
        if (dom.nodeType !== 3) {
            var newDom = mountText(vNode, null);
            vNode.dom = newDom;
            replaceChild(dom.parentNode, newDom, dom);
        }
        else {
            var text = vNode.children;
            if (dom.nodeValue !== text) {
                dom.nodeValue = text;
            }
            vNode.dom = dom;
        }
    }
    function hydrateVNode(vNode, dom, context, isSVG) {
        var flags = vNode.flags;
        if (flags & 14 /* Component */) {
            hydrateComponent(vNode, dom, context, isSVG, (flags & 4 /* ComponentClass */) > 0);
        }
        else if (flags & 481 /* Element */) {
            hydrateElement(vNode, dom, context, isSVG);
        }
        else if (flags & 16 /* Text */) {
            hydrateText(vNode, dom);
        }
        else if (flags & 512 /* Void */) {
            vNode.dom = dom;
        }
        else {
            throwError();
        }
    }
    function hydrate(input, parentDom, callback) {
        var dom = parentDom.firstChild;
        if (!isNull(dom)) {
            if (!isInvalid(input)) {
                hydrateVNode(input, dom, EMPTY_OBJ, false);
            }
            dom = parentDom.firstChild;
            // clear any other DOM nodes, there should be only a single entry for the root
            while ((dom = dom.nextSibling)) {
                parentDom.removeChild(dom);
            }
        }
        if (LIFECYCLE.length > 0) {
            callAll(LIFECYCLE);
        }
        parentDom.$V = input;
        if (isFunction(callback)) {
            callback();
        }
    }

    function replaceWithNewNode(lastNode, nextNode, parentDom, context, isSVG) {
        unmount(lastNode);
        replaceChild(parentDom, mount(nextNode, null, context, isSVG), lastNode.dom);
    }
    function patch(lastVNode, nextVNode, parentDom, context, isSVG) {
        if (lastVNode !== nextVNode) {
            var nextFlags = nextVNode.flags | 0;
            if (lastVNode.flags !== nextFlags || nextFlags & 2048 /* ReCreate */) {
                replaceWithNewNode(lastVNode, nextVNode, parentDom, context, isSVG);
            }
            else if (nextFlags & 481 /* Element */) {
                patchElement(lastVNode, nextVNode, parentDom, context, isSVG);
            }
            else if (nextFlags & 14 /* Component */) {
                patchComponent(lastVNode, nextVNode, parentDom, context, isSVG, (nextFlags & 4 /* ComponentClass */) > 0);
            }
            else if (nextFlags & 16 /* Text */) {
                patchText(lastVNode, nextVNode, parentDom);
            }
            else if (nextFlags & 512 /* Void */) {
                nextVNode.dom = lastVNode.dom;
            }
            else {
                // Portal
                patchPortal(lastVNode, nextVNode, context);
            }
        }
    }
    function patchPortal(lastVNode, nextVNode, context) {
        var lastContainer = lastVNode.type;
        var nextContainer = nextVNode.type;
        var nextChildren = nextVNode.children;
        patchChildren(lastVNode.childFlags, nextVNode.childFlags, lastVNode.children, nextChildren, lastContainer, context, false);
        nextVNode.dom = lastVNode.dom;
        if (lastContainer !== nextContainer && !isInvalid(nextChildren)) {
            var node = nextChildren.dom;
            lastContainer.removeChild(node);
            nextContainer.appendChild(node);
        }
    }
    function patchElement(lastVNode, nextVNode, parentDom, context, isSVG) {
        var nextTag = nextVNode.type;
        if (lastVNode.type !== nextTag) {
            replaceWithNewNode(lastVNode, nextVNode, parentDom, context, isSVG);
        }
        else {
            var dom = lastVNode.dom;
            var nextFlags = nextVNode.flags;
            var lastProps = lastVNode.props;
            var nextProps = nextVNode.props;
            var isFormElement = false;
            var hasControlledValue = false;
            var nextPropsOrEmpty;
            nextVNode.dom = dom;
            isSVG = isSVG || (nextFlags & 32 /* SvgElement */) > 0;
            // inlined patchProps  -- starts --
            if (lastProps !== nextProps) {
                var lastPropsOrEmpty = lastProps || EMPTY_OBJ;
                nextPropsOrEmpty = nextProps || EMPTY_OBJ;
                if (nextPropsOrEmpty !== EMPTY_OBJ) {
                    isFormElement = (nextFlags & 448 /* FormElement */) > 0;
                    if (isFormElement) {
                        hasControlledValue = isControlledFormElement(nextPropsOrEmpty);
                    }
                    for (var prop in nextPropsOrEmpty) {
                        var lastValue = lastPropsOrEmpty[prop];
                        var nextValue = nextPropsOrEmpty[prop];
                        if (lastValue !== nextValue) {
                            patchProp(prop, lastValue, nextValue, dom, isSVG, hasControlledValue, lastVNode);
                        }
                    }
                }
                if (lastPropsOrEmpty !== EMPTY_OBJ) {
                    for (var prop$1 in lastPropsOrEmpty) {
                        // do not add a hasOwnProperty check here, it affects performance
                        if (!nextPropsOrEmpty.hasOwnProperty(prop$1) && !isNullOrUndef(lastPropsOrEmpty[prop$1])) {
                            patchProp(prop$1, lastPropsOrEmpty[prop$1], null, dom, isSVG, hasControlledValue, lastVNode);
                        }
                    }
                }
            }
            var lastChildren = lastVNode.children;
            var nextChildren = nextVNode.children;
            var nextRef = nextVNode.ref;
            var lastClassName = lastVNode.className;
            var nextClassName = nextVNode.className;
            if (lastChildren !== nextChildren) {
                patchChildren(lastVNode.childFlags, nextVNode.childFlags, lastChildren, nextChildren, dom, context, isSVG && nextTag !== 'foreignObject');
            }
            if (isFormElement) {
                processElement(nextFlags, nextVNode, dom, nextPropsOrEmpty, false, hasControlledValue);
            }
            // inlined patchProps  -- ends --
            if (lastClassName !== nextClassName) {
                if (isNullOrUndef(nextClassName)) {
                    dom.removeAttribute('class');
                }
                else if (isSVG) {
                    dom.setAttribute('class', nextClassName);
                }
                else {
                    dom.className = nextClassName;
                }
            }
            if (isFunction(nextRef) && lastVNode.ref !== nextRef) {
                mountRef(dom, nextRef);
            }
        }
    }
    function patchChildren(lastChildFlags, nextChildFlags, lastChildren, nextChildren, parentDOM, context, isSVG) {
        switch (lastChildFlags) {
            case 2 /* HasVNodeChildren */:
                switch (nextChildFlags) {
                    case 2 /* HasVNodeChildren */:
                        patch(lastChildren, nextChildren, parentDOM, context, isSVG);
                        break;
                    case 1 /* HasInvalidChildren */:
                        remove(lastChildren, parentDOM);
                        break;
                    default:
                        remove(lastChildren, parentDOM);
                        mountArrayChildren(nextChildren, parentDOM, context, isSVG);
                        break;
                }
                break;
            case 1 /* HasInvalidChildren */:
                switch (nextChildFlags) {
                    case 2 /* HasVNodeChildren */:
                        mount(nextChildren, parentDOM, context, isSVG);
                        break;
                    case 1 /* HasInvalidChildren */:
                        break;
                    default:
                        mountArrayChildren(nextChildren, parentDOM, context, isSVG);
                        break;
                }
                break;
            default:
                if (nextChildFlags & 12 /* MultipleChildren */) {
                    var lastLength = lastChildren.length;
                    var nextLength = nextChildren.length;
                    // Fast path's for both algorithms
                    if (lastLength === 0) {
                        if (nextLength > 0) {
                            mountArrayChildren(nextChildren, parentDOM, context, isSVG);
                        }
                    }
                    else if (nextLength === 0) {
                        removeAllChildren(parentDOM, lastChildren);
                    }
                    else if (nextChildFlags === 8 /* HasKeyedChildren */ && lastChildFlags === 8 /* HasKeyedChildren */) {
                        patchKeyedChildren(lastChildren, nextChildren, parentDOM, context, isSVG, lastLength, nextLength);
                    }
                    else {
                        patchNonKeyedChildren(lastChildren, nextChildren, parentDOM, context, isSVG, lastLength, nextLength);
                    }
                }
                else if (nextChildFlags === 1 /* HasInvalidChildren */) {
                    removeAllChildren(parentDOM, lastChildren);
                }
                else {
                    removeAllChildren(parentDOM, lastChildren);
                    mount(nextChildren, parentDOM, context, isSVG);
                }
                break;
        }
    }
    function updateClassComponent(instance, nextState, nextVNode, nextProps, parentDom, context, isSVG, force, fromSetState) {
        var lastState = instance.state;
        var lastProps = instance.props;
        nextVNode.children = instance;
        var renderOutput;
        if (instance.$UN) {
            return;
        }
        if (lastProps !== nextProps || nextProps === EMPTY_OBJ) {
            if (!fromSetState && isFunction(instance.componentWillReceiveProps)) {
                instance.$BR = true;
                instance.componentWillReceiveProps(nextProps, context);
                // If instance component was removed during its own update do nothing...
                if (instance.$UN) {
                    return;
                }
                instance.$BR = false;
            }
            if (instance.$PSS) {
                nextState = combineFrom(nextState, instance.$PS);
                instance.$PSS = false;
                instance.$PS = null;
            }
        }
        /* Update if scu is not defined, or it returns truthy value or force */
        var hasSCU = Boolean(instance.shouldComponentUpdate);
        if (force || !hasSCU || (hasSCU && instance.shouldComponentUpdate(nextProps, nextState, context))) {
            if (isFunction(instance.componentWillUpdate)) {
                instance.$BS = true;
                instance.componentWillUpdate(nextProps, nextState, context);
                instance.$BS = false;
            }
            instance.props = nextProps;
            instance.state = nextState;
            instance.context = context;
            if (isFunction(options.beforeRender)) {
                options.beforeRender(instance);
            }
            renderOutput = instance.render(nextProps, nextState, context);
            if (isFunction(options.afterRender)) {
                options.afterRender(instance);
            }
            var didUpdate = renderOutput !== NO_OP;
            var childContext;
            if (isFunction(instance.getChildContext)) {
                childContext = instance.getChildContext();
            }
            if (isNullOrUndef(childContext)) {
                childContext = context;
            }
            else {
                childContext = combineFrom(context, childContext);
            }
            instance.$CX = childContext;
            if (didUpdate) {
                var lastInput = instance.$LI;
                var nextInput = (instance.$LI = handleComponentInput(renderOutput, nextVNode));
                patch(lastInput, nextInput, parentDom, childContext, isSVG);
                if (isFunction(instance.componentDidUpdate)) {
                    instance.componentDidUpdate(lastProps, lastState);
                }
            }
        }
        else {
            instance.props = nextProps;
            instance.state = nextState;
            instance.context = context;
        }
        nextVNode.dom = instance.$LI.dom;
    }
    function patchComponent(lastVNode, nextVNode, parentDom, context, isSVG, isClass) {
        var nextType = nextVNode.type;
        var lastKey = lastVNode.key;
        var nextKey = nextVNode.key;
        if (lastVNode.type !== nextType || lastKey !== nextKey) {
            replaceWithNewNode(lastVNode, nextVNode, parentDom, context, isSVG);
        }
        else {
            var nextProps = nextVNode.props || EMPTY_OBJ;
            if (isClass) {
                var instance = lastVNode.children;
                instance.$UPD = true;
                instance.$V = nextVNode;
                updateClassComponent(instance, instance.state, nextVNode, nextProps, parentDom, context, isSVG, false, false);
                instance.$UPD = false;
            }
            else {
                var shouldUpdate = true;
                var lastProps = lastVNode.props;
                var nextHooks = nextVNode.ref;
                var nextHooksDefined = !isNullOrUndef(nextHooks);
                var lastInput = lastVNode.children;
                nextVNode.dom = lastVNode.dom;
                nextVNode.children = lastInput;
                if (nextHooksDefined && isFunction(nextHooks.onComponentShouldUpdate)) {
                    shouldUpdate = nextHooks.onComponentShouldUpdate(lastProps, nextProps);
                }
                if (shouldUpdate !== false) {
                    if (nextHooksDefined && isFunction(nextHooks.onComponentWillUpdate)) {
                        nextHooks.onComponentWillUpdate(lastProps, nextProps);
                    }
                    var nextInput = nextType(nextProps, context);
                    if (nextInput !== NO_OP) {
                        nextInput = handleComponentInput(nextInput, nextVNode);
                        patch(lastInput, nextInput, parentDom, context, isSVG);
                        nextVNode.children = nextInput;
                        nextVNode.dom = nextInput.dom;
                        if (nextHooksDefined && isFunction(nextHooks.onComponentDidUpdate)) {
                            nextHooks.onComponentDidUpdate(lastProps, nextProps);
                        }
                    }
                }
                else if (lastInput.flags & 14 /* Component */) {
                    lastInput.parentVNode = nextVNode;
                }
            }
        }
    }
    function patchText(lastVNode, nextVNode, parentDom) {
        var nextText = nextVNode.children;
        var textNode = parentDom.firstChild;
        var dom;
        // Guard against external change on DOM node.
        if (isNull(textNode)) {
            parentDom.textContent = nextText;
            dom = parentDom.firstChild;
        }
        else {
            dom = lastVNode.dom;
            if (nextText !== lastVNode.children) {
                dom.nodeValue = nextText;
            }
        }
        nextVNode.dom = dom;
    }
    function patchNonKeyedChildren(lastChildren, nextChildren, dom, context, isSVG, lastChildrenLength, nextChildrenLength) {
        var commonLength = lastChildrenLength > nextChildrenLength ? nextChildrenLength : lastChildrenLength;
        var i = 0;
        var nextChild;
        var lastChild;
        for (; i < commonLength; i++) {
            nextChild = nextChildren[i];
            lastChild = lastChildren[i];
            if (nextChild.dom) {
                nextChild = nextChildren[i] = directClone(nextChild);
            }
            patch(lastChild, nextChild, dom, context, isSVG);
            lastChildren[i] = nextChild;
        }
        if (lastChildrenLength < nextChildrenLength) {
            for (i = commonLength; i < nextChildrenLength; i++) {
                nextChild = nextChildren[i];
                if (nextChild.dom) {
                    nextChild = nextChildren[i] = directClone(nextChild);
                }
                mount(nextChild, dom, context, isSVG);
            }
        }
        else if (lastChildrenLength > nextChildrenLength) {
            for (i = commonLength; i < lastChildrenLength; i++) {
                remove(lastChildren[i], dom);
            }
        }
    }
    function patchKeyedChildren(a, b, dom, context, isSVG, aLength, bLength) {
        var aEnd = aLength - 1;
        var bEnd = bLength - 1;
        var i;
        var j = 0;
        var aNode = a[j];
        var bNode = b[j];
        var nextPos;
        // Step 1
        // tslint:disable-next-line
        outer: {
            // Sync nodes with the same key at the beginning.
            while (aNode.key === bNode.key) {
                if (bNode.dom) {
                    b[j] = bNode = directClone(bNode);
                }
                patch(aNode, bNode, dom, context, isSVG);
                a[j] = bNode;
                j++;
                if (j > aEnd || j > bEnd) {
                    break outer;
                }
                aNode = a[j];
                bNode = b[j];
            }
            aNode = a[aEnd];
            bNode = b[bEnd];
            // Sync nodes with the same key at the end.
            while (aNode.key === bNode.key) {
                if (bNode.dom) {
                    b[bEnd] = bNode = directClone(bNode);
                }
                patch(aNode, bNode, dom, context, isSVG);
                a[aEnd] = bNode;
                aEnd--;
                bEnd--;
                if (j > aEnd || j > bEnd) {
                    break outer;
                }
                aNode = a[aEnd];
                bNode = b[bEnd];
            }
        }
        if (j > aEnd) {
            if (j <= bEnd) {
                nextPos = bEnd + 1;
                var nextNode = nextPos < bLength ? b[nextPos].dom : null;
                while (j <= bEnd) {
                    bNode = b[j];
                    if (bNode.dom) {
                        b[j] = bNode = directClone(bNode);
                    }
                    j++;
                    insertOrAppend(dom, mount(bNode, null, context, isSVG), nextNode);
                }
            }
        }
        else if (j > bEnd) {
            while (j <= aEnd) {
                remove(a[j++], dom);
            }
        }
        else {
            var aStart = j;
            var bStart = j;
            var aLeft = aEnd - j + 1;
            var bLeft = bEnd - j + 1;
            var sources = [];
            for (i = 0; i < bLeft; i++) {
                sources.push(0);
            }
            // Keep track if its possible to remove whole DOM using textContent = '';
            var canRemoveWholeContent = aLeft === aLength;
            var moved = false;
            var pos = 0;
            var patched = 0;
            // When sizes are small, just loop them through
            if (bLength < 4 || (aLeft | bLeft) < 32) {
                for (i = aStart; i <= aEnd; i++) {
                    aNode = a[i];
                    if (patched < bLeft) {
                        for (j = bStart; j <= bEnd; j++) {
                            bNode = b[j];
                            if (aNode.key === bNode.key) {
                                sources[j - bStart] = i + 1;
                                if (canRemoveWholeContent) {
                                    canRemoveWholeContent = false;
                                    while (i > aStart) {
                                        remove(a[aStart++], dom);
                                    }
                                }
                                if (pos > j) {
                                    moved = true;
                                }
                                else {
                                    pos = j;
                                }
                                if (bNode.dom) {
                                    b[j] = bNode = directClone(bNode);
                                }
                                patch(aNode, bNode, dom, context, isSVG);
                                patched++;
                                break;
                            }
                        }
                        if (!canRemoveWholeContent && j > bEnd) {
                            remove(aNode, dom);
                        }
                    }
                    else if (!canRemoveWholeContent) {
                        remove(aNode, dom);
                    }
                }
            }
            else {
                var keyIndex = {};
                // Map keys by their index
                for (i = bStart; i <= bEnd; i++) {
                    keyIndex[b[i].key] = i;
                }
                // Try to patch same keys
                for (i = aStart; i <= aEnd; i++) {
                    aNode = a[i];
                    if (patched < bLeft) {
                        j = keyIndex[aNode.key];
                        if (j !== void 0) {
                            if (canRemoveWholeContent) {
                                canRemoveWholeContent = false;
                                while (i > aStart) {
                                    remove(a[aStart++], dom);
                                }
                            }
                            bNode = b[j];
                            sources[j - bStart] = i + 1;
                            if (pos > j) {
                                moved = true;
                            }
                            else {
                                pos = j;
                            }
                            if (bNode.dom) {
                                b[j] = bNode = directClone(bNode);
                            }
                            patch(aNode, bNode, dom, context, isSVG);
                            patched++;
                        }
                        else if (!canRemoveWholeContent) {
                            remove(aNode, dom);
                        }
                    }
                    else if (!canRemoveWholeContent) {
                        remove(aNode, dom);
                    }
                }
            }
            // fast-path: if nothing patched remove all old and add all new
            if (canRemoveWholeContent) {
                removeAllChildren(dom, a);
                mountArrayChildren(b, dom, context, isSVG);
            }
            else {
                if (moved) {
                    var seq = lis_algorithm(sources);
                    j = seq.length - 1;
                    for (i = bLeft - 1; i >= 0; i--) {
                        if (sources[i] === 0) {
                            pos = i + bStart;
                            bNode = b[pos];
                            if (bNode.dom) {
                                b[pos] = bNode = directClone(bNode);
                            }
                            nextPos = pos + 1;
                            insertOrAppend(dom, mount(bNode, null, context, isSVG), nextPos < bLength ? b[nextPos].dom : null);
                        }
                        else if (j < 0 || i !== seq[j]) {
                            pos = i + bStart;
                            bNode = b[pos];
                            nextPos = pos + 1;
                            insertOrAppend(dom, bNode.dom, nextPos < bLength ? b[nextPos].dom : null);
                        }
                        else {
                            j--;
                        }
                    }
                }
                else if (patched !== bLeft) {
                    // when patched count doesn't match b length we need to insert those new ones
                    // loop backwards so we can use insertBefore
                    for (i = bLeft - 1; i >= 0; i--) {
                        if (sources[i] === 0) {
                            pos = i + bStart;
                            bNode = b[pos];
                            if (bNode.dom) {
                                b[pos] = bNode = directClone(bNode);
                            }
                            nextPos = pos + 1;
                            insertOrAppend(dom, mount(bNode, null, context, isSVG), nextPos < bLength ? b[nextPos].dom : null);
                        }
                    }
                }
            }
        }
    }
    // https://en.wikipedia.org/wiki/Longest_increasing_subsequence
    function lis_algorithm(arr) {
        var p = arr.slice();
        var result = [0];
        var i;
        var j;
        var u;
        var v;
        var c;
        var len = arr.length;
        for (i = 0; i < len; i++) {
            var arrI = arr[i];
            if (arrI !== 0) {
                j = result[result.length - 1];
                if (arr[j] < arrI) {
                    p[i] = j;
                    result.push(i);
                    continue;
                }
                u = 0;
                v = result.length - 1;
                while (u < v) {
                    c = ((u + v) / 2) | 0;
                    if (arr[result[c]] < arrI) {
                        u = c + 1;
                    }
                    else {
                        v = c;
                    }
                }
                if (arrI < arr[result[u]]) {
                    if (u > 0) {
                        p[i] = result[u - 1];
                    }
                    result[u] = i;
                }
            }
        }
        u = result.length;
        v = result[u - 1];
        while (u-- > 0) {
            result[u] = v;
            v = p[v];
        }
        return result;
    }

    var documentBody = isBrowser ? document.body : null;
    function render(input, parentDom, callback) {
        if (input === NO_OP) {
            return;
        }
        var rootInput = parentDom.$V;
        if (isNullOrUndef(rootInput)) {
            if (!isInvalid(input)) {
                if (input.dom) {
                    input = directClone(input);
                }
                if (isNull(parentDom.firstChild)) {
                    mount(input, parentDom, EMPTY_OBJ, false);
                    parentDom.$V = input;
                }
                else {
                    hydrate(input, parentDom);
                }
                rootInput = input;
            }
        }
        else {
            if (isNullOrUndef(input)) {
                remove(rootInput, parentDom);
                parentDom.$V = null;
            }
            else {
                if (input.dom) {
                    input = directClone(input);
                }
                patch(rootInput, input, parentDom, EMPTY_OBJ, false);
                rootInput = parentDom.$V = input;
            }
        }
        if (LIFECYCLE.length > 0) {
            callAll(LIFECYCLE);
        }
        if (isFunction(callback)) {
            callback();
        }
        if (isFunction(options.renderComplete)) {
            options.renderComplete(rootInput);
        }
        if (rootInput && rootInput.flags & 14 /* Component */) {
            return rootInput.children;
        }
    }

    var resolvedPromise = typeof Promise === 'undefined' ? null : Promise.resolve();
    // raf.bind(window) is needed to work around bug in IE10-IE11 strict mode (TypeError: Invalid calling object)
    var fallbackMethod = typeof requestAnimationFrame === 'undefined' ? setTimeout : requestAnimationFrame.bind(window);
    function nextTick(fn) {
        if (resolvedPromise) {
            return resolvedPromise.then(fn);
        }
        return fallbackMethod(fn);
    }
    function queueStateChanges(component, newState, callback, force) {
        if (isFunction(newState)) {
            newState = newState(component.state, component.props, component.context);
        }
        var pending = component.$PS;
        if (isNullOrUndef(pending)) {
            component.$PS = newState;
        }
        else {
            for (var stateKey in newState) {
                pending[stateKey] = newState[stateKey];
            }
        }
        if (!component.$PSS && !component.$BR) {
            if (!component.$UPD) {
                component.$PSS = true;
                component.$UPD = true;
                applyState(component, force, callback);
                component.$UPD = false;
            }
            else {
                // Async
                var queue = component.$QU;
                if (isNull(queue)) {
                    queue = component.$QU = [];
                    nextTick(promiseCallback(component, queue));
                }
                if (isFunction(callback)) {
                    queue.push(callback);
                }
            }
        }
        else {
            component.$PSS = true;
            if (component.$BR && isFunction(callback)) {
                LIFECYCLE.push(callback.bind(component));
            }
        }
    }
    function promiseCallback(component, queue) {
        return function () {
            component.$QU = null;
            component.$UPD = true;
            applyState(component, false, function () {
                for (var i = 0, len = queue.length; i < len; i++) {
                    queue[i].call(component);
                }
            });
            component.$UPD = false;
        };
    }
    function applyState(component, force, callback) {
        if (component.$UN) {
            return;
        }
        if (force || !component.$BR) {
            component.$PSS = false;
            var pendingState = component.$PS;
            var prevState = component.state;
            var nextState = combineFrom(prevState, pendingState);
            var props = component.props;
            var context = component.context;
            component.$PS = null;
            var vNode = component.$V;
            var lastInput = component.$LI;
            var parentDom = lastInput.dom && lastInput.dom.parentNode;
            updateClassComponent(component, nextState, vNode, props, parentDom, context, (vNode.flags & 32 /* SvgElement */) > 0, force, true);
            if (component.$UN) {
                return;
            }
            if ((component.$LI.flags & 1024 /* Portal */) === 0) {
                var dom = component.$LI.dom;
                while (!isNull((vNode = vNode.parentVNode))) {
                    if ((vNode.flags & 14 /* Component */) > 0) {
                        vNode.dom = dom;
                    }
                }
            }
            if (LIFECYCLE.length > 0) {
                callAll(LIFECYCLE);
            }
        }
        else {
            component.state = component.$PS;
            component.$PS = null;
        }
        if (isFunction(callback)) {
            callback.call(component);
        }
    }
    var Component = function Component(props, context) {
        this.state = null;
        // Internal properties
        this.$BR = false; // BLOCK RENDER
        this.$BS = true; // BLOCK STATE
        this.$PSS = false; // PENDING SET STATE
        this.$PS = null; // PENDING STATE (PARTIAL or FULL)
        this.$LI = null; // LAST INPUT
        this.$V = null; // VNODE
        this.$UN = false; // UNMOUNTED
        this.$CX = null; // CHILDCONTEXT
        this.$UPD = true; // UPDATING
        this.$QU = null; // QUEUE
        /** @type {object} */
        this.props = props || EMPTY_OBJ;
        /** @type {object} */
        this.context = context || EMPTY_OBJ; // context should not be mutable
    };
    Component.prototype.forceUpdate = function forceUpdate (callback) {
        if (this.$UN) {
            return;
        }
        // Do not allow double render during force update
        queueStateChanges(this, {}, callback, true);
    };
    Component.prototype.setState = function setState (newState, callback) {
        if (this.$UN) {
            return;
        }
        if (!this.$BS) {
            queueStateChanges(this, newState, callback, false);
        }
        else {
            return;
        }
    };
    // tslint:disable-next-line:no-empty
    Component.prototype.render = function render (nextProps, nextState, nextContext) { };



    var JSX = /*#__PURE__*/Object.freeze({

    });

    var ENTER = 12;
    var LEFT_ARROW = 37;
    var UP_ARROW = 38;
    var RIGHT_ARROW = 39;
    var DOWN_ARROW = 40;

    /**
     * Helper method to create an object for a new node.
     *
     * @private
     * @return {void}
     */
    function blankNode() {
        return {
            text: 'New Node',
            itree: {
                state: {
                    editing: true,
                    focused: true
                }
            }
        };
    }

    var classCallCheck = function (instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    };

    var createClass = function () {
      function defineProperties(target, props) {
        for (var i = 0; i < props.length; i++) {
          var descriptor = props[i];
          descriptor.enumerable = descriptor.enumerable || false;
          descriptor.configurable = true;
          if ("value" in descriptor) descriptor.writable = true;
          Object.defineProperty(target, descriptor.key, descriptor);
        }
      }

      return function (Constructor, protoProps, staticProps) {
        if (protoProps) defineProperties(Constructor.prototype, protoProps);
        if (staticProps) defineProperties(Constructor, staticProps);
        return Constructor;
      };
    }();

    var _extends = Object.assign || function (target) {
      for (var i = 1; i < arguments.length; i++) {
        var source = arguments[i];

        for (var key in source) {
          if (Object.prototype.hasOwnProperty.call(source, key)) {
            target[key] = source[key];
          }
        }
      }

      return target;
    };

    var inherits = function (subClass, superClass) {
      if (typeof superClass !== "function" && superClass !== null) {
        throw new TypeError("Super expression must either be null or a function, not " + typeof superClass);
      }

      subClass.prototype = Object.create(superClass && superClass.prototype, {
        constructor: {
          value: subClass,
          enumerable: false,
          writable: true,
          configurable: true
        }
      });
      if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass;
    };

    var possibleConstructorReturn = function (self, call) {
      if (!self) {
        throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
      }

      return call && (typeof call === "object" || typeof call === "function") ? call : self;
    };

    var Checkbox = function (_Component) {
        inherits(Checkbox, _Component);

        function Checkbox() {
            classCallCheck(this, Checkbox);
            return possibleConstructorReturn(this, (Checkbox.__proto__ || Object.getPrototypeOf(Checkbox)).apply(this, arguments));
        }

        createClass(Checkbox, [{
            key: 'click',
            value: function click(event) {
                var _this2 = this;

                // Define our default handler
                var handler = function handler() {
                    _this2.props.node.toggleCheck();
                };

                // Emit an event with our forwarded MouseEvent, node, and default handler
                this.props.dom._tree.emit('node.click', event, this.props.node, handler);

                // Unless default is prevented, auto call our default handler
                if (!event.treeDefaultPrevented) {
                    handler();
                }
            }
        }, {
            key: 'render',
            value: function render$$1() {
                return createVNode(64, 'input', null, null, 1, {
                    'checked': this.props.checked,
                    'indeterminate': this.props.indeterminate,
                    'onClick': this.click.bind(this),
                    'type': 'checkbox'
                });
            }
        }]);
        return Checkbox;
    }(Component);

    /**
     * Utility method for parsing and merging custom class names.
     *
     * @private
     * @param {TreeNode} node Node object.
     * @param {string} type 'li' or 'a' attribute object type.
     * @return {Array} Processed class names
     */
    var classlist = (function (node) {
        var type = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'li';

        var nodeAttrs = node.itree[type].attributes;
        var classNames = [];

        // Append any custom class names
        var customClasses = nodeAttrs.class || nodeAttrs.className;

        // Support callbacks
        if (_.isFunction(customClasses)) {
            customClasses = customClasses(node);
        }

        // Convert custom classes into an array and concat
        if (!_.isEmpty(customClasses)) {
            if (_.isString(customClasses)) {
                // Support periods for backwards compat with hyperscript-formatted classes
                classNames = classNames.concat(customClasses.split(/[\s\.]+/));
            } else if (_.isArray(customClasses)) {
                classNames = classNames.concat(customClasses);
            }
        }

        return classNames;
    });

    var EditToolbar = function (_Component) {
        inherits(EditToolbar, _Component);

        function EditToolbar() {
            classCallCheck(this, EditToolbar);
            return possibleConstructorReturn(this, (EditToolbar.__proto__ || Object.getPrototypeOf(EditToolbar)).apply(this, arguments));
        }

        createClass(EditToolbar, [{
            key: 'shouldComponentUpdate',
            value: function shouldComponentUpdate() {
                return false;
            }
        }, {
            key: 'add',
            value: function add(event) {
                event.stopPropagation();

                this.props.node.addChild(blankNode());
                this.props.node.expand();
            }
        }, {
            key: 'edit',
            value: function edit(event) {
                event.stopPropagation();

                this.props.node.toggleEditing();
            }
        }, {
            key: 'remove',
            value: function remove(event) {
                event.stopPropagation();

                this.props.node.remove();
            }
        }, {
            key: 'render',
            value: function render$$1() {
                var buttons = [];

                if (this.props.dom._tree.config.editing.edit) {
                    buttons.push(createVNode(1, 'a', 'btn icon icon-pencil', null, 1, {
                        'onclick': this.edit.bind(this),
                        'title': 'Edit this node'
                    }));
                }

                if (this.props.dom._tree.config.editing.add) {
                    buttons.push(createVNode(1, 'a', 'btn icon icon-plus', null, 1, {
                        'onclick': this.add.bind(this),
                        'title': 'Add a child node'
                    }));
                }

                if (this.props.dom._tree.config.editing.remove) {
                    buttons.push(createVNode(1, 'a', 'btn icon icon-minus', null, 1, {
                        'onclick': this.remove.bind(this),
                        'title': 'Remove this node'
                    }));
                }

                return createVNode(1, 'span', 'btn-group', buttons, 0);
            }
        }]);
        return EditToolbar;
    }(Component);

    var EmptyList = function (_Component) {
        inherits(EmptyList, _Component);

        function EmptyList() {
            classCallCheck(this, EmptyList);
            return possibleConstructorReturn(this, (EmptyList.__proto__ || Object.getPrototypeOf(EmptyList)).apply(this, arguments));
        }

        createClass(EmptyList, [{
            key: 'render',
            value: function render$$1() {
                return createVNode(1, 'ol', null, createVNode(1, 'li', 'leaf', createVNode(1, 'span', 'title icon icon-file-empty empty', this.props.text, 0), 2), 2);
            }
        }]);
        return EmptyList;
    }(Component);

    /**
     * Compares all keys on the given state. Returns true if any difference exists.
     *
     * @private
     * @category DOM
     * @param {object} previousState Previous state.
     * @param {object} currentState  Current state.
     * @return {boolean} Difference was found.
     */
    function stateComparator(previousState, currentState) {
        // Always treat dirty flag as a state difference
        var isDirty = currentState.dirty || false;

        if (!isDirty) {
            _.each(Object.keys(currentState), function (key) {
                if (key !== 'dirty' && currentState[key] !== previousState[key]) {
                    isDirty = true;
                    return false;
                }
            });
        }

        return isDirty;
    }

    var EditForm = function (_Component) {
        inherits(EditForm, _Component);

        function EditForm(props) {
            classCallCheck(this, EditForm);

            var _this = possibleConstructorReturn(this, (EditForm.__proto__ || Object.getPrototypeOf(EditForm)).call(this, props));

            _this.state = _this.getStateFromNodes(props.node);
            return _this;
        }

        createClass(EditForm, [{
            key: 'getStateFromNodes',
            value: function getStateFromNodes(node) {
                return {
                    text: node.text
                };
            }
        }, {
            key: 'componentWillReceiveProps',
            value: function componentWillReceiveProps(data) {
                this.setState(this.getStateFromNodes(data.node));
            }
        }, {
            key: 'shouldComponentUpdate',
            value: function shouldComponentUpdate(nextProps, nextState) {
                return stateComparator(this.state, nextState);
            }
        }, {
            key: 'click',
            value: function click(event) {
                var _this2 = this;

                // Define our default handler
                var handler = function handler() {
                    _this2.props.node.toggleCheck();
                };

                // Emit an event with our forwarded MouseEvent, node, and default handler
                this.props.dom._tree.emit('node.click', event, this.props.node, handler);

                // Unless default is prevented, auto call our default handler
                if (!event.treeDefaultPrevented) {
                    handler();
                }
            }
        }, {
            key: 'keypress',
            value: function keypress(event) {
                if (event.which === ENTER) {
                    return this.save();
                }
            }
        }, {
            key: 'input',
            value: function input(event) {
                this.setState({
                    text: event.target.value
                });
            }
        }, {
            key: 'cancel',
            value: function cancel(event) {
                if (event) {
                    event.stopPropagation();
                }

                this.props.node.toggleEditing();
            }
        }, {
            key: 'save',
            value: function save(event) {
                if (event) {
                    event.stopPropagation();
                }

                // Cache current text
                var originalText = this.props.node.text;
                var newText = this.ref.value;

                // Update the text
                this.props.node.set('text', newText);

                // Disable editing and update
                this.props.node.state('editing', false);
                this.props.node.markDirty();
                this.props.dom._tree.applyChanges();

                if (originalText !== newText) {
                    this.props.dom._tree.emit('node.edited', this.props.node, originalText, newText);
                }
            }
        }, {
            key: 'render',
            value: function render$$1() {
                var _this3 = this;

                return createVNode(1, 'form', null, [createVNode(64, 'input', null, null, 1, {
                    'onClick': function onClick(event) {
                        return event.stopPropagation;
                    },
                    'onInput': this.input.bind(this),
                    'onKeyPress': this.keypress.bind(this),
                    'value': this.state.text
                }, null, function (elem) {
                    return _this3.ref = elem;
                }), createVNode(1, 'span', 'btn-group', [createVNode(1, 'button', 'btn icon icon-check', null, 1, {
                    'onClick': this.save.bind(this),
                    'title': 'Save',
                    'type': 'button'
                }), createVNode(1, 'button', 'btn icon icon-cross', null, 1, {
                    'onClick': this.cancel.bind(this),
                    'title': 'Cancel',
                    'type': 'button'
                })], 4)], 4, {
                    'onsubmit': function onsubmit(event) {
                        return event.preventDefault;
                    }
                });
            }
        }]);
        return EditForm;
    }(Component);

    var NodeAnchor = function (_Component) {
        inherits(NodeAnchor, _Component);

        function NodeAnchor() {
            classCallCheck(this, NodeAnchor);
            return possibleConstructorReturn(this, (NodeAnchor.__proto__ || Object.getPrototypeOf(NodeAnchor)).apply(this, arguments));
        }

        createClass(NodeAnchor, [{
            key: 'blur',
            value: function blur() {
                this.props.node.blur();
            }
        }, {
            key: 'click',
            value: function click(event) {
                var _this2 = this;

                var _props = this.props,
                    node = _props.node,
                    dom = _props.dom;

                // Define our default handler

                var handler = function handler() {
                    event.preventDefault();

                    if (_this2.props.editing) {
                        return;
                    }

                    if (event.metaKey || event.ctrlKey || event.shiftKey) {
                        dom._tree.disableDeselection();
                    }

                    if (event.shiftKey) {
                        dom.clearSelection();

                        var selected = dom._tree.lastSelectedNode();
                        if (selected) {
                            dom._tree.selectBetween.apply(dom._tree, dom._tree.boundingNodes(selected, node));
                        }
                    }

                    if (node.selected()) {
                        if (!dom._tree.config.selection.disableDirectDeselection) {
                            node.deselect();
                        }
                    } else {
                        node.select();
                    }

                    dom._tree.enableDeselection();
                };

                // Emit an event with our forwarded MouseEvent, node, and default handler
                dom._tree.emit('node.click', event, node, handler);

                // Unless default is prevented, auto call our default handler
                if (!event.treeDefaultPrevented) {
                    handler();
                }
            }
        }, {
            key: 'contextMenu',
            value: function contextMenu(event) {
                var _props2 = this.props,
                    node = _props2.node,
                    dom = _props2.dom;


                dom._tree.emit('node.contextmenu', event, node);
            }
        }, {
            key: 'dblclick',
            value: function dblclick(event) {
                var _props3 = this.props,
                    node = _props3.node,
                    dom = _props3.dom;

                // Define our default handler

                var handler = function handler() {
                    // Clear text selection which occurs on double click
                    dom.clearSelection();

                    node.toggleCollapse();
                };

                // Emit an event with our forwarded MouseEvent, node, and default handler
                dom._tree.emit('node.dblclick', event, node, handler);

                // Unless default is prevented, auto call our default handler
                if (!event.treeDefaultPrevented) {
                    handler();
                }
            }
        }, {
            key: 'focus',
            value: function focus(event) {
                this.props.node.focus(event);
            }
        }, {
            key: 'mousedown',
            value: function mousedown() {
                if (this.props.dom.isDragDropEnabled) {
                    this.props.dom.isMouseHeld = true;
                }
            }
        }, {
            key: 'render',
            value: function render$$1() {
                var node = this.props.node;
                var attributes = _.clone(node.itree.a.attributes) || {};
                attributes.tabindex = 1;
                attributes.unselectable = 'on';

                // Build and set classnames
                var classNames = classlist(node, 'a').concat(['title', 'icon']);

                // Royale - Allow icon + checkbox
                //if (!this.props.dom.config.showCheckboxes) {
                    var folder = this.props.expanded ? 'icon-folder-open' : 'icon-folder';
                    classNames.push(node.itree.icon || (this.props.hasOrWillHaveChildren ? folder : 'icon-file-empty'));
                //}

                attributes.class = attributes.className = classNames.join(' ');

                var content = node.text;
                if (node.editing()) {
                    content = createComponentVNode(2, EditForm, {
                        'dom': this.props.dom,
                        'node': this.props.node
                    });
                }

                return normalizeProps(createVNode(1, 'a', null, content, 0, _extends({
                    'data-uid': node.id,
                    'onBlur': this.blur.bind(this),
                    'onClick': this.click.bind(this),
                    'onContextMenu': this.contextMenu.bind(this),
                    'onDblClick': this.dblclick.bind(this),
                    'onFocus': this.focus.bind(this),
                    'onMouseDown': this.mousedown.bind(this)
                }, attributes)));
            }
        }]);
        return NodeAnchor;
    }(Component);

    var ToggleAnchor = function (_Component) {
        inherits(ToggleAnchor, _Component);

        function ToggleAnchor() {
            classCallCheck(this, ToggleAnchor);
            return possibleConstructorReturn(this, (ToggleAnchor.__proto__ || Object.getPrototypeOf(ToggleAnchor)).apply(this, arguments));
        }

        createClass(ToggleAnchor, [{
            key: 'className',
            value: function className() {
                return 'toggle icon ' + (this.props.collapsed ? 'icon-expand' : 'icon-collapse');
            }
        }, {
            key: 'render',
            value: function render$$1() {
                return createVNode(1, 'a', this.className(), null, 1, {
                    'onClick': this.props.node.toggleCollapse.bind(this.props.node)
                });
            }
        }]);
        return ToggleAnchor;
    }(Component);

    var ListItem = function (_Component) {
        inherits(ListItem, _Component);

        function ListItem(props) {
            classCallCheck(this, ListItem);

            var _this = possibleConstructorReturn(this, (ListItem.__proto__ || Object.getPrototypeOf(ListItem)).call(this, props));

            _this.state = _this.stateFromNode(props.node);
            return _this;
        }

        createClass(ListItem, [{
            key: 'stateFromNode',
            value: function stateFromNode(node) {
                return {
                    dirty: node.itree.dirty
                };
            }
        }, {
            key: 'componentWillReceiveProps',
            value: function componentWillReceiveProps(data) {
                this.setState(this.stateFromNode(data.node));
            }
        }, {
            key: 'shouldComponentUpdate',
            value: function shouldComponentUpdate(nextProps, nextState) {
                return nextState.dirty;
            }
        }, {
            key: 'getAttributes',
            value: function getAttributes() {
                var node = this.props.node;
                var attributes = _.clone(node.itree.li.attributes) || {};
                attributes.class = attributes.className = this.getClassNames();

                // Force internal-use attributes
                attributes['data-uid'] = node.id;

                // Allow drag and drop?
                if (this.props.dom.config.dragAndDrop.enabled) {
                    attributes.draggable = node.state('draggable');
                    attributes.onDragEnd = this.onDragEnd.bind(this);
                    attributes.onDragEnter = this.onDragEnter.bind(this);
                    attributes.onDragLeave = this.onDragLeave.bind(this);
                    attributes.onDragStart = this.onDragStart.bind(this);

                    // Are we a valid drop target?
                    if (node.state('drop-target')) {
                        attributes.onDragOver = this.onDragOver.bind(this);
                        attributes.onDrop = this.onDrop.bind(this);
                    } else {
                        // Setting to null forces removal of prior listeners
                        attributes.onDragOver = null;
                        attributes.onDrop = null;
                    }
                }

                return attributes;
            }
        }, {
            key: 'getClassNames',
            value: function getClassNames() {
                var node = this.props.node;
                var state = node.itree.state;

                // Set state classnames
                var classNames = classlist(node);

                // https://jsperf.com/object-keys-vs-each
                _.each(Object.keys(state), function (key) {
                    if (state[key]) {
                        classNames.push(key);
                    }
                });

                // Inverse and additional classes
                if (!node.hidden() && node.removed()) {
                    classNames.push('hidden');
                }

                if (node.expanded()) {
                    classNames.push('expanded');
                }

                classNames.push(node.hasOrWillHaveChildren() ? 'folder' : 'leaf');

                return classNames.join(' ');
            }
        }, {
            key: 'getTargetDirection',
            value: function getTargetDirection(event, elem) {
                var clientY = event.clientY;
                var targetRect = elem.getBoundingClientRect();

                var yThresholdForAbove = targetRect.top + targetRect.height / 3;
                var yThresholdForBelow = targetRect.bottom - targetRect.height / 3;

                var dir = 0;

                if (clientY <= yThresholdForAbove) {
                    dir = -1;
                } else if (clientY >= yThresholdForBelow) {
                    dir = 1;
                }

                return dir;
            }
        }, {
            key: 'onDragStart',
            value: function onDragStart(event) {
                event.stopPropagation();

                event.dataTransfer.effectAllowed = 'move';
                event.dataTransfer.dropEffect = 'move';

                var node = this.props.node;

                // Due to "protected" mode we can't access any DataTransfer data
                // during the dragover event, yet we still need to validate this node with the target
                this.props.dom._activeDragNode = node;

                event.dataTransfer.setData('treeId', node.tree().id);
                event.dataTransfer.setData('nodeId', node.id);

                // Disable self and children as drop targets
                node.state('drop-target', false);

                if (node.hasChildren()) {
                    node.children.stateDeep('drop-target', false);
                }

                // If we should validate all nodes as potential drop targets on drag start
                if (this.props.dom.config.dragAndDrop.validateOn === 'dragstart') {
                    var validator = this.props.dom.config.dragAndDrop.validate;
                    var validateCallable = _.isFunction(validator);

                    // Validate with a custom recursor because a return of "false"
                    // should mean "do not descend" rather than "stop iterating"
                    var recursor = function recursor(obj, iteratee) {
                        if (InspireTree.isTreeNodes(obj)) {
                            _.each(obj, function (n) {
                                recursor(n, iteratee);
                            });
                        } else if (InspireTree.isTreeNode(obj)) {
                            if (iteratee(obj) !== false && obj.hasChildren()) {
                                recursor(obj.children, iteratee);
                            }
                        }
                    };

                    this.props.dom._tree.batch();

                    recursor(this.props.dom._tree.model, function (n) {
                        var valid = n.id !== node.id;

                        // Ensure target node isn't a descendant
                        if (valid) {
                            valid = !n.hasAncestor(node);
                        }

                        // If still valid and user has additional validation...
                        if (valid && validateCallable) {
                            valid = validator(node, n);
                        }

                        // Set state
                        n.state('drop-target', valid);

                        return valid;
                    });

                    this.props.dom._tree.end();
                }

                this.props.dom._tree.emit('node.dragstart', event);
            }
        }, {
            key: 'onDragEnd',
            value: function onDragEnd(event) {
                event.preventDefault();
                event.stopPropagation();

                this.unhighlightTarget();

                this.props.dom._tree.emit('node.dragend', event);
            }
        }, {
            key: 'onDragEnter',
            value: function onDragEnter(event) {
                event.preventDefault();
                event.stopPropagation();

                // Nodes already within parents don't trigger enter/leave events on their ancestors
                this.props.node.recurseUp(this.unhighlightTarget);

                // Set drag target state
                this.props.node.state('drag-targeting', true);

                this.props.dom._tree.emit('node.dragenter', event);
            }
        }, {
            key: 'onDragLeave',
            value: function onDragLeave(event) {
                event.preventDefault();
                event.stopPropagation();

                this.unhighlightTarget();

                this.props.dom._tree.emit('node.dragleave', event);
            }
        }, {
            key: 'onDragOver',
            value: function onDragOver(event) {
                event.preventDefault();
                event.stopPropagation();

                var dragNode = this.props.dom._activeDragNode;
                var node = this.props.node;

                // Event.target doesn't always match the element we need to calculate
                var dir = this.getTargetDirection(event, node.itree.ref.querySelector('a'));

                if (this.props.dom.config.dragAndDrop.validateOn === 'dragover') {
                    // Validate drop target
                    var validator = this.props.dom.config.dragAndDrop.validate;
                    var validateCallable = _.isFunction(validator);

                    var valid = dragNode.id !== node.id;

                    if (valid) {
                        valid = !node.hasAncestor(dragNode);
                    }

                    if (valid && validateCallable) {
                        valid = validator(dragNode, node, dir);
                    }

                    // Set state
                    node.state('drop-target', valid);
                    this.props.dom._tree.applyChanges();

                    if (!valid) {
                        return;
                    }
                }

                // Set drag target states
                this.props.dom._tree.batch();
                node.state('drag-targeting', true);
                node.state('drag-targeting-above', dir === -1);
                node.state('drag-targeting-below', dir === 1);
                node.state('drag-targeting-insert', dir === 0);
                this.props.dom._tree.end();

                this.props.dom._tree.emit('node.dragover', event, dir);
            }
        }, {
            key: 'onDrop',
            value: function onDrop(event) {
                event.preventDefault();
                event.stopPropagation();

                // Always unhighlight target
                this.unhighlightTarget();

                // Get the data from our transfer
                var treeId = event.dataTransfer.getData('treeId');
                var nodeId = event.dataTransfer.getData('nodeId');

                // Find the drop target
                var targetNode = this.props.node;

                // Clear cache
                this.props.dom._activeDragNode = null;

                // Determine the insert direction (calc before removing source node, which modifies the DOM)
                var dir = this.getTargetDirection(event, event.target);

                var sourceTree = void 0;
                if (treeId === this.props.dom._tree.id) {
                    sourceTree = this.props.dom._tree;
                } else if (treeId) {
                    sourceTree = document.querySelector('[data-uid="' + treeId + '"]').inspireTree;
                }

                // Only source/handle node if it's a node that was dropped
                var newNode = void 0,
                    newIndex = void 0;
                if (sourceTree) {
                    var node = sourceTree.node(nodeId);
                    node.state('drop-target', true);

                    var exported = node.remove(true);

                    // Get the index of the target node
                    var targetIndex = targetNode.context().indexOf(targetNode);

                    if (dir === 0) {
                        // Add as a child
                        newNode = targetNode.addChild(exported);

                        // Cache the new index
                        newIndex = targetNode.children.indexOf(newNode);

                        // Auto-expand
                        targetNode.expand();
                    } else {
                        // Determine the new index
                        newIndex = dir === 1 ? ++targetIndex : targetIndex;

                        // Insert and cache the node
                        newNode = targetNode.context().insertAt(newIndex, exported);
                    }
                }

                this.props.dom._tree.emit('node.drop', event, newNode, targetNode, newIndex);
            }
        }, {
            key: 'unhighlightTarget',
            value: function unhighlightTarget(node) {
                (node || this.props.node).states(['drag-targeting', 'drag-targeting-above', 'drag-targeting-below', 'drag-targeting-insert'], false);
            }
        }, {
            key: 'renderCheckbox',
            value: function renderCheckbox() {
                var node = this.props.node;

                if (this.props.dom.config.showCheckboxes) {
                    return createComponentVNode(2, Checkbox, {
                        'checked': node.checked(),
                        'dom': this.props.dom,
                        'indeterminate': node.indeterminate(),
                        'node': node
                    });
                }
            }
        }, {
            key: 'renderChildren',
            value: function renderChildren() {
                var _props = this.props,
                    node = _props.node,
                    dom = _props.dom;


                if (node.hasChildren()) {
                    var nodes = node.children;
                    var loading = dom.loading;
                    var pagination = nodes.pagination();

                    return createComponentVNode(2, List, {
                        'context': node,
                        'dom': dom,
                        'limit': pagination.limit,
                        'loading': loading,
                        'nodes': nodes,
                        'total': pagination.total
                    });
                } else if (this.props.dom.isDynamic && node.children) {
                    if (!node.hasLoadedChildren()) {
                        return createComponentVNode(2, EmptyList, {
                            'text': 'Loading...'
                        });
                    } else {
                        return createComponentVNode(2, EmptyList, {
                            'text': 'No Results'
                        });
                    }
                }
            }
        }, {
            key: 'renderEditToolbar',
            value: function renderEditToolbar() {
                // @todo fix this boolean
                if (this.props.dom._tree.config.editing.edit && !this.props.node.editing()) {
                    return createComponentVNode(2, EditToolbar, {
                        'dom': this.props.dom,
                        'node': this.props.node
                    });
                }
            }
        }, {
            key: 'renderToggle',
            value: function renderToggle() {
                var node = this.props.node;
                var hasVisibleChildren = !this.props.dom.isDynamic ? node.hasVisibleChildren() : Boolean(node.children);

                if (hasVisibleChildren) {
                    return createComponentVNode(2, ToggleAnchor, {
                        'collapsed': node.collapsed(),
                        'node': node
                    });
                }
            }
        }, {
            key: 'render',
            value: function render$$1() {
                var _this2 = this;

                var node = this.props.node;

                var li = normalizeProps(createVNode(1, 'li', null, [this.renderEditToolbar(), createVNode(1, 'div', 'title-wrap', [this.renderToggle(), this.renderCheckbox(), createComponentVNode(2, NodeAnchor, {
                    'dom': this.props.dom,
                    'editing': node.editing(),
                    'expanded': node.expanded(),
                    'hasOrWillHaveChildren': node.hasOrWillHaveChildren(),
                    'node': node,
                    'text': node.text
                })], 0), createVNode(1, 'div', 'wholerow'), this.renderChildren()], 0, _extends({}, this.getAttributes()), null, function (elem) {
                    return _this2.node = _this2.props.node.itree.ref = elem;
                }));

                // Clear dirty bool only after everything has been generated (and states set)
                this.props.node.state('rendered', true);
                this.props.node.itree.dirty = false;

                return li;
            }
        }]);
        return ListItem;
    }(Component);

    var List = function (_Component) {
        inherits(List, _Component);

        function List() {
            classCallCheck(this, List);
            return possibleConstructorReturn(this, (List.__proto__ || Object.getPrototypeOf(List)).apply(this, arguments));
        }

        createClass(List, [{
            key: 'shouldComponentUpdate',
            value: function shouldComponentUpdate(nextProps) {
                return _.find(nextProps.nodes, 'itree.dirty') || stateComparator(this.props, nextProps);
            }
        }, {
            key: 'isDeferred',
            value: function isDeferred() {
                return this.props.dom.config.deferredRendering || this.props.dom._tree.config.deferredLoading;
            }
        }, {
            key: 'loadMore',
            value: function loadMore(event) {
                event.preventDefault();
                if (this.props.context) {
                    this.props.context.loadMore(event);
                } else {
                    this.props.dom._tree.loadMore(event);
                }
            }
        }, {
            key: 'renderLoadMoreNode',
            value: function renderLoadMoreNode() {
                return createVNode(1, 'li', 'leaf detached', createVNode(1, 'a', 'title icon icon-more load-more', createTextVNode('Load More'), 2, {
                    'onClick': this.loadMore.bind(this)
                }), 2);
            }
        }, {
            key: 'renderLoadingTextNode',
            value: function renderLoadingTextNode() {
                return createVNode(1, 'li', 'leaf', createVNode(1, 'span', 'title icon icon-more', createTextVNode('Loading...'), 2), 2);
            }
        }, {
            key: 'render',
            value: function render$$1() {
                var _this2 = this;

                var renderNodes = this.props.nodes;
                var pagination = renderNodes.pagination();

                // If rendering deferred, chunk the nodes client-side
                if (this.props.dom.config.deferredRendering) {
                    // Filter non-hidden/removed nodes and limit by this context's pagination
                    var count = 0;
                    renderNodes = this.props.nodes.filter(function (n) {
                        var matches = !(n.hidden() || n.removed());

                        if (matches) {
                            count++;
                        }

                        return count <= pagination.limit && matches;
                    });
                }

                // Render nodes as list items
                var items = _.map(renderNodes, function (node) {
                    return createComponentVNode(2, ListItem, {
                        'dom': _this2.props.dom,
                        'node': node
                    }, node.id);
                });

                if (this.isDeferred() && pagination.limit < pagination.total) {
                    if (!this.props.loading) {
                        items.push(this.renderLoadMoreNode());
                    } else {
                        items.push(this.renderLoadingTextNode());
                    }
                }

                return createVNode(1, 'ol', null, [items, this.props.children], 0);
            }
        }]);
        return List;
    }(Component);

    var Tree = function (_Component) {
        inherits(Tree, _Component);

        function Tree() {
            classCallCheck(this, Tree);
            return possibleConstructorReturn(this, (Tree.__proto__ || Object.getPrototypeOf(Tree)).apply(this, arguments));
        }

        createClass(Tree, [{
            key: 'add',
            value: function add() {
                this.props.dom._tree.focused().blur();

                this.props.dom._tree.addNode(blankNode());
            }
        }, {
            key: 'renderAddLink',
            value: function renderAddLink() {
                if (this.props.dom._tree.config.editing.add) {
                    return createVNode(1, 'li', null, createVNode(1, 'a', 'btn icon icon-plus', null, 1, {
                        'onClick': this.add.bind(this),
                        'title': 'Add a new root node'
                    }), 2);
                }
            }
        }, {
            key: 'render',
            value: function render$$1() {
                var _props = this.props,
                    dom = _props.dom,
                    nodes = _props.nodes;

                var loading = dom.loading;
                var pagination = nodes.pagination();

                return createComponentVNode(2, List, {
                    'dom': dom,
                    'limit': pagination.limit,
                    'loading': loading,
                    'nodes': nodes,
                    'total': pagination.total,
                    children: this.renderAddLink()
                });
            }
        }]);
        return Tree;
    }(Component);

    /**
     * Default InspireTree rendering logic.
     *
     * @category DOM
     * @return {InspireDOM} Default renderer.
     */

    var InspireDOM = function () {
        function InspireDOM(tree, opts) {
            var _this = this;

            classCallCheck(this, InspireDOM);

            // Royale - We comment this block because very often a false TypeError error occurs: 
            // "TypeError: Right-hand side of 'instanceof' is not callable"
            // We override the check because we are sure that the object is an Instance of InspireTree.
            //if (!(tree instanceof InspireTree)) {
            //    throw new TypeError('Tree argument is not an InspireTree instance.');
            //}
            
            // Init properties
            this._tree = tree;
            this.batching = 0;
            this.dropTargets = [];
            this.$scrollLayer;

            if (!opts.target) {
                throw new TypeError('Invalid `target` property - must be a selector, HTMLElement, or jQuery element.');
            }

            // Let InspireTree know we're in control of a node's `rendered` state
            tree.usesNativeDOM = true;

            var dndDefaults = {
                enabled: false,
                validateOn: 'dragstart',
                validate: null
            };

            // Assign defaults
            this.config = _.defaultsDeep({}, opts, {
                autoLoadMore: true,
                deferredRendering: false,
                dragAndDrop: dndDefaults,
                nodeHeight: 25,
                showCheckboxes: false,
                tabindex: -1,
                target: false
            });

            if (opts.dragAndDrop === true) {
                this.config.dragAndDrop = dndDefaults;
                this.config.dragAndDrop.enabled = true;
            }

            // If user didn't specify showCheckboxes,
            // but is using checkbox selection mode,
            // enable it automatically.
            // Royale - commented
            //if (tree.config.selection.mode === 'checkbox' && !_.isBoolean(_.get(opts, 'showCheckboxes'))) {
            //    this.config.showCheckboxes = true;
            //}

            // Cache because we use in loops
            this.isDynamic = _.isFunction(this._tree.config.data);

            // Connect to our target DOM element
            this.attach(this.config.target);

            var initialRender = true;

            // Apply changes
            tree.on('changes.applied', function () {
                _this.renderNodes();

                if (initialRender) {
                    _this.scrollSelectedIntoView();

                    initialRender = false;
                }
            });

            // Immediately render, just in case any already exists
            this.renderNodes();
        }

        /**
         * Attaches to the DOM element for rendering.
         *
         * @category DOM
         * @private
         * @param {HTMLElement} target Element, selector, or jQuery-like object.
         * @return {void}
         */


        createClass(InspireDOM, [{
            key: 'attach',
            value: function attach(target) {
                this.$target = this.getElement(target);
                this.$scrollLayer = this.getScrollableAncestor(this.$target);

                if (!this.$target) {
                    throw new Error('No valid element to attach to.');
                }

                this.$target.setAttribute('data-uid', this._tree.id);

                // Set classnames
                var classNames = this.$target.className.split(' ');
                classNames.push('inspire-tree');

                if (this._tree.config.editable) {
                    classNames.push('editable');

                    _.each(_.pickBy(this._tree.config.editing, _.identity), function (v, key) {
                        classNames.push('editable-' + key);
                    });
                }

                this.$target.className = classNames.join(' ');
                this.$target.setAttribute('tabindex', this.config.tabindex || 0);

                // Handle keyboard interaction
                this.$target.addEventListener('keydown', this.keyboardListener.bind(this));

                // Drag and drop listeners
                if (this.config.dragAndDrop.enabled) {
                    this.$target.addEventListener('dragenter', this.onDragEnter.bind(this), false);
                    this.$target.addEventListener('dragleave', this.onDragLeave.bind(this), false);
                    this.$target.addEventListener('dragover', this.onDragOver.bind(this), false);
                    this.$target.addEventListener('drop', this.onDrop.bind(this), false);

                    this.$target.classList.add('drag-and-drop');
                }

                // Sync browser focus to focus state
                this._tree.on('node.focused', function (node) {
                    var elem = node.itree.ref.querySelector('.title');
                    if (elem !== document.activeElement) {
                        elem.focus();
                    }
                });

                if (this.config.deferredRendering || this._tree.config.deferredLoading) {
                    // Force valid pagination limit based on viewport
                    var limit = this._tree.config.pagination.limit;
                    this._tree.config.pagination.limit = limit > 0 ? limit : _.ceil(this.$scrollLayer.clientHeight / this.config.nodeHeight);

                    // Listen for scrolls for automatic loading
                    if (this.config.autoLoadMore) {
                        this.$target.addEventListener('scroll', _.throttle(this.scrollListener.bind(this), 20));
                    }
                }

                this.$target.inspireTree = this._tree;
            }

            /**
             * Clear page text selection, primarily after a click event which
             * natively selects a range of text.
             *
             * @category DOM
             * @private
             * @return {void}
             */

        }, {
            key: 'clearSelection',
            value: function clearSelection() {
                if (document.selection && document.selection.empty) {
                    document.selection.empty();
                } else if (window.getSelection) {
                    window.getSelection().removeAllRanges();
                }
            }

            /**
             * Get an HTMLElement through various means:
             * An element, jquery object, or a selector.
             *
             * @category DOM
             * @private
             * @param {mixed} target Element, jQuery selector, selector.
             * @return {HTMLElement} Matching element.
             */

        }, {
            key: 'getElement',
            value: function getElement(target) {
                var $element = void 0;

                if (target instanceof HTMLElement) {
                    $element = target;
                } else if (_.isObject(target) && _.isObject(target[0])) {
                    $element = target[0];
                } else if (_.isString(target)) {
                    var match = document.querySelector(target);
                    if (match) {
                        $element = match;
                    }
                }

                return $element;
            }

            /**
             * Helper method to find a scrollable ancestor element.
             *
             * @category DOM
             * @private
             * @param {HTMLElement} $element Starting element.
             * @return {HTMLElement} Scrollable element.
             */

        }, {
            key: 'getScrollableAncestor',
            value: function getScrollableAncestor($element) {
                if ($element instanceof Element) {
                    var style = getComputedStyle($element);
                    if (style.overflow !== 'auto' && $element.parentNode) {
                        $element = this.getScrollableAncestor($element.parentNode);
                    }
                }

                return $element;
            }

            /**
             * Get a tree instance based on an ID.
             *
             * @category DOM
             * @param {string} id Tree ID.
             * @return {InspireTree} Tree instance.
             */

        }, {
            key: 'keyboardListener',


            /**
             * Listen to keyboard event for navigation.
             *
             * @category DOM
             * @private
             * @param {Event} event Keyboard event.
             * @return {void}
             */
            value: function keyboardListener(event) {
                event.stopPropagation();

                // Ignore keys we won't care for.
                // For example, this avoids trampling cmd+reload
                if ([DOWN_ARROW, ENTER, LEFT_ARROW, RIGHT_ARROW, UP_ARROW].indexOf(event.which) < 0) {
                    return;
                }

                // Navigation
                var focusedNodes = this._tree.focused();
                if (focusedNodes.length) {
                    event.preventDefault();

                    switch (event.which) {
                        case DOWN_ARROW:
                            this.moveFocusDownFrom(focusedNodes[0]);
                            break;
                        case ENTER:
                            focusedNodes[0].toggleSelect();
                            break;
                        case LEFT_ARROW:
                            focusedNodes[0].collapse();
                            break;
                        case RIGHT_ARROW:
                            focusedNodes[0].expand();
                            break;
                        case UP_ARROW:
                            this.moveFocusUpFrom(focusedNodes[0]);
                            break;
                        default:
                    }
                }
            }

            /**
             * Move select down the visible tree from a starting node.
             *
             * @category DOM
             * @private
             * @param {object} startingNode Node object.
             * @return {void}
             */

        }, {
            key: 'moveFocusDownFrom',
            value: function moveFocusDownFrom(startingNode) {
                var next = startingNode.nextVisibleNode();
                if (next) {
                    next.focus();
                }
            }

            /**
             * Move select up the visible tree from a starting node.
             *
             * @category DOM
             * @private
             * @param {object} startingNode Node object.
             * @return {void}
             */

        }, {
            key: 'moveFocusUpFrom',
            value: function moveFocusUpFrom(startingNode) {
                var prev = startingNode.previousVisibleNode();
                if (prev) {
                    prev.focus();
                }
            }

            /**
             * Helper method for obtaining the data-uid from a DOM element.
             *
             * @category DOM
             * @private
             * @param {HTMLElement} element HTML Element.
             * @return {object} Node object
             */

        }, {
            key: 'nodeFromTitleDOMElement',
            value: function nodeFromTitleDOMElement(element) {
                var uid = element.parentNode.parentNode.getAttribute('data-uid');
                return this._tree.node(uid);
            }

            /**
             * Drag enter listener.
             *
             * @category DOM
             * @private
             * @param {DragEvent} event Drag enter.
             * @return {void}
             */

        }, {
            key: 'onDragEnter',
            value: function onDragEnter(event) {
                event.preventDefault();

                event.target.classList.add('drag-targeting', 'drag-targeting-insert');
            }

            /**
             * Drag leave listener.
             *
             * @category DOM
             * @private
             * @param {DragEvent} event Drag leave.
             * @return {void}
             */

        }, {
            key: 'onDragLeave',
            value: function onDragLeave(event) {
                event.preventDefault();

                this.unhighlightTarget(event.target);
            }

            /**
             * Drag over listener.
             *
             * @category DOM
             * @private
             * @param {DragEvent} event Drag over.
             * @return {void}
             */

        }, {
            key: 'onDragOver',
            value: function onDragOver(event) {
                event.preventDefault();
            }

            /**
             * Drop listener.
             *
             * @category DOM
             * @private
             * @param {DragEvent} event Dropped.
             * @return {void}
             */

        }, {
            key: 'onDrop',
            value: function onDrop(event) {
                event.preventDefault();

                this.unhighlightTarget(event.target);

                var treeId = event.dataTransfer.getData('treeId');
                var nodeId = event.dataTransfer.getData('nodeId');

                // Find the tree
                var tree = InspireDOM.getTreeById(treeId);
                var node = tree.node(nodeId);

                node.state('drop-target', true);

                // Remove the node from its previous context
                var exported = node.remove(true);

                // Add the node to this tree/level
                var newNode = this._tree.addNode(exported);
                var newIndex = this._tree.indexOf(newNode);

                this._tree.emit('node.drop', event, newNode, null, newIndex);
            }

            /**
             * Triggers rendering for the given node array.
             *
             * @category DOM
             * @private
             * @param {array} nodes Array of node objects.
             * @return {void}
             */

        }, {
            key: 'renderNodes',
            value: function renderNodes(nodes) {
                render(createComponentVNode(2, Tree, {
                    'dom': this,
                    'nodes': nodes || this._tree.nodes()
                }), this.$target);
            }
        }, {
            key: 'scrollListener',


            /**
             * Listens for scroll events, to automatically trigger
             * Load More links when they're scrolled into view.
             *
             * @category DOM
             * @private
             * @param {Event} event Scroll event.
             * @return {void}
             */
            value: function scrollListener(event) {
                var _this2 = this;

                if (!this.rendering && !this.loading) {
                    // Get the bounding rect of the scroll layer
                    var rect = this.$scrollLayer.getBoundingClientRect();

                    // Find all load-more links
                    var links = document.querySelectorAll('.load-more');
                    _.each(links, function (link) {
                        // Look for load-more links which overlap our "viewport"
                        var r = link.getBoundingClientRect();
                        var overlap = !(rect.right < r.left || rect.left > r.right || rect.bottom < r.top || rect.top > r.bottom);

                        if (overlap) {
                            // Auto-trigger Load More links
                            var context = void 0;

                            var $parent = link.parentNode.parentNode.parentNode;
                            if ($parent.tagName === 'LI') {
                                context = _this2._tree.node($parent.getAttribute('data-uid'));
                            }

                            _this2._tree.loadMore(context, event);
                        }
                    });
                }
            }

            /**
             * Scroll the first selected node into view.
             *
             * @category DOM
             * @private
             * @return {void}
             */

        }, {
            key: 'scrollSelectedIntoView',
            value: function scrollSelectedIntoView() {
                var $selected = this.$target.querySelector('.selected');

                if ($selected && this.$scrollLayer) {
                    this.$scrollLayer.scrollTop = $selected.offsetTop;
                }
            }

            /**
             * Remove highlight class.
             *
             * @category DOM
             * @private
             * @param {HTMLElement} element Target element.
             * @return {void}
             */

        }, {
            key: 'unhighlightTarget',
            value: function unhighlightTarget(element) {
                if (element) {
                    element.classList.remove('drag-targeting', 'drag-targeting-insert');
                }
            }
        }], [{
            key: 'getTreeById',
            value: function getTreeById(id) {
                var element = document.querySelector('[data-uid="' + id + '"]');
                if (element) {
                    return element.inspireTree;
                }
            }
        }]);
        return InspireDOM;
    }();

    return InspireDOM;

})));
