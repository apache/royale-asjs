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
	
	COMPILE::SWF{
		import flash.utils.getDefinitionByName;
	}
	
	/**
	 *  Information about compiletime settings used when compiling the target class or instance
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *
	 */
	public class CompilationData {
		COMPILE::JS{
			//mirror of JSGoogConfiguration getReflectionFlags
			
			public static const WITH_DEFAULT_INITIALIZERS:uint = 1;
			public static const HAS_KEEP_AS3_METADATA:uint = 2;
			public static const HAS_KEEP_CODE_WITH_METADATA:uint = 4;
			public static const HAS_EXPORT_PUBLIC_SYMBOLS:uint = 8;
			public static const EXPORT_PROTECTED_SYMBOLS:uint = 16;
			
			private static const _ALL:Array = [
				WITH_DEFAULT_INITIALIZERS,
				HAS_KEEP_AS3_METADATA,
				HAS_KEEP_CODE_WITH_METADATA,
				HAS_EXPORT_PUBLIC_SYMBOLS,
				EXPORT_PROTECTED_SYMBOLS
			];
			
			private static const _DESCRIPTIONS:Object = {
				'1': 'Compiled with default initializers enabled',
				'2': 'Compiled with request to keep specific as3 metadata, if present',
				'4': 'Compiled to avoid deadcode elimination if code has metadata',
				'8': 'Compiled with public symbols export enabled',
				'16': 'Compiled with protected symbols export enabled'
			}
		}
		
		/**
		 * @royalesuppressexport
		 */
		public static function hasCompilationOption(flags:uint, optionBits:uint):Boolean {
			COMPILE::SWF{
				return false;
			}
			COMPILE::JS{
				return Boolean((flags & optionBits) === optionBits);
			}
		}
		/**
		 * @royalesuppressexport
		 */
		public static function asStrings(flags:uint):Array {
			var ret:Array = [];
			COMPILE::JS{
				var source:Array = _ALL;
				const l:uint = source.length;
				for (var i:uint = 0; i < l; i++) {
					var itemFlag:uint = source[i];
					if (Boolean(flags & itemFlag)) {
						ret.push(_DESCRIPTIONS[itemFlag]);
					}
				}
			}
			return ret;
		}
		
		/**
		 * @royalesuppressexport
		 */
		public static function describeSingleFlag(flag:uint):String {
			var ret:String;
			COMPILE::JS{
				if (flag in _DESCRIPTIONS) {
					ret = _DESCRIPTIONS[flag];
				}
			}
			if (!ret) {
				ret = 'Unknown Compilation Flag';
			}
			return ret;
		}
		
		
		COMPILE::SWF
		public function CompilationData(inspect:Object) {
			throw new Error('CompilationData not implemented for swf');
		}
		
		COMPILE::JS
		/**
		 * @royaleignorecoercion Class
		 * 
		 */
		public function CompilationData(inspect:Object) {
			if (!inspect) throw new Error('CompilationData constructor parameter cannot be null');
			var constructor:Object = inspect.constructor;
			
			if (constructor === Object['constructor']) {
				//class or interface
				if (inspect.prototype && inspect.prototype.ROYALE_REFLECTION_INFO) {
					_qName = inspect.prototype.ROYALE_CLASS_INFO.names[0].qName;
					_flags = inspect.prototype.ROYALE_COMPILE_FLAGS;
					_class = inspect as Class;
				}
			} else {
				//instance
				if (inspect.ROYALE_REFLECTION_INFO) {
					_flags = inspect.ROYALE_COMPILE_FLAGS;
					_qName = inspect.ROYALE_CLASS_INFO.names[0].qName;
					_class = constructor as Class;
				}
			}
			if (!_qName) {
				throw new Error('This is not a Royale Class, cannot get compilation data');
			}
		}
		
		private var _class:Class;
		
		/**
		 * Check the ancestry for consistent compilation settings.
		 * @param specificFlags a flag or flag combination to check for on ancestor classes.
		 * 		  If not specified or less than zero, then it is the full set of flags on this
		 * 		  CompilationData.
		 * @return true if the ancestors have the same flags set, false otherwise
		 * 
		 * @royalesuppressexport
		 */
		public function hasSameAncestry(specificFlags:int = -1):Boolean{

			var checkFlags:uint = specificFlags > -1 ? specificFlags : _flags;
			COMPILE::JS{
				//check that the prototype chain has the same compile flags
				var proto:Object = _class.prototype;
				while (proto && proto.ROYALE_REFLECTION_INFO) {
					if (!hasCompilationOption(proto.ROYALE_COMPILE_FLAGS, checkFlags)) {
						return false;
					}
					proto = proto.constructor.superClass_;
				}
			}
			return true;
		}
		
		private var _qName:String;
		
		/**
		 *
		 */
		public function get qualifiedName():String{
			return _qName;
		}
		
		private var _flags:uint;
		/**
		 * the compilation flags applicable to the inspected item
		 */
		public function get flags():uint{
			return flags;
		}
		
		
		/**
		 * A string representation of this CompilationData definition
		 */
		public function toString():String {
			var s:String = "CompilationData for: '" + _qName + "\n";
			var contents:Array = asStrings(_flags);
			if (!contents.length) {
				s += '[no compilation flags recognized]\n';
			} else {
				s +=('[' + contents.join(',\n ') + ']\n');
			}
			return s;
		}
	}
}
