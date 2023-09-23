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
package org.apache.royale.html
{
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.supportClasses.HighlightTextSpan;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  Dispatched when the user changes the text.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.0
     */
    [Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  This class is a utility class for simple highlighting of
     *  editable text.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SimpleTextHighlighter extends UIBase
	{





        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SimpleTextHighlighter()
		{
			super();

            COMPILE::SWF
            {
                model.addEventListener("textChange", textChangeHandler);
            }
		}

        private var _parentRef:Object;


        COMPILE::JS
        private var _textContainer:HTMLSpanElement;

        private var _textLength:uint;

        private var _lengthValid:Boolean = true;

        private function textLength():uint{
            if (!_lengthValid) {
                _textLength = text.length;
                _lengthValid = true;
            }
            return _textLength;
        }

        /**
         *  @copy org.apache.royale.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLTextAreaElement
         */
       [Bindable(event="change")]
		public function get text():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).text;
            }
            COMPILE::JS
            {
                return  _textContainer.textContent;
            }
		}

        /**
         *  @private
         *  @royaleignorecoercion HTMLDivElement
         */
		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                inSetter = true;
                ITextModel(model).text = value;
                inSetter = false;
            }
            COMPILE::JS
            {
                if (value != _textContainer.textContent) {
                    _textContainer.textContent = value;
                    dispatchEvent(new Event('textChange'));
                }
            }

            _lengthValid = false;
		}


        protected var _highLights:Array = [];

        public function removeHighlights():void{
            COMPILE::JS
            {

                //this will quickly remove all html (highlight blocks)
                var selection:Selection = window.getSelection();
                var reselect:Boolean;
                var offset:uint = 0;
                var end:uint = 0;
                if (selection.rangeCount) {
                    var selectionRange:Range = selection.getRangeAt(0);
                    if (_textContainer == selectionRange.commonAncestorContainer || _textContainer.contains(selectionRange.commonAncestorContainer)) {
                        var foundStart:Boolean;
                        reselect = true;
                        var node:Node = _textContainer.firstChild;
                        while(node) {
                            var tn:Node = node.nodeType == Node.TEXT_NODE ? node : node.firstChild;
                            if (!foundStart) {
                                if (selectionRange.startContainer == node || selectionRange.startContainer == tn) {
                                    foundStart = true;
                                    offset += selectionRange.startOffset;

                                    if (selectionRange.endContainer == node || selectionRange.endContainer == tn) {
                                        end = offset + (selectionRange.endOffset - selectionRange.startOffset);
                                        break;
                                    } else {
                                        end += node.textContent.length;
                                    }
                                } else {
                                    offset += node.textContent.length;
                                    end = offset;
                                }
                            } else {
                                if (selectionRange.endContainer == node || selectionRange.endContainer == tn) {
                                    end += selectionRange.endOffset;
                                    break;
                                } else {
                                    end += node.textContent.length;
                                }
                            }
                            node = node.nextSibling;
                        }
                    }
                }

                var plainText:String = text;
                _textContainer.textContent = plainText;
                _highLights.length = 0;
                if (reselect) {
                    selectionRange = document.createRange();
                    node = _textContainer.firstChild ? _textContainer.firstChild : _textContainer;
                    selectionRange.setStart(node,offset);
                    selectionRange.setEnd(node,end);
                    selection.removeAllRanges();
                    selection.addRange(selectionRange);
                }
            }
        }

        /**
         *
         * can be overridden in subclasses
         */
        protected function createHighlightSpan(begin:int, end:int):HighlightTextSpan{
            return new HighlightTextSpan(begin,end,_parentRef);
        }

        private var _autoRemoveHighlightChanges:Boolean;
        public function get autoRemoveHighlightChanges():Boolean{
            return _autoRemoveHighlightChanges
        }

        public function set autoRemoveHighlightChanges(value:Boolean):void{
            _autoRemoveHighlightChanges = value;
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        private function restoreIfNeeded():void{
            COMPILE::JS{
                //"undo" editing can restore items that were previously 'removed'
                var l:uint = _highLights.length;
                if (_textContainer.childElementCount > l) {
                    var collect:Array = [];
                    var wrappedElement:WrappedHTMLElement = WrappedHTMLElement(_textContainer.firstElementChild);
                    while (wrappedElement) {
                        var highlight:HighlightTextSpan = wrappedElement.royale_wrapper as HighlightTextSpan;
                        if (highlight) collect.push(highlight);
                        wrappedElement = WrappedHTMLElement(wrappedElement.nextElementSibling)
                    }
                    _highLights = collect;
                }
            }
        }


        private function performAutoRemove():void{
            var l:uint = _highLights.length;
            if (l) {
                var retained:Array = [];
                for (var i:int = 0;i<l;i++) {
                    var removeCheck:HighlightTextSpan = _highLights[i] as HighlightTextSpan;
                    if (_autoRemoveHighlightChanges) {
                        if (removeCheck.isUnchanged) {
                            retained.push(removeCheck)
                            removeCheck = null;
                        }
                    } else {
                        if (removeCheck.isPresent) {
                            retained.push(removeCheck)
                            removeCheck = null;
                        }
                    }
                    if (removeCheck) {
                        removeCheck.unapply();
                    }
                }
                _highLights = retained;
            }
        }

        /**
         *
         * Utility method for unHighlighting text.
         *
         * returns true if highlighting occurred, false otherwise
         */
        public function removeHighlightForText(string:String, fromIndex:uint=0, all:Boolean=false):Boolean{
            var l:uint = _highLights.length;
            var success:Boolean;
            if (l && string) {
                if (string) {
                    var idx:int = text.indexOf(string,fromIndex);
                    while (idx != -1) {
                        success =  removeHighlightForRange(idx) || success;
                        if (all || !success) {
                            idx = text.indexOf(string,idx + string.length);
                        } else {
                            break;
                        }
                    }
                }
            }
            return success;
        }


        public function removeHighlightForRange(containsIndex:uint):Boolean{
            var l:uint = _highLights.length;
            if (l) {
                for (var i:int = 0;i<l;i++) {
                    var highlight:HighlightTextSpan = _highLights[i] as HighlightTextSpan;
                    if (highlight.containsIndex(containsIndex)) {
                        _highLights.splice(i,1);
                        highlight.unapply();
                        return true;
                        break;
                    }
                }
            }
            return false;
        }


        /**
         *
         * Utility method for highlighting text.
         *
         * returns true if highlighting occurred, false otherwise
         */
        public function highlightText(string:String, fromIndex:uint=0, all:Boolean=false):Boolean{
            var ret:Boolean;
            if (string) {
                var text:String = this.text;
                var idx:int = text.indexOf(string,fromIndex);
                while (idx != -1) {
                    ret = highlightOffsetRange(idx, string.length, !all) || ret;
                    if (all && text.length > idx + string.length) {
                        idx = text.indexOf(string, idx + string.length);
                    } else idx = -1;
                }
            }
            return ret;
        }

        /**
         *
         * This method uses the same range logic as String.substr
         * (begin: first char index, length: char count to be included)
         * if 'single' is true, any previous highlights will be removed prior to the new highlight range
         * being added
         *
         * returns true if highlighting occurred, false otherwise
         *
         */
        public function highlightOffsetRange(begin:uint, length:uint, single:Boolean):Boolean{
            if (length > 0) {
                return highlightRange(begin,begin+length,single);
            }
            return false;
        }


        /**
         *
         * This method uses the same range logic as String.substring
         * (begin: first char index, end: char index after last)
         * if 'single' is true, any previous highlights will be removed prior to the new highlight range
         * being added
         *
         * returns true if highlighting occurred, false otherwise
         *
         * @royaleignorecoercion org.apache.royale.html.supportClasses.HighlightTextSpan
         */
        public function highlightRange(begin:uint, end:uint, single:Boolean):Boolean{
            var tl:uint = textLength();
            if (end > tl) end = tl;
            if (begin >= end) return false;
            var l:uint = _highLights.length;
            if (single) {
                if (l) {
                    removeHighlights();
                    l = 0;
                }
            }

            var insertAt:int = -1;
            if (l) {
                for (var i:int = 0;i<l;i++) {
                    var highlight:HighlightTextSpan = _highLights[i] as HighlightTextSpan;
                    if (highlight.intersectsRange(begin,end)) {
                        //for now, simple exclusions apply
                       // throw new Error('Highlight ranges must be exclusive')

                        return false;
                    }
                    if (highlight.beginIndex >= end ) {
                        if (insertAt == -1) //we need the first location
                            insertAt = i;
                    }
                }
            }
            if (insertAt == -1) insertAt = l;
            var newHighLight:HighlightTextSpan = createHighlightSpan(begin,end);
            if (insertAt == l) {
                _highLights[insertAt] = newHighLight
            } else {
                _highLights.splice(insertAt,0,newHighLight);
            }

            newHighLight.apply();
            return true;
        }

        COMPILE::JS
        private var docListening:Boolean;

        COMPILE::JS
        private function enforceUnselectable(selection:Selection):void{

            var selectionRange:Range = selection.getRangeAt(0);
            var location:Node = selectionRange.endContainer;
            var endOffset:uint = selectionRange.endOffset;
            if (location != selectionRange.startContainer || selectionRange.startOffset != selectionRange.endOffset) {
                selection.removeAllRanges();
                selectionRange = document.createRange();
                selectionRange.setStart(location,endOffset);
                selectionRange.collapse(true);
                selection.addRange(selectionRange);
            }
        }

        COMPILE::JS
        protected function onLostFocus(event:Event):void{
            if (docListening){
                document.removeEventListener('selectionchange',onSelectEvent);
                docListening = false;
            }
        }

        protected function onSelectEvent(event:Event):void{

            COMPILE::JS{
                var selection:Selection;
                if (!docListening) {
                    document.addEventListener('selectionchange',onSelectEvent);
                    docListening = true;
                }
                if (!_selectable) {
                    if (docListening){
                        selection = window.getSelection();
                        if (event.type == 'selectionchange') {
                            if (selection.baseNode != _textContainer && !_textContainer.contains(selection.baseNode)) {
                                document.removeEventListener('selectionchange',onSelectEvent);
                                docListening = false;
                                return;
                            }
                        }
                    }
                    enforceUnselectable(selection);
                }
                selection = window.getSelection();

            }

            //trace(event)
        }


        private var _wordWrap:Boolean = true;
        public function get wordWrap():Boolean {
            return _wordWrap;
        }

        public function set wordWrap(value:Boolean):void {
            if (_wordWrap != value) {
                _wordWrap = value;
                COMPILE::JS{
                    if (value) {
                        element.style.whiteSpace = 'pre-wrap';
                    } else {
                        element.style.whiteSpace = 'pre';
                    }
                }
            }
        }


        private var _selectable:Boolean = true;
        public function get selectable():Boolean {
            return _selectable;
        }

        public function set selectable(value:Boolean):void {
            if (_selectable != value) {
                _selectable = value;
                COMPILE::JS{
                    if (value) {
                        _textContainer.style.userSelect = '';
                    } else {
                        _textContainer.style.userSelect = 'none';
                    }
                }
            }
        }

        private var _editable:Boolean = true;
        public function get editable():Boolean {
            return _editable;
        }

        public function set editable(value:Boolean):void {
            if (_editable != value) {
                _editable = value;
                COMPILE::JS{
                    _textContainer.contentEditable = String(value) ;
                    if (value) {
                        // element.addEventListener('input', onInput)
                        goog.events.listen(_textContainer, 'input', textChangeHandler);
                    } else {
                        // element.removeEventListener('input', onInput);
                        goog.events.unlisten(_textContainer, 'input', textChangeHandler);
                    }
                }
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLSpanElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');
            _textContainer = document.createElement('span') as HTMLSpanElement;
            _textContainer.onselectstart = onSelectEvent;
            _textContainer.onblur = onLostFocus;
            //for JS the parentRef is the parent span
            _parentRef = _textContainer;
            _textContainer.style.font = 'inherit';
            element.appendChild(_textContainer);
            _textContainer.contentEditable = "true";
            goog.events.listen(_textContainer, 'input', textChangeHandler);
            typeNames = 'SimpleTextHighlighter';
            return element;
        }

        private var inSetter:Boolean;

        /**
         *  dispatch change event in response to a textChange event
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.0
         */
        public function textChangeHandler(event:Event):void
        {
            COMPILE::JS{
                if (!inSetter)
                {
                    _lengthValid = false;
                    restoreIfNeeded();
                    performAutoRemove();
                    dispatchEvent(new Event(Event.CHANGE));
                }
            }

        }
	}
}
