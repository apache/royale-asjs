package nl.ixms.vo
{

import mx.utils.StringUtil;

import nl.ixms.Utils;

import org.as3commons.lang.ClassUtils;
import org.as3commons.reflect.BaseParameter;
import org.as3commons.reflect.Constructor;
import org.as3commons.reflect.Parameter;
import org.as3commons.reflect.Type;

public final class Clazz
{
	//----------------------------------------------------------------------
	//
	//  Class Constants 
	//
	//----------------------------------------------------------------------
	
	public static const MEMBER_SEPARATOR:String = ';\n\n\n';

	
	
	//----------------------------------------------------------------------
	//
	//  Constants 
	//
	//----------------------------------------------------------------------
	
	public function Clazz(type:Type) {
		this.type_ = type;
	}
	

	
	//----------------------------------------------------------------------
	//
	//  Constants 
	//
	//----------------------------------------------------------------------
	
	private const ES5_STRICT:String = '\'use strict\';\n\n';
	
	private const GOOG_INHERITS:String = 'goog.inherits({0}, {1});';
	
	private const GOOG_PROVIDE:String = 'goog.provide(\'{0}\');';
	
	private const GOOG_REQUIRE:String = 'goog.require(\'{0}\');';
	
	private const JSDOC_FILE_OVERVIEW:String = 
		'/**\n' +
		' * @fileoverview \'{0}\'\n' +
		' *\n' +
		' * @author erikdebruin@apache.org (Erik de Bruin)\n' +
		' */\n\n';
	
	private const JS_BLOCK_COMMENT_MAJOR:String = 
		'//------------------------------------------------------------------' +
		    '------------\n' +
		'//\n' +
		'//  {0}\n' + 
		'//\n' +
		'//------------------------------------------------------------------' +
		    '------------\n\n\n';
	
	private const JS_METADATA:String = 
		'{0}.prototype.FLEXJS_CLASS_INFO =\n' +
		'    { names: [{ name: \'{1}\', qName: \'{0}\'}],\n' + 
		'      interfaces: [{2}] }';
	
	private const JS_CONSTRUCTOR:String = '{0} = function({1}) {{3}{2}};{4}\n';
	
	
	
	//----------------------------------------------------------------------
	//
	//  Properties 
	//
	//----------------------------------------------------------------------
	
	//--------------------------------------
	//  compositeClazz 
	//--------------------------------------
	
	private var compositeClazz_:Type;
	
	private var compositeClazzIsSet_:Boolean;
	
	public function get compositeClazz():Type {
		var compositeClazzInterface:String,
			compositeClazzNameArr:Array;
		
		if (!compositeClazzIsSet_) {
			if (this.qName.indexOf('flash.') === 0) {
				compositeClazzNameArr = compositeClazzName.split('.');
				compositeClazzNameArr[compositeClazzNameArr.length - 1] = 'I' + 
					compositeClazzNameArr[compositeClazzNameArr.length - 1];
				compositeClazzInterface = compositeClazzNameArr.join('.');
				
				compositeClazz_ = Type.forName(compositeClazzInterface);
			}
			
			compositeClazzIsSet_ = true;
		}
		
		return compositeClazz_;
	}
	
	//--------------------------------------
	//  compositeClazzName
	//--------------------------------------
	
	public function get compositeClazzName():String {
		return this.qName.replace('flash', 'vf2js');
	}
	
	//--------------------------------------
	//  interfaces 
	//--------------------------------------
	
	private var interfaces_:Array;
	
	private var interfacesIsSet_:Boolean;
	
	public function get interfaces():Array {
		var i:int,
			j:int,
			superInterfaces:Array,
			superInterfacesClazz:Class;
		
		if (!interfacesIsSet_) {
			interfaces_ = this.type.interfaces;
			superInterfacesClazz = ClassUtils.getSuperClass(this.type.clazz);
			if (superInterfacesClazz && interfaces_.length > 0) {
				superInterfaces = 
					ClassUtils.getFullyQualifiedImplementedInterfaceNames(
						superInterfacesClazz);
				if (superInterfaces) {
					for (i = interfaces_.length - 1; i > -1; i--) {
						for (j = superInterfaces.length - 1; j > -1; j--) {
							if (interfaces_[i] === 
									Utils.cleanClassQName(superInterfaces[j])) {
								interfaces_.splice(i, 1);
								
								break;
							}
						}
					}
				}
			}
			
			interfacesIsSet_ = true;
		}
		
		return interfaces_;
	}
	
	//--------------------------------------
	//  name 
	//--------------------------------------
	
	private var name_:String;

	public function get name():String {
		return name_;
	}
	
	public function set name(value:String):void {
		if (name_ === value) {
			return;
		}
		
		name_ = value;
	}
	
	//--------------------------------------
	//  output 
	//--------------------------------------
	
	private var output_:String;

	public function get output():String {
		return output_;
	}

	public function set output(value:String):void {
		if (output_ === value) {
			return;
		}
		
		output_ = value;
	}

	//--------------------------------------
	//  qName 
	//--------------------------------------
	
	private var qName_:String;
	
	public function get qName():String {
		return qName_;
	}
	
	public function set qName(value:String):void {
		if (qName_ === value) {
			return;
		}
		
		qName_ = value;
	}
	
	//--------------------------------------
	//  requires 
	//--------------------------------------
	
	private var requires_:Array;
	
	private var requiresIsSet_:Boolean;
	
	public function get requires():Array {
		var i:int,
			n:int;
		
		if (!requiresIsSet_) {
			requires_ = [];
			
			if (superClazz) {
				requires_.push(superClazz);
			}
			
			if (compositeClazz) {
				requires_.push(compositeClazzName);
			}
			
			for (i = 0, n = interfaces.length; i < n; i++) {
				requires_.push(interfaces[i]);
			}
			
			requires_.sort();
			
			requiresIsSet_ = true;
		}
		
		return requires_;
	}
	
	//--------------------------------------
	//  superClazz 
	//--------------------------------------
	
	private var superClazz_:String;
	
	private var superClazzIsSet_:Boolean;
	
	public function get superClazz():String {
		if (!superClazzIsSet_) {
			if (this.type.extendsClasses.length > 0) {
				superClazz_ = 
					Utils.cleanClassQName(this.type.extendsClasses[0]);
				if (superClazz_ === 'Object' && this.qName !== 'Class') {
					superClazz_ = 'Class';
				}
			}
			
			superClazzIsSet_ = true;
		}
		
		return superClazz_;
	}
	
	//--------------------------------------
	//  type 
	//--------------------------------------
	
	private var type_:Type;
	
	public function get type():Type {
		return type_;
	}
	
	public function set type(value:Type):void {
		if (type_ === value) {
			return;
		}
		
		type_ = value;
	}

	
	
	//----------------------------------------------------------------------
	//
	//  Methods 
	//
	//----------------------------------------------------------------------
	
	//--------------------------------------
	//  addConstructor
	//--------------------------------------
	
	private function addConstructor():void {
		var baseParameter:BaseParameter,
			compositeClazzLine:String,
			i:int,
			n:int,
			parameter:Parameter,
			parameterName:String,
			parameterNames:String,
			parameterNamesArray:Array,
			parameters:Array,
			tmp1:String,
			tmp2:String;
		
		tmp1 = '';
		tmp2 = '';
		
		compositeClazzLine = '';
		
		if (!this.type) { // function (e.g. flash.utils.getDefinitionByName)
			/*
			flash.net.navigateToURL
			+flash.utils.getDefinitionByName
			flash.net.getClassByAlias
			flash.utils.flash_proxy
			flash.utils.getQualifiedClassName
			flash.utils.clearInterval
			flash.utils.setTimeout
			flash.utils.describeType
			flash.utils.getTimer
			flash.net.sendToURL
			flash.system.fscommand
			flash.crypto.generateRandomBytes
			flash.utils.setInterval
			flash.utils.escapeMultiByte
			flash.utils.getQualifiedSuperclassName
			flash.utils.unescapeMultiByte
			flash.utils.clearTimeout
			flash.net.registerClassAlias
			mx.core.mx_internal
			flash.utils.getAliasName
			*/

			baseParameter = new BaseParameter('String', null, false);
			parameter = new Parameter(baseParameter, 0);
			
			parameterName = 'arg0';
			
			if (compositeClazz) {
				compositeClazzLine = '\n  return this.$_implementation = new ' + 
					compositeClazzName + '(' + parameterName + ');\n';
			}
			
			this.requires_ = [];
			if (compositeClazzName === 'vf2js.utils.getDefinitionByName') {
				this.requires_.push(compositeClazzName);
			}
			this.requiresIsSet_ = true;
			this.addGoogRequires();
			
			this.output += JSDoc.emitJSDoc(JSDoc.CONSTRUCTOR, '', '', 
				[parameter]);
			
			this.output += StringUtil.substitute(JS_CONSTRUCTOR, 
				[this.qName,
				 [parameterName],
				 compositeClazzLine,
				 tmp1,
				 tmp2]);
		} else {
			parameters = Constructor(this.type.constructor).parameters;
			
			parameterNamesArray = [];
			for (i = 0, n = parameters.length; i < n; i++) {
				parameterNamesArray.push(
					((Parameter(parameters[i]).isOptional) ? 'opt_' : '') + 
					'arg' + i);
			}
			parameterNames = parameterNamesArray.join(', ');
			if (superClazz && !(this.qName === 'Class')) {
				tmp1 = '\n  ' + this.qName + '.base(this, \'constructor\'' + 
					((parameterNamesArray.length > 0) ? ', ' : '') + 
					parameterNames + ');\n';
				tmp2 = '\n' + StringUtil.substitute(GOOG_INHERITS, 
					[this.qName, superClazz]);
			}
			
			if (compositeClazz) {
				compositeClazzLine = '';
				compositeClazzLine += '\n  /**';
				compositeClazzLine += '\n   * @type {' + compositeClazzName + '}';
				compositeClazzLine += '\n   */';
				compositeClazzLine += '\n  this.$_implementation = new ' + 
					compositeClazzName + '(' + parameterNames + ');\n';
			}
			
			this.addGoogRequires();
			
			this.output += JSDoc.emitJSDoc(
				((this.type.isInterface) ? 
					JSDoc.INTERFACE : 
					JSDoc.CONSTRUCTOR), 
				superClazz, interfaces, parameters);
			
			this.output += StringUtil.substitute(JS_CONSTRUCTOR, 
				[this.qName,
				 parameterNames,
				 compositeClazzLine,
				 tmp1,
				 tmp2]);
		}
		
		this.output += '\n\n';
		
		this.addMetaData();
	}
	
	//--------------------------------------
	//  addGoogRequire
	//--------------------------------------
	
	private function addGoogRequire(qName:String):void {
		this.output += StringUtil.substitute(GOOG_REQUIRE, [qName]);
	}
	
	//--------------------------------------
	//  addGoogRequires
	//--------------------------------------
	
	private function addGoogRequires():void {
		var i:int,
			n:int;
		
		if (requires[0] !== 'Object') {
			this.output += ((requires.length > 0) ? '\n' : '');
			
			for (i = 0, n = requires.length; i < n; i++) {
				this.addGoogRequire(requires[i]);
				this.output += '\n';
			}
		}
		
		this.output += '\n\n\n';
	}
	
	//--------------------------------------
	//  addMajorBlockComment 
	//--------------------------------------
	
	public function addMajorBlockComment(type:String):void {
		this.output += StringUtil.substitute(JS_BLOCK_COMMENT_MAJOR, [type]);
	}
	
	//--------------------------------------
	//  addMetaData
	//--------------------------------------
	
	private function addMetaData():void {
		this.output += JSDoc.emitJSDoc(JSDoc.METADATA);
		
		this.output += StringUtil.substitute(JS_METADATA, 
			[this.qName, this.name, ((interfaces_) ? interfaces_ : [''])]);
		
		this.output += '\n\n\n';
	}
	
	//--------------------------------------
	//  startOutput 
	//--------------------------------------
	
	public function startOutput():void {
		this.output = '';
		
		this.output += StringUtil.substitute(JSDOC_FILE_OVERVIEW, 
			[this.qName_]); 
		
		this.output += ES5_STRICT; 
		
		this.output += StringUtil.substitute(GOOG_PROVIDE, [this.qName_]); 
		
		this.output += '\n';
		
		this.addConstructor();
	}
	
}

}