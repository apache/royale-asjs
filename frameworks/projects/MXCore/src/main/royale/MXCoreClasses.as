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
internal class MXCoreClasses
{
	import mx.binding.BindabilityInfo; BindabilityInfo;
	import mx.binding.utils.ChangeWatcher; ChangeWatcher;
	
	import mx.core.EventPriority; EventPriority;
	import mx.core.FlexVersion; FlexVersion;
	import mx.core.IChildList; IChildList;
	import mx.core.IFlexDisplayObject; IFlexDisplayObject;
	import mx.core.IFlexModuleFactory; IFlexModuleFactory;
	import mx.core.IUIComponent; IUIComponent;
	import mx.core.mx_internal; mx_internal;
	import mx.core.UIComponent; UIComponent;
	
	import mx.events.FlexEvent; FlexEvent;
	import mx.events.ModuleEvent; ModuleEvent;
	import mx.events.ProgressEvent; ProgressEvent;
	import mx.events.PropertyChangeEvent; PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind; PropertyChangeEventKind;
	import mx.events.ResourceEvent; ResourceEvent;

	import mx.managers.ISystemManager; ISystemManager;
	import mx.managers.SystemManagerGlobals; SystemManagerGlobals;
	
	import mx.modules.IModule; IModule;
	import mx.modules.IModuleInfo; IModuleInfo;
	import mx.modules.Module; Module;
	import mx.modules.ModuleLoader; ModuleLoader;
	import mx.modules.ModuleManager; ModuleManager;
	
	import mx.resources.IResourceBundle; IResourceBundle;
	import mx.resources.IResourceManager; IResourceManager;
	import mx.resources.Locale; Locale;
	import mx.resources.LocaleSorter; LocaleSorter;
	import mx.resources.ResourceBundle; ResourceBundle;
	import mx.resources.ResourceManager; ResourceManager;
	import mx.resources.ResourceManagerImpl; ResourceManagerImpl;
	
	import mx.system.ApplicationDomain; ApplicationDomain;

	import mx.utils.StringUtil; StringUtil;
    
}

}

