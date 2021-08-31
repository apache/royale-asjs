////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.utils{
    
    /**
     *
     * @royaleignorecoercion Class
     */
    COMPILE::JS
    public function observeElementSize(target:HTMLElement , callback:Function, stop:Boolean=false):Boolean{
        var isNative:Boolean = true;
        if (window['ResizeObserver'] !== undefined) {
            var existing:Object /* ResizeObserver */ = referenceMap.get(callback);
            if (existing) {
                if (stop) existing['unobserve'](target)
                else existing['observe'](target)
            } else {
                if (!stop) {
                    var RO:Class = window['ResizeObserver'] as Class;
                    existing = new RO(callback);
                    referenceMap.set(callback, existing);
                    existing['observe'](target);
                }
            }
        } else {
            isNative = false;
            var callbacks:Array ;
            if (observeElementSize['t'] == null) {
                if (stop) return false;
                callbacks = [];
                referenceMap.set(observeElementSize, callbacks);

                observeElementSize['c'] = function(el:HTMLElement ,callback:Function):void{
                    var checks:Object;
                    var change:Boolean;
                    if (referenceMap.has(el)) {
                        checks = referenceMap.get(el);
                        var latest:Number = el.offsetHeight;
                        if (latest != checks['h'] || checks['ch'] != el.clientHeight) {
                            change = true;
                            checks['h'] = latest;
                            checks['ch'] = el.clientHeight;
                        }
                        latest = el.offsetWidth;
                        if (latest != checks['w'] || checks['cw'] != el.clientWidth) {
                            change = true;
                            checks['w'] = latest;
                            checks['cw'] = el.clientWidth;
                        }
                    } else {
                        //setup
                        checks = {
                            'h' : el.offsetHeight,
                            'ch': el.clientHeight,
                            'w' : el.offsetWidth,
                            'cw': el.clientWidth
                        };
                        referenceMap.set(el, checks);
                        change = true;
                    }
                    if (change) {
                        try{
                            callback();
                        } catch(e:Error){}
                    }
                }
                observeElementSize['t'] = function():void{
                    var l:uint = callbacks.length;
                    for (var i:uint = 0; i<l;i++) {
                        var cb:Function = callbacks[i]
                        var els:Array = referenceMap.get(cb);
                        if (els) {
                            var l2:uint = els.length;
                            for (var ii:uint = 0; ii<l2;ii++) {
                                observeElementSize['c'](els[ii], cb);
                            }
                        }
                    }
                }
                observeElementSize['t']['interval'] = setInterval(observeElementSize['t'], 50);
            } else {
                callbacks = referenceMap.get(observeElementSize);
            }
            var elements:Array;
            var idcb:int = callbacks.indexOf(callback);
            if (stop) {
                if (idcb != -1) {
                    callbacks.splice(idcb,1);
                    if (callbacks.indexOf(callback) == -1) {
                        referenceMap.delete(callback);
                    }
                    if (callbacks.length == 0) {
                        referenceMap = new WeakMap();
                        if (observeElementSize['t']) {
                            clearInterval(observeElementSize['t']['interval']);
                            observeElementSize['t'] = null;
                        }
                        observeElementSize['c'] = null;
                    }
                }

            } else {
                callbacks.push(callback);
                elements = referenceMap.get(callback);
                if (!elements) {
                    elements = [];
                    referenceMap.set(callback, elements);
                }
                if (elements.indexOf(target) == -1) elements.push(target);
            }

        }
        return isNative;
    }

}


COMPILE::JS
var referenceMap:WeakMap = new WeakMap();
