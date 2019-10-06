/*
 * Copyright 2010 Swiz Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.apache.royale.crux.reflection
{
	//import flash.system.ApplicationDomain;
	import  org.apache.royale.reflection.getQualifiedClassName;
	import  org.apache.royale.reflection.getDefinitionByName;

	public class ClassConstant
	{
		// ========================================
		// protected static constants
		// ========================================
		
		/**
		 * Class constant regular expression.
		 *
		 * Matches: Class.CONSTANT or package.Class.CONSTANT
		 * Captures: class, constant name
		 */
		protected static const CLASS_CONSTANT_PATTERN:RegExp = /([^.]+)\.([A-Z0-9_*]+)$/;
		
		/**
		 * Class package constant regular expression.
		 *
		 * Matches: package.Class.CONSTANT
		 * Captures: package, class, constant name
		 */
		protected static const CLASS_PACKAGE_CONSTANT_PATTERN:RegExp = /^(.*)\.([^.]+)\.([A-Z0-9_*]+)$/;
		
		// ========================================
		// public static methods
		// ========================================
		
		/**
		 * Evaluates whether the specified value defines a class constant.  (Ex. 'Class.CONSTANT')
		 *
		 * @param value A text value that potentially defines a class constant.
		 * @returns A Boolean evaluation of whether the specified value defines a class constant.
		 */
		public static function isClassConstant( value:String ):Boolean
		{
			return CLASS_CONSTANT_PATTERN.exec( value );
		}
		
		/**
		 * Gets the class name portion of a class constant.
		 *
		 * @param constant A String that defines a class constant. (Ex. 'Class.CONSTANT')
		 * @returns Returns the class name portion of a class constant. (Ex. 'Class' for 'Class.CONSTANT')
		 */
		public static function getClassName( constant:String ):String
		{
			var match:Object = CLASS_CONSTANT_PATTERN.exec( constant );
			if( match )
				return match[ 1 ] as String;
			
			return null;
		}
		
		/**
		 * Gets the constant name portion of a class constant.
		 *
		 * @param constant A String that defines a class constant. (Ex. 'Class.CONSTANT')
		 * @returns Returns the constant name portion of a class constant. (Ex. 'CONSTANT' for 'Class.CONSTANT')
		 */
		public static function getConstantName( constant:String ):String
		{
			var match:Object = CLASS_CONSTANT_PATTERN.exec( constant );
			if( match )
				return match[ 2 ] as String;
			
			return null;
		}
		
		/**
		 * Gets the associated value for the specified class and class constant name.
		 *
		 * @param definition The class definition.
		 * @param constantName The constant name.
		 * @param constantType The expected constant type.
		 * @return Returns the associated value for the specified class constant.
		 */
		public static function getConstantValue( definition:Class, constantName:String, constantType:String = "String" ):*
		{

			var constants:Array = TypeCache.getStaticConstantCollection(definition)

			
			
			if( constants.indexOf(constantName) == -1 )
			{
				throw new Error( getQualifiedClassName( definition ) + " has no constant named " + constantName + "." );
			}
//@todo get type for constantType... and check value
			/*var nodeType:String = node.@type;
			if( nodeType != constantType )
			{
				throw new Error( getQualifiedClassName( definition ) + "." + constantName + " is not typed " + constantType + " but instead is typed as " + nodeType + "." );
			}*/
			
			return definition[ constantName ];
		}
		
		/**
		 * Gets the class referenced by the specified relative or fully qualified class constant.
		 *
		 * @param constant A relative or fully qualified class constant.
		 * @param packageNames A set of package names to search to for a relative class constant.  (Optional)
		 * @returns The class referenced by the specified class constant, if found. Otherwise, returns null.
		 */
		public static function getClass( constant:String, packageNames:Array = null):Class
		{
			var match:Object = CLASS_CONSTANT_PATTERN.exec( constant );
			if( match )
			{
				var className:String = match[ 1 ] as String;
				//var constantName:String = match[ 2 ] as String;
				
				var packageMatch:Object = CLASS_PACKAGE_CONSTANT_PATTERN.exec( constant );
				if( packageMatch )
				{
					var packageName:String = packageMatch[ 1 ] as String;
					
					return getClassDefinition( packageName + "." + className );
				}
				else
				{
					return findClassDefinition(  className, packageNames );
				}
			}
			
			return null;
		}
		
		// ========================================
		// protected static methods
		// ========================================
		
		/**
		 * Finds the class definition given a class name and set of potential package names.
		 *
		 * @param className The class name.
		 * @param packageNames The set of potential package names to search.
		 * @returns Returns the class definition if found. Otherwise returns null.
		 */
		protected static function findClassDefinition( className:String, packageNames:Array ):Class
		{
			for each( var packageName:String in packageNames )
			{
				var definition:Class = getClassDefinition( packageName + "." + className );
				if( definition != null )
					return definition;
			}
			
			return null;
		}
		
		/**
		 * Safely returns a reference to the class object of the class specified by the name parameter.
		 *
		 * @param name The fully qualified name of a class.
		 * @returns Returns a reference to the class object of the class specified by the name parameter.
		 */
		protected static function getClassDefinition( name:String ):Class
		{
			try
			{
				return getDefinitionByName( name ) as Class;
			}
			catch( e:ReferenceError )
			{
			}
			
			return null;
		}
	}
}
