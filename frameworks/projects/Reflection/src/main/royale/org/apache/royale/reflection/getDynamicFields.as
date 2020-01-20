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
package org.apache.royale.reflection {
	COMPILE::JS{
		import goog.DEBUG;
	}
	
	import org.apache.royale.events.EventDispatcher;
	
	/**
	 *  A utility method to check if an object is dynamic (i.e. can have non-sealed members added or deleted)
	 *  Note that static class objects are always dynamic, as are (static) Interface Objects
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *
	 * @param inspect the class or instance to check for dynamic fields
	 * @param includePredicate an optional function for which takes a single String argument
	 *          and returns true to include that specific field in the results. If it returns false,
	 *          that property is excluded. Defaults to null, which applies no filtering and returns all
	 *          detected properties.
	 * @param checkFirst an optional check to verify that the inspect parameter is dynamic
	 *        before inspecting it for dynamic properties. This should normally be left at its default value of true.
	 *        If it is known that the object is dynamic before calling this method, setting this to false
	 *        could improve performance in performance-sensitive code.
	 *        The results of calling this method on non-dynamic objects may be less reliable or less consistent
	 *        across target platforms if checkFirst is false
	 * @param numericFields if true, numeric fields will be returned as numeric values
	 *
	 * @return the dynamic fields as Strings in an Array
	 *
	 * @royaleignorecoercion Map
	 */
	COMPILE::JS
	public function getDynamicFields(inspect:Object, includePredicate:Function = null, checkFirst:Boolean = true, numericFields:Boolean = false):Array {
		var arr:Array;
		var i:uint = 0;
		var assumeDynamic:Boolean = checkFirst ? isDynamicObject(inspect) : true;
		var checkIncludes:Boolean = includePredicate != null;
		var prop:String;
		if (assumeDynamic) {
				var constructor:Object = inspect.constructor;
				if (constructor === Object['constructor']) {
					//class or interface
					//this relies on compiler-added support to prevent enumeration of some fields
					//that are not protected from enumeration by default
					//this is only added to classes that have static fields in the definition
					arr = Object.keys(inspect);
					if (inspect.prototype && inspect.prototype.ROYALE_REFLECTION_INFO) {
						if (goog.DEBUG) {
							if (!CompilationData.hasCompilationOption(inspect.prototype.ROYALE_COMPILE_FLAGS, CompilationData.WITH_DEFAULT_INITIALIZERS)) {
								trace('[WARN] getDynamicFields can be unreliable for static inspection of ' + inspect.prototype.ROYALE_CLASS_INFO.names[0].qName + ' because it was not compiled with \'js-default-initializers=true\'');
							}
						}
						var avoidNames:Array = inspect.prototype.ROYALE_INITIAL_STATICS;
						if (avoidNames) {
							var temp:Array = [];
							var l:uint = arr.length;
							for (i = 0; i < l; i++) {
								prop = arr[i];
								if (avoidNames.indexOf(prop) == -1) {
									temp.push(prop);
								}
							}
							arr = temp;
						}
					}
				} else {
					var excludeFields:Array;
					arr = Object.keys(inspect);
					var warned:Boolean;
					//the following is complicated, but appears to work in release mode
					//if everything (including framework if it needs to be reflected into) is compiled with
					//js-default-initializers=true
					if (inspect.ROYALE_REFLECTION_INFO) {
						const inspectReflect:Object = inspect.ROYALE_REFLECTION_INFO;
						if (goog.DEBUG) {
							if (!CompilationData.hasCompilationOption(inspect.ROYALE_COMPILE_FLAGS, CompilationData.WITH_DEFAULT_INITIALIZERS)) {
								trace('[WARN] getDynamicFields can be unreliable for ' + inspect.ROYALE_CLASS_INFO.names[0].qName + ' and any ancestor classes that were not compiled with \'js-default-initializers=true\'');
								warned = true;
							}
						}
						
						var instanceExcludes:Array = inspectReflect.instanceExcludes;
						if (!instanceExcludes) {
							//special cases:
							//this is not ideal, but seems necessary unless the properties were made not enumerable
							//EventDispatcher
							var eventDispatcherClassInfo:Object;
							//todo - consider using reflection code instead of hard dependency on EventDispatcher
							if (inspect is EventDispatcher) {
								instanceExcludes = getDynamicFields['EventDispatcherFields'];
								if (!instanceExcludes) {
									var test:Object = new EventDispatcher();
									//
									instanceExcludes = getDynamicFields['EventDispatcherFields'] = Object.keys(test);
								}
								const edc:Class = EventDispatcher;
								eventDispatcherClassInfo =  edc.prototype.ROYALE_CLASS_INFO;
							}
							
							if (!instanceExcludes) instanceExcludes = [];
							
							var proto:Object = inspect.constructor.prototype;
							while (proto) {
								var protoReflect:Object = proto.ROYALE_REFLECTION_INFO;
								if (goog.DEBUG && !warned) {
									if (protoReflect && !CompilationData.hasCompilationOption(proto.ROYALE_COMPILE_FLAGS, CompilationData.WITH_DEFAULT_INITIALIZERS)) {
										//skip EventDispatcher because we already special-cased it
										if (proto.ROYALE_CLASS_INFO.names[0].qName != eventDispatcherClassInfo.names[0].qName) {
											trace('[WARN] getDynamicFields can be unreliable for '
													+ inspect.ROYALE_CLASS_INFO.names[0].qName
													+ '\'s ancestor class '
													+ proto.ROYALE_CLASS_INFO.names[0].qName
													+ ' and any of its ancestors that were not compiled with \'js-default-initializers=true\'');
											warned = true;
										}
									}
								}
								var inherited:Array = proto.ROYALE_REFLECTION_INFO ? proto.ROYALE_REFLECTION_INFO.instanceExcludes : null;
								var protoKeys:Array = inherited || Object.keys(proto);
								l = protoKeys.length;
								while (l--) {
									var key:String = protoKeys[l];
									if (instanceExcludes.indexOf(key) == -1) instanceExcludes.push(key);
								}
								if (inherited) break;
								proto = proto.constructor.superClass_;
							}
							
							inspectReflect.instanceExcludes = instanceExcludes;
						}
						l = instanceExcludes.length;
						if (l && !excludeFields) excludeFields = [];
						while (l--) {
							excludeFields.push(instanceExcludes[l]);
						}
					} else {
						if (inspect.constructor == Map) {
							arr = [];
							(inspect as Map).forEach(
								function(value:Object, key:Object, inst:Map):void{
									arr.push(key);
								}
							)
						}
					}
					
					if (excludeFields) {
						l = excludeFields.length;
						while (l--) {
							var idx:int = arr.indexOf(excludeFields[l]);
							if (idx != -1) {
								arr.splice(idx, 1);
							}
						}
					}
				}
				
				if (checkIncludes) {
					arr = arr.filter(includePredicate);
				}
				if (numericFields) {
				 	//arr.forEach(numericise)
					arr.forEach(function (value:String, index:uint, array:Array):void{
						var numVal:Number = Number(value);
						if (''+numVal == value) array[index]=numVal;
					})
					
				}
		} else {
			//it's not considered dynamic...
			//so assume zero dynamic fields (even if technically in js
			//there could actually be some at runtime)
			arr = [];
		}
		
		return arr;
	}
	
	COMPILE::SWF
	public function getDynamicFields(inspect:Object, includePredicate:Function = null, checkFirst:Boolean = true, numericFields:Boolean = false):Array {
		
		var i:uint = 0;
		var assumeDynamic:Boolean = checkFirst ? isDynamicObject(inspect) : true;
		var checkIncludes:Boolean = includePredicate != null;
		var arr:Array = [];
		if (assumeDynamic) {
			if (numericFields) {
				for (var propObj:Object in inspect) {
					if (!checkIncludes || includePredicate(propObj))
						arr[i++] = propObj;
				}
			} else {
				for (var prop:String in inspect) {
					if (!checkIncludes || includePredicate(prop))
						arr[i++] = prop;
				}
			}
		}
		
		return arr;
	}
	
}


/*COMPILE::JS{
	function numericise(value:String, index:uint, array:Array):void{
		var numVal:Number = Number(value);
		if (''+numVal == value) array[index]=numVal;
	}
}*/
