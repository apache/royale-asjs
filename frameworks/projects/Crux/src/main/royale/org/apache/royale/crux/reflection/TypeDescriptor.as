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
	import org.apache.royale.crux.CruxManager;
	import org.apache.royale.crux.factories.MetadataHostFactory;
	import org.apache.royale.reflection.MemberDefinitionBase;
	import org.apache.royale.reflection.MetaDataArgDefinition;
	import org.apache.royale.reflection.MetaDataDefinition;
	import org.apache.royale.reflection.ParameterDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.VariableDefinition;
	import org.apache.royale.reflection.utils.getMembersWithMetadata;
	import org.apache.royale.reflection.utils.getStaticConstantsByConvention;
	
    /**
	 * Object representation of a given type, based on <code>flash.utils.describeType</code>
	 * output and primarily focused on metadata.
	 */
    public class TypeDescriptor
	{
		private var mtd:MetaDataDefinition;
        private var mtdarg:MetaDataArgDefinition;
        private var vdef:VariableDefinition;
        private var pdef:ParameterDefinition;

        /**
		 * Constructor
		 */
        public function TypeDescriptor()
		{
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
        public var typeDefinition:TypeDefinition;
		
		/**
		 * The Class of this type.
		 * @royalesuppresspublicvarwarning
		 */
		public var type:Class;
		
		/**
		 * The fully qualified name of this type.
		 * @royalesuppresspublicvarwarning
		 */
		public var className:String;
		
		/**
		 * The constants defined by this class.
		 * @royalesuppresspublicvarwarning
		 */
		public var constants:Array = [];
		
		/**
		 * The fully qualified name of all superclasses this type extends.
		 * @royalesuppresspublicvarwarning
		 */
		public var superClasses:Array = [];
		
		/**
		 * The fully qualified name of all interfaces this type implements.
		 * @royalesuppresspublicvarwarning
		 */
		public var interfaces:Array = [];

        /**
		 * Dictionary of <code>IMetadataHost</code> instances for this type, keyed by name.
		 *
		 * @see org.apache.royale.crux.reflection.IMetadataHost
		 * @royalesuppresspublicvarwarning
		 */
        public var metadataHosts:Object;

        /**
		 * Gather and return all properties, methods or the class itself that
		 * are decorated with metadata.
		 *
		 * @return <code>IMetadataHost</code> instances
		 */
		protected function getMetadataHosts(description:TypeDefinition):Object
		{
			if(metadataHosts != null)
				return metadataHosts;
			
			metadataHosts = {};

			//@todo assume this is not including statics for now... ? review this!
			var members:Array = getMembersWithMetadata(typeDefinition, CruxManager.metadataNames, false);


			for each(var metaDef:MemberDefinitionBase in members) {
				for each(var defName:String in CruxManager.metadataNames) {
					var defNames:Array = metaDef.retrieveMetaDataByName(defName);
					if (defNames.length) {
						if (defNames.length > 1) {
							trace('unexpected - more than one metadata with the same name');
						}
						var metaDataDef:MetaDataDefinition = defNames[0];
						var host:IMetadataHost = getMetadataHost( metaDef );
						var metadataTag:IMetadataTag = new BaseMetadataTag();
						var args:Array = [];
						for each(var metaArg:MetaDataArgDefinition in metaDataDef.args) {
							args.push( new MetadataArg( metaArg.key, metaArg.value ) );
						}

						metadataTag.name = defName;
						metadataTag.args = args;
						metadataTag.host = host;
						host.metadataTags.push( metadataTag )
					}
				}
			}
			
			return metadataHosts;
		}

        /**
		 * Get <code>IMetadataHost</code> for provided MemberDefinitionBase.
		 *
		 * @param hostNode Node from <code>flash.utils.describeType</code> output
		 * @return <code>IMetadataHost</code> instance
		 */
		protected function getMetadataHost( hostNode:MemberDefinitionBase ):IMetadataHost
		{
			// name of property/method
			var metadataHostName:String = hostNode.name;
			
			// if it has already been created, return it and bail
			if( metadataHosts[ metadataHostName ] != null )
				return IMetadataHost( metadataHosts[ metadataHostName ] );
			
			// otherwise create, store and return it
			return metadataHosts[ metadataHostName ] = MetadataHostFactory.getMetadataHost(hostNode);
			
		}


        /**
		 * Populates the <code>TypeDescriptor</code> instance from the data returned
		 * by <code>org.apache.royale.reflection.describeType</code>.
		 *
		 * @see org.apache.royale.reflection.describeType
		 */
		public function fromTypeDefinition(typeDefinition:TypeDefinition):TypeDescriptor
		{
			this.typeDefinition = typeDefinition;
			
			className = typeDefinition.qualifiedName;
			constants = getStaticConstantsByConvention(typeDefinition.getClass());

			superClasses = typeDefinition.baseClasses;
			interfaces = typeDefinition.interfaces;
			
			metadataHosts = getMetadataHosts(typeDefinition);
			
			return this;
		}



        /**
		 * Determine whether or not this class has any instances of
		 * metadata tags with the provided name.
		 *
		 * @param metadataTagName
		 * @return Flag indicating whether or not the metadata tag is present
		 */
		public function hasMetadataTag( metadataTagName:String ):Boolean
		{
			for each( var metadataHost:IMetadataHost in metadataHosts )
			{
				for each( var metadataTag:IMetadataTag in metadataHost.metadataTags )
				{
					if( metadataTag.name.toLowerCase() == metadataTagName.toLowerCase() )
						return true;
				}
			}
			return false;
		}
		
		/**
		 * Get all <code>IMetadataHost</code> instances for this type that are decorated
		 * with metadata tags with the provided name.
		 *
		 * @param metadataTagName Name of tags to retrieve
		 * @return <code>IMetadataHost</code> instances
		 */
		public function getMetadataHostsWithTag( metadataTagName:String ):Array
		{
			var hosts:Array = [];
			
			for each( var metadataHost:IMetadataHost in metadataHosts )
			{
				for each( var metadataTag:IMetadataTag in metadataHost.metadataTags )
				{
					if( metadataTag.name.toLowerCase() == metadataTagName.toLowerCase() )
					{
						hosts.push( metadataHost );
						continue;
					}
				}
			}
			
			return hosts;
		}
		
		/**
		 * Get all <code>IMetadataTag</code> instances for class member with the provided name.
		 *
		 * @param tagName Name of metadata tags to find
		 * @return <code>IMetadataTag</code> instances
		 */
		public function getMetadataTagsByName( tagName:String ):Array
		{
			var tags:Array = [];
			
			for each( var metadataHost:IMetadataHost in metadataHosts )
			{
				for each( var metadataTag:IMetadataTag in metadataHost.metadataTags )
				{
					if( metadataTag.name.toLowerCase() == tagName.toLowerCase() )
					{
						tags.push( metadataTag );
					}
				}
			}
			
			return tags;
		}
		
		/**
		 * Get all <code>IMetadataTag</code> instances for class member with the provided name.
		 *
		 * @param memberName Name of class member (property or method)
		 * @return  <code>IMetadataTag</code> instances
		 */
		public function getMetadataTagsForMember( memberName:String ):Array
		{
			var tags:Array;
			
			for each( var metadataHost:IMetadataHost in metadataHosts )
			{
				if( metadataHost.name == memberName )
				{
					tags = metadataHost.metadataTags;
				}
			}
			
			return tags;
		}
		
		/**
		 * Return all <code>MetadataHostProperty</code> instances for this type.
		 *
		 * @return <code>MetadataHostProperty</code> instances
		 *
		 * @see org.apache.royale.crux.reflection.MetadataHostProperty
		 */
		public function getMetadataHostProperties():Array
		{
			var hostProps:Array = [];
			
			for each( var metadataHost:IMetadataHost in metadataHosts )
			{
				if( metadataHost is MetadataHostProperty )
				{
					hostProps.push( metadataHost );
					continue;
				}
			}
			
			return hostProps;
		}
		
		/**
		 * Return all <code>MetadataHostMethod</code> instances for this type.
		 *
		 * @return <code>MetadataHostMethod</code> instances
		 *
		 * @see org.apache.royale.crux.reflection.MetadataHostMethod
		 */
		public function getMetadataHostMethods():Array
		{
			var hostMethods:Array = [];
			
			for each( var metadataHost:IMetadataHost in metadataHosts )
			{
				if( metadataHost is MetadataHostMethod )
				{
					hostMethods.push( metadataHost );
					continue;
				}
			}
			
			return hostMethods;
		}
		
		/**
		 * Returns true if this descriptor's className, superClass, or any interfaces
		 * match a typeName.
		 */
		public function satisfiesType( typeName:String ):Boolean
		{
			COMPILE::SWF{
				typeName = typeName.replace("::", ".");
			}
			if( className == typeName )
				return true;
			
			for each( var superClass:String in superClasses )
				if( superClass == typeName )
					return true;
			
			for each( var interfaceName:String in interfaces )
				if( interfaceName == typeName )
					return true;
			
			return false;
		}
    }
}
