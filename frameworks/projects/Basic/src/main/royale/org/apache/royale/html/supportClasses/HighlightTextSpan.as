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
package org.apache.royale.html.supportClasses {


COMPILE::JS{
        import org.apache.royale.core.WrappedHTMLElement
    }


    /**
     * @royalesuppressexport
     */
    public class HighlightTextSpan{

        private var _beginIndex: uint ;
        private var _endIndex: uint ;
       // private var _className:String = 'HighlightTextSpan';

        COMPILE::JS
        private static var _ranges:WeakMap = new WeakMap();

        COMPILE::JS
        protected var _parentSpan:HTMLSpanElement;

        COMPILE::JS
        protected var _span:HTMLSpanElement;

        /**
         *
         * @royaleignorecoercion HTMLSpanElement
         */
        public function HighlightTextSpan(beginIndex: uint=0, endIndex: uint=0,
                                          parent:Object=null, className:String = null) {
            _beginIndex = beginIndex;
            _endIndex = endIndex;
            COMPILE::JS{
                _parentSpan = parent as HTMLSpanElement
                _text = _parentSpan.textContent.substring(beginIndex,endIndex);
            }
            if (className) {
                this.className = className;
            }
        }



        public function isValid():Boolean{
            return _endIndex > _beginIndex;
        }

        COMPILE::JS
        private function getRange():Range{
            var range:Range = _ranges.get(_parentSpan);
            if (!range) {
                range = document.createRange();
                _ranges.set(_parentSpan, range);
                range.selectNodeContents(_parentSpan);
            }
            return range;
        }

        public function get beginIndex():uint {
            return _beginIndex;
        }

        public function get endIndex():uint {
            return _endIndex;
        }

        public function get textRepresentation():String{
            var ret:String;
            COMPILE::JS{
                if (_span) {
                    ret = _span.textContent;
                }
                else if (_parentSpan) {
                    ret = _parentSpan.textContent.substring(_beginIndex,_endIndex);
                }
            }

            return ret;
        }

        private var _text:String;
        /**
         * the original text at the time of construction
         */
        public function get text():String{
            return _text;
        }

        public function get isUnchanged():Boolean{
            return _text == textRepresentation && isPresent;
        }

        public function get isPresent():Boolean{
            var absent:Boolean;
            COMPILE::JS{
                absent = _span.parentNode != _parentSpan;
            }
            return !absent;
        }


        private var _className:String;

        public function get className():String {
            return _className;
        }

        public function set className(value:String):void {
            COMPILE::JS{
                if (_span && _className) {
                    _span.classList.remove(_className);
                }
            }
            _className = value;
            COMPILE::JS{
                if (_span && value) {
                    _span.classList.add(value);
                }
            }
        }

        public function unapply():void{
            COMPILE::JS{
                if (_span) {
                    if(_span.parentNode == _parentSpan) {
                        while(_span.firstChild) {
                            _parentSpan.insertBefore(_span.firstChild,_span)
                        }
                        _parentSpan.removeChild(_span);
                    }
                    //_span = null;
                }
            }
        }

        /**
         *
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        public function apply():void{
            COMPILE::JS{
                if (!_span) {
                    _span = document.createElement('span') as HTMLSpanElement;
                    element = (_span as WrappedHTMLElement)
                    element.royale_wrapper = this;
                    _span.className = 'HighlightTextSpan';
                    var c:String = className;
                    if (c) {
                        _span.classList.add(c)
                    }

                    var range:Range = getRange();
                    var node:Node = _parentSpan.firstChild;
                    var beginNode:Node;
                    var beginOffset:uint;
                    var endNode:Node;
                    var endOffset:uint;
                    var offset:uint = _beginIndex;
                    var l:uint;
                    while(node) {
                        l = node.textContent.length;
                        if (l <= offset) {
                            offset -= l;
                        } else {
                            //no need to distinguish between nodes (nodeType == Node.TEXT_NODE etc),
                            //because we are only ever a sequence of text nodes or span nodes
                            if (!beginNode) {
                                beginNode = node;
                                beginOffset = offset;
                                offset = offset + (_endIndex - _beginIndex);
                                if (l < offset) {
                                    offset -= l;
                                } else {
                                    endNode = node;
                                    endOffset = offset;
                                    break;
                                }
                            } else {
                                endNode = node;
                                endOffset = offset;
                                break;
                            }
                        }
                        node = node.nextSibling;
                    }
                    range.setStart(beginNode,beginOffset);
                    range.setEnd(endNode,endOffset);

                    range.surroundContents(_span);
                }

            }
        }
        

        public function containsIndex(index:uint):Boolean{
            return index >=_beginIndex && index < _endIndex;
        }

        public function equalsRange(beginIndex:uint, endIndex:uint):Boolean{
            if (beginIndex > endIndex) {
                var temp:uint = endIndex;
                endIndex = beginIndex;
                beginIndex = temp;
            }
            return _beginIndex == beginIndex && _endIndex == endIndex;
        }

        public function containsRange(beginIndex:uint, endIndex:uint):Boolean{
            if (beginIndex > endIndex) {
                var temp:uint = endIndex;
                endIndex = beginIndex;
                beginIndex = temp;
            }
            return _beginIndex <= beginIndex &&  _endIndex >= endIndex;
        }

        public function intersectsRange(beginIndex:uint, endIndex:uint):Boolean{
            if (beginIndex > endIndex) {
                var temp:uint = endIndex;
                endIndex = beginIndex;
                beginIndex = temp;
            }
            return Math.max(_beginIndex, beginIndex) < Math.min(_endIndex, endIndex);
        }


        COMPILE::JS
        public var element:WrappedHTMLElement;



    }
}

