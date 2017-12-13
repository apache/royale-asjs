/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('MySimpleValuesImpl');

goog.require('org.apache.royale.core.SimpleValuesImpl');

/**
 * @constructor
 * @extends {org.apache.royale.core.SimpleValuesImpl}
 */
MySimpleValuesImpl = function() {
    org.apache.royale.core.SimpleValuesImpl.call(this);

    /**
     * @private
     * @type {Object}
     */
    this.values_ = {
        /*
        ITextButtonBead :
            org.apache.royale.html.beads.TextButtonBead,
        ITextBead :
            org.apache.royale.html.beads.TextFieldBead,
        ITextModel :
            org.apache.royale.html.beads.models.TextModel
        */
    };
};
goog.inherits(MySimpleValuesImpl, org.apache.royale.core.SimpleValuesImpl);
