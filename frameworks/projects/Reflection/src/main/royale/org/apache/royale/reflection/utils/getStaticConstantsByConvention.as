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
package org.apache.royale.reflection.utils
{
	import org.apache.royale.reflection.ExtraData;
	
	COMPILE::SWF
	{
		import flash.utils.describeType;
	}
	
	COMPILE::JS
	{
		import org.apache.royale.reflection.CompilationData;
		import goog.DEBUG;
	}
	
	
    /**
     *  A utility method to retrieve public static constants that is only reliable
	 *  in a cross-target way by using a convention check.
	 *  For this to work, javascript output needs js-default-initializers=true
	 *  By default this assumes all candidates with names that are upper case only with possible underscores
	 *  
     *  @param classRef the class reference to inspect
	 *  @param conventionCheck optional replacement check for default check described above
	 *  		should be a function that inspects a string and returns true or false depending on whether it matches the convention or not.
     *  
	 *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 *
     */
    public function getStaticConstantsByConvention(classRef:Class, conventionCheck:Function = null):Array
	{
        var ret:Array = [];
		if (!conventionCheck) conventionCheck = defaultConstantConventionCheck;
		var item:String;
		
		COMPILE::SWF {
			var xml:XML = flash.utils.describeType(classRef);
			for each(var constant:XML in xml.constant) {
				item = constant.@name.toString();
				if (conventionCheck(item)) ret.push(item);
			}
		}
		
		COMPILE::JS {
			
			var statics:Array;
			if ( classRef.prototype.ROYALE_REFLECTION_INFO) {
				if (CompilationData.hasCompilationOption(
						classRef.prototype.ROYALE_COMPILE_FLAGS,
						CompilationData.WITH_DEFAULT_INITIALIZERS)) {
					statics = classRef.prototype.ROYALE_INITIAL_STATICS
				} else {
					//debug level warning:
					if (goog.DEBUG) {
						if (!warningMap.get(classRef)) {
							warningMap.set(classRef, true);
							console.warn('[WARNING] getStaticConstantsByConvention :: the reflection target '+classRef.prototype.ROYALE_CLASS_INFO.names[0].qName+' was not ' + CompilationData.describeSingleFlag(CompilationData.WITH_DEFAULT_INITIALIZERS))
						}
					}
					statics = Object.keys(classRef);
				}
			} else {
				statics = ExtraData.hasData(classRef) ? ExtraData.getData(classRef)['ROYALE_INITIAL_STATICS'] : null;
			}

			if (statics) {
				statics = statics.slice();
				var l:uint = statics.length;
				for (var i:uint = 0; i < l; i++) {
					item = statics[i];
					if (conventionCheck(item)) ret.push(item);
				}
			}
		}
		return ret;
    }
}



COMPILE::JS
var warningMap:Map = new Map();
