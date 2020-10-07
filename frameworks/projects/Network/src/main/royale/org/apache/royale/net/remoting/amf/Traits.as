////////////////////////////////////////////////////////////////////////////////
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
/***
 * Based on the
 * AMF JavaScript library by Emil Malinov https://github.com/emilkm/amfjs
 */
package org.apache.royale.net.remoting.amf {



COMPILE::JS
/**
 * @royalesuppressexport
 */
internal class Traits  {
	import goog.DEBUG;


	public static function createInstanceVariableGetterSetter(reflectionFunction:Function, type:String):Object{
		var ret:Object = {
			setValue: function(inst:Object, value:*):void {
				reflectionFunction(inst, value);
			}
		};

		if (type == "*") {
			ret.getValue =
					function(inst:Object):* {
						return reflectionFunction(inst, reflectionFunction);
					}
		} else {
			ret.getValue =
					function(inst:Object):* {
						return reflectionFunction(inst);
					}
		}
		return ret;
	}

	public static function createInstanceAccessorGetterSetter(fieldName:String):Object{
		return {
			getValue: function(inst:Object):* {
				return inst[fieldName];
			},
			setValue: function(inst:Object, value:*):void {
				inst[fieldName] = value;
			}
		};
	}

	public static function markTransient(fieldName:String, traits:Traits):void{
		if (!traits.transients) traits.transients={};
		traits.transients[fieldName] = true;
	}

	private static var _emtpy_object:Traits;



	public static function getClassTraits(fields:Array, qName:String):Traits{
		var traits:Traits = new Traits();
		traits.qName = '[Class] '+ qName;
		traits.isDynamic = true;
		traits.externalizable = false;
		traits.props = fields;

		return traits;
	}

	public static function getBaseObjectTraits():Traits {
		if (_emtpy_object) return _emtpy_object;
		var traits:Traits = _emtpy_object = new Traits();
		traits.qName = 'Object';
		traits.externalizable = false;
		traits.isDynamic = true;
		return traits;
	}

	public static function getDynObjectTraits(fields:Array):Traits {
		var traits:Traits;
		traits = new Traits();
		traits.qName = 'Object';
		traits.externalizable = false;
		traits.isDynamic = true;
		traits.props = fields;
		return traits;
	}

	public var alias:String = '';
	public var qName:String;
	public var externalizable:Boolean;
	public var isDynamic:Boolean;
	public var count:uint = 0;
	public var props:Array = [];
	public var nullValues:Object = {};

	public var getterSetters:Object = {};
	public var transients:Object ;

	public function hasProp(prop:String):Boolean {
		return props.indexOf(prop) != -1;
	}

	public function isTransient(prop:String):Boolean {
		return transients && prop in transients;
	}

	public function toString():String {
		if (goog.DEBUG) {
			return 'Traits for \'' + qName + '\'\n'
					+ 'alias: \'' + alias + '\'\n'
					+ 'externalizable:' + Boolean(externalizable) + '\n'
					+ 'isDynamic:' + Boolean(isDynamic) + '\n'
					+ 'count:' + count + '\n'
					+ 'props:\n\t' + props.join('\n\t');
		} else {
			return 'Traits';
		}
	}
	}
}


