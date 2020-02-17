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
    import org.apache.royale.reflection.TypeDefinition;
    import org.apache.royale.reflection.describeType;
    import org.apache.royale.reflection.getQualifiedClassName;
    import org.apache.royale.reflection.utils.getStaticConstantsByConvention;
    /**
	 * Static class used to ensure each type is only inspected via <code>describeType</code>
	 * a single time.
	 */
	public class TypeCache
	{
		/**
		 * Object of previously inspected types.
		 */
		protected static var typeDescriptors:Object;


		/**
		 * Object of previously inspected types.
		 */
		protected static var staticConstantCollections:Object;
		
		/**
		 * Will return TypeDescriptor instance either retrieved from cache or freshly
		 * constructed from <code>describeType</code> call.
		 *
		 * @param target Object whose type is to be inspected and returned.
		 * @param domain to associate the typeDescriptors with
		 * 
		 * @return TypeDescriptor instance representing the type of the object that was passed in.
		 */
		public static function getTypeDescriptor(target:Object):TypeDescriptor
		{
			// make sure our Dictionary has been initialized
			typeDescriptors ||= {};
			
			// check for this type in Dictionary and return it if it already exists
			var className:String = getQualifiedClassName(target);
			if(typeDescriptors[className] != null)
				return typeDescriptors[className];
			// type not found in cache so create, store and return it here
			var definition:TypeDefinition = describeType(target);
			var typeDescriptor:TypeDescriptor = new TypeDescriptor();
			typeDescriptors[className] = typeDescriptor.fromTypeDefinition(definition);
			// return typeDescriptors[ className ] = new TypeDescriptor().fromXML( describeType( domain.getDefinition( className ) ));
			return typeDescriptors[className];
		}

		/**
		 * Will return static constant array instance either retrieved from cache or freshly
		 * constructed from a utility reflection method call.
		 *
		 * @param target Class whose type is to be inspected for return value.
		 *
		 * @return TypeDescriptor instance representing the type of the object that was passed in.
		 */
		public static function getStaticConstantCollection(target:Object):Array
		{
			var classRef:Class = target is Class ? target as Class : target.constructor;
			var className:String = getQualifiedClassName(classRef);

			// make sure our Dictionary has been initialized
			staticConstantCollections ||= {};

			if (staticConstantCollections[className] != null) return staticConstantCollections[className];

			var collection:Array = getStaticConstantsByConvention(classRef);

			staticConstantCollections[className] = collection;
			return collection;
		}
		
		/**
		 * Flushes all TypeDescriptors associated to a Domain
		 */
		// public static function flushDomain( ApplicationDomain ) :void
		// {
		// 	for( var key:Object in typeDescriptors )
		// 	{
		// 		if( TypeDescriptor( typeDescriptors[ key ] ).domain == domain )
		// 			delete typeDescriptors[ key ];
		// 	}
		// }
	}
}
