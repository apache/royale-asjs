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
package org.apache.royale.crux.factories
{
    import org.apache.royale.crux.reflection.IMetadataHost;
    import org.apache.royale.crux.reflection.MetadataHostClass;
    import org.apache.royale.crux.reflection.MetadataHostMethod;
    import org.apache.royale.crux.reflection.MetadataHostProperty;
    import org.apache.royale.crux.reflection.MethodParameter;
    import org.apache.royale.reflection.DefinitionWithMetaData;
    import org.apache.royale.reflection.MethodDefinition;
    import org.apache.royale.reflection.ParameterDefinition;
    import org.apache.royale.reflection.TypeDefinition;
    import org.apache.royale.reflection.VariableDefinition;
    import org.apache.royale.reflection.getDefinitionByName;

	/**
	 * Simple factory to create the different kinds of metadata
	 * hosts and to encapsulate the logic for determining which type
	 * should be created.
	 */
	public class MetadataHostFactory
	{
		public function MetadataHostFactory()
		{
			
		}
		
		/**
		 * Returns an <code>IMetadataHost</code> instance representing a property,
		 * method or class that is decorated with metadata.
		 *
		 * @param hostNode DefinitionWithMetaData node representing a property, method or class
		 * @return <code>IMetadataHost</code> instance
		 *
		 * @see org.apache.royale.crux.reflection.MetadataHostClass
		 * @see org.apache.royale.crux.reflection.MetadataHostMethod
		 * @see org.apache.royale.crux.reflection.MetadataHostProperty
		 */
		public static function getMetadataHost(hostNode:DefinitionWithMetaData):IMetadataHost
		{
			var host:IMetadataHost;
			
			// property, method or class?
			if( hostNode is TypeDefinition )
			{
				host = new MetadataHostClass();
				host.type = getDefinitionByName(TypeDefinition(hostNode).qualifiedName) as Class;
			}
			else if( hostNode is MethodDefinition )
			{
				var metadataHostMethod:MetadataHostMethod = new MetadataHostMethod();
				host = metadataHostMethod;
				var method:MethodDefinition = hostNode as MethodDefinition;
				
				if( method.returnType.qualifiedName != "void" && method.returnType.qualifiedName != "*" )
				{
					metadataHostMethod.returnType = Class( getDefinitionByName( method.returnType.qualifiedName ) );
				}
				
				for each( var pNode:ParameterDefinition in method.parameters )
				{
					var pType:Class = pNode.type.qualifiedName == "*" ? Object : Class( getDefinitionByName( pNode.type.qualifiedName ) );
					metadataHostMethod.parameters.push( new MethodParameter( pNode.index, pType, pNode.optional ) );
				}

				metadataHostMethod.sourceDefinition = method;
			}
			else
			{
				//it is either an VariableDefinition or an AccessorDefinition (which is a subclass of VariableDefinition)
				var varDef:VariableDefinition = hostNode as VariableDefinition;
				var metadataHostProperty:MetadataHostProperty =  new MetadataHostProperty();
				host = metadataHostProperty;
				metadataHostProperty.sourceDefinition = varDef;
				metadataHostProperty.type = varDef.type.qualifiedName == "*" ? Object : Class( getDefinitionByName( varDef.type.qualifiedName ) );
			}
			
			host.name = hostNode.name;
			
			return host;
		}
	}
}
