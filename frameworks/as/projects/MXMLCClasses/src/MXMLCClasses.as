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
package
{

/**
 *  @private
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class MXMLCClasses
{
 
    import mx.binding.ArrayElementWatcher; ArrayElementWatcher;
    import mx.binding.Binding; Binding;
    import mx.binding.BindingManager; BindingManager;
    import mx.binding.FunctionReturnWatcher; FunctionReturnWatcher;
    import mx.binding.IBindingClient; IBindingClient;
    import mx.binding.IWatcherSetupUtil2; IWatcherSetupUtil2;
    import mx.binding.PropertyWatcher; PropertyWatcher;
    import mx.binding.RepeaterComponentWatcher; RepeaterComponentWatcher;
    import mx.binding.RepeaterItemWatcher; RepeaterItemWatcher;
    import mx.binding.StaticPropertyWatcher; StaticPropertyWatcher;
    import mx.binding.Watcher; Watcher;
    import mx.binding.XMLWatcher; XMLWatcher;
    import mx.core.ClassFactory; ClassFactory;
    import mx.core.DeferredInstanceFromClass; DeferredInstanceFromClass;
    import mx.core.DeferredInstanceFromFunction; DeferredInstanceFromFunction;
    import mx.core.IDeferredInstance; IDeferredInstance;
    import mx.core.IFactory; IFactory;
    import mx.core.IFlexModuleFactory; IFlexModuleFactory;
    import mx.core.IPropertyChangeNotifier; IPropertyChangeNotifier;
    import mx.core.IStateClient2; IStateClient2;
    import mx.core.mx_internal; use namespace mx_internal;
    import mx.events.PropertyChangeEvent; PropertyChangeEvent;
    import mx.filters.IBitmapFilter; IBitmapFilter;
    import mx.styles.CSSCondition; CSSCondition;
    import mx.styles.CSSSelector; CSSSelector;
    import mx.styles.CSSStyleDeclaration; CSSStyleDeclaration;
    import mx.styles.IStyleManager2; IStyleManager2;
    import mx.styles.StyleManager; StyleManager;    
}

}
