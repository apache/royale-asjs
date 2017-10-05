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

goog.provide('RoyaleTest');

goog.require('MyController');
goog.require('MyInitialView');
goog.require('MyModel');
goog.require('MySimpleValuesImpl');

goog.require('org.apache.flex.FlexGlobal');

goog.require('org.apache.flex.core.Application');

/**
 * @constructor
 * @extends {org.apache.flex.core.Application}
 */
RoyaleTest = function() {
    org.apache.flex.core.Application.call(this);

    this.controller = org.apache.flex.FlexGlobal.newObject(
        MyController, [this]
    );

    this.initialView =
        /** @type {org.apache.flex.core.ViewBase} */ (
            org.apache.flex.FlexGlobal.newObject(MyInitialView, [this])
        );

    this.model =
        /** @type {flash.events.EventDispatcher} */ (
            org.apache.flex.FlexGlobal.newObject(MyModel, [])
        );
    this.model.set_labelText('Say hi!');

    this.valuesImpl =
        /** @type {org.apache.flex.core.SimpleValuesImpl} */ (
            org.apache.flex.FlexGlobal.newObject(MySimpleValuesImpl, [this])
        );

    // this method of logging survives the Closure Compiler
    //window['console']['log'](app);
};
goog.inherits(RoyaleTest, org.apache.flex.core.Application);

// Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol('RoyaleTest', RoyaleTest);
