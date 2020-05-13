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
package org.apache.royale.crux.processors
{	
	COMPILE::SWF{
		import flash.utils.Dictionary;
	}

	import org.apache.royale.crux.Bean;
	import org.apache.royale.crux.ICruxAware;
	import org.apache.royale.crux.binding.*;
	import org.apache.royale.crux.metadata.InjectMetadataTag;
	import org.apache.royale.crux.reflection.IMetadataTag;
	import org.apache.royale.crux.reflection.MetadataHostClass;
	import org.apache.royale.crux.reflection.MetadataHostMethod;
	import org.apache.royale.crux.reflection.MetadataHostProperty;
	import org.apache.royale.crux.reflection.MethodParameter;
	import org.apache.royale.crux.utils.services.IServiceHelper;
	import org.apache.royale.crux.utils.services.IURLRequestHelper;
	import org.apache.royale.crux.utils.services.MockDelegateHelper;
	import org.apache.royale.crux.utils.services.ServiceHelper;
	import org.apache.royale.crux.utils.services.URLRequestHelper;
	import org.apache.royale.reflection.AccessorDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.utils.getMembersWithNameMatch;
	import org.apache.royale.utils.UIDUtil;

    /**
	 * Inject Processor
	 */
	public class InjectProcessor extends BaseMetadataProcessor
	{
		/**
		 * Constructor
		 */
		public function InjectProcessor(metadataNames:Array = null)
		{
			super( metadataNames == null ? [ INJECT ] : metadataNames, InjectMetadataTag );
		}

		protected static const INJECT:String = "Inject";
		
		// protected var logger:CruxLogger = CruxLogger.getLogger( this );
		protected var injectByProperty:Object = {};
		protected var sharedServiceHelper:IServiceHelper;
		protected var sharedURLRequestHelper:IURLRequestHelper;
		protected var sharedMockDelegateHelper:MockDelegateHelper;

		COMPILE::SWF
		protected var uidDict:Dictionary = new Dictionary(true);
		COMPILE::JS
		protected var uidDict:WeakMap = new WeakMap();

		
		/**
		 *
		 */
		override public function get priority():int
		{
			return ProcessorPriority.INJECT;
		}
		
		/**
		 * Add Inject
		 */
		override public function setUpMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var injectTag:InjectMetadataTag = metadataTag as InjectMetadataTag;

			
			// no source attribute means we're injecting by type
			if(injectTag.source == null)
			{
				addInjectByType(injectTag, bean);
			}
			else
			{
				// source attribute found - means we're injecting by name and potentially by property
				
				// try to obtain the bean by using the first part of the source attribute
				var namedBean:Bean = getBeanByName(injectTag.source.split(".")[0]);
				
				if(namedBean == null)
				{
					// if the bean was not found and is required, throw an error
					// if it's been set to not required we log a warning that it wasn't available
					if( injectTag.required )
						throw new Error( "InjectionProcessorError: bean not found: " + injectTag.source);
					else
						trace("InjectProcessor could not fulfill {0} tag on {1}", injectTag.asTag, bean);
					
					// bail
					return;
				}
				
				// this is a view added to the display list or a new bean being processed
				var destObject:Object = (injectTag.destination == null) ? bean.source : getDestinationObject(bean.source, injectTag.destination);
				// name of property that will be bound to a source value
				var destPropName:* = getDestinationPropertyName( injectTag );
				
				var chain:String = injectTag.source.substr( injectTag.source.indexOf( "." ) + 1 );
				var bind:Boolean = injectTag.bind && !( destPropName is QName );
				
				// if injecting by name simply assign the bean's current value
				// as there is no context to create a binding
				if( injectTag.source.indexOf( "." ) < 0 )
				{
					setDestinationValue( injectTag, bean, namedBean.source );
				}
				else if( !bind )
				{
					// if tag specified no binding or property is not bindable, do simple assignment
					var sourceObject:Object = getDestinationObject( namedBean.source, chain );
					setDestinationValue( injectTag, bean, sourceObject[ injectTag.source.split( "." ).pop() ] );
					
					if( destPropName is QName && injectTag.bind == true )
					{
						var errorStr:String = "Cannot create a binding for " + metadataTag.asTag + " because " + injectTag.source.split( "." ).pop() + " is not public. ";
						errorStr += "Add bind=false to your Inject tag or make the property public.";
						throw new Error( errorStr );
					}
				}
				else
				{
					// bind to bean property
					addPropertyBinding( destObject, destPropName, namedBean, injectTag/*, injectTag.twoWay*/ );
				}
			}
			
			trace("InjectProcessor set up "+metadataTag.toString()+" on " + bean.toString());
		}
		
		/**
		 * Remove Inject
		 */
		override public function tearDownMetadataTag( metadataTag:IMetadataTag, bean:Bean ):void
		{
			var injectTag:InjectMetadataTag = metadataTag as InjectMetadataTag;
			
			if( injectTag.source != null )
			{
				if( injectTag.source.indexOf( "." ) > -1 )
				{
					removeInjectByProperty( injectTag, bean );
				}
				else
				{
					removeInjectByName( injectTag, bean );
				}
			}
			else
			{
				removeInjectByType( injectTag, bean );
			}
			
			// logger.debug( "InjectProcessor tore down {0} on {1}", metadataTag.toString(), bean.toString() );
		}
		
		/**
		 *
		 */
		protected function getDestinationObject( destObject:Object, chainString:String ):Object
		{
			var arr:Array = chainString.split( "." );
			var dest:Object = destObject;
			while( arr.length > 1 )
				dest = dest[ arr.shift() ];
			return dest;
		}
		
		/**
		 *
		 */
		protected function getDestinationPropertyName( injectTag:InjectMetadataTag ):*
		{
			if( injectTag.destination == null )
			{
				return injectTag.host.name;
			}
			else
			{
				return injectTag.destination.split( "." ).pop();
			}
		}
		
		/**
		 * Remove Inject By Property
		 */
		protected function removeInjectByProperty( injectTag:InjectMetadataTag, bean:Bean ):void
		{
			var namedBean:Bean = getBeanByName( injectTag.source.split( "." )[ 0 ] );
			
			removePropertyBinding( bean, namedBean, injectTag );
			
			setDestinationValue( injectTag, bean, null );
		}
		
		/**
		 * Remove Inject By Name
		 */
		protected function removeInjectByName( injectTag:InjectMetadataTag, bean:Bean ):void
		{
			setDestinationValue( injectTag, bean, null );
		}
		
		/**
		 * Add Inject By Type
		 */
		protected function addInjectByType( injectTag:InjectMetadataTag, bean:Bean ):void
		{
			var setterInjection:Boolean = injectTag.host is MetadataHostMethod;
			var targetType:Class = ( setterInjection ) ? MethodParameter( MetadataHostMethod( injectTag.host ).parameters[ 0 ] ).type : injectTag.host.type;
			if( targetType == null && injectTag.host is MetadataHostClass )
			{
				// targetType = crux.domain.getDefinition( injectTag.host.name ) as Class;
			}
			var typedBean:Bean = getBeanByType( targetType );
			
			if( typedBean )
			{
				setDestinationValue( injectTag, bean, typedBean.source );
			}
			else
			{
				
				// helper classes can be created on demand so users don't have to declare them
				switch( targetType )
				{
					case ServiceHelper:
					case IServiceHelper:
						if( sharedServiceHelper == null )
						{
							sharedServiceHelper = new ServiceHelper();
							ICruxAware( sharedServiceHelper ).crux = crux;
						}
						
						setDestinationValue( injectTag, bean, sharedServiceHelper );
						return;
						
					case URLRequestHelper:
					case IURLRequestHelper:
						if( sharedURLRequestHelper == null )
						{
							sharedURLRequestHelper = new URLRequestHelper();
							ICruxAware( sharedURLRequestHelper ).crux = crux;
						}
						
						setDestinationValue( injectTag, bean, sharedURLRequestHelper );
						return;
						
					case MockDelegateHelper:
						if( sharedMockDelegateHelper == null )
							sharedMockDelegateHelper = new MockDelegateHelper();
						
						setDestinationValue( injectTag, bean, sharedMockDelegateHelper );
						return;
				}
				
				if( injectTag.required ) {
					throw new Error("InjectProcessor Error: bean of type " + targetType.toString() + " not found!" );
				}
				else {
					trace( "Bean of type "+ targetType.toString()+" not found, injection queues have been removed!" );
				}
				
			}
		}
		
		/**
		 * Remove Inject By Type
		 */
		protected function removeInjectByType( injectTag:InjectMetadataTag, bean:Bean ):void
		{
			setDestinationValue( injectTag, bean, null );
		}
		
		/**
		 * Set Destination Value
		 */
		protected function setDestinationValue( injectTag:InjectMetadataTag, bean:Bean, value:* ):void
		{
			var setterInjection:Boolean = injectTag.host is MetadataHostMethod;
			
			var destObject:Object = ( injectTag.destination == null ) ? bean.source : getDestinationObject( bean.source, injectTag.destination );
			var destPropName:* = getDestinationPropertyName( injectTag );
			
			if( setterInjection )
			{
				var f:Function = destObject[ destPropName ] as Function;
				f.apply( destObject, [ value ] );
			}
			else
			{
				var property:MetadataHostProperty = injectTag.host as MetadataHostProperty;
				if (property) {
					property.sourceDefinition.setValue(destObject, value);
				} else {
					trace('unexpected branch in \'setDestinationValue\'');
					destObject[ destPropName ] = value;
				}
			}
		}
		
		/**
		 * Get Bean By Name
		 */
		protected function getBeanByName(name:String):Bean
		{
			return beanFactory.getBeanByName(name);
		}
		
		/**
		 * Get Bean By Type
		 */
		protected function getBeanByType(type:Class):Bean
		{
			return beanFactory.getBeanByType(type);
		}
		
		
		/**
		 * Add Property Binding
		 */
		protected function addPropertyBinding( destObject:Object, destPropName:String, sourceBean:Bean, injectTag:InjectMetadataTag  ):void
		{
			var sourceObject:Object = sourceBean.source;
			var uid:String;
			
			var sourcePropertyChain:Array = injectTag.source.split( "." ).slice( 1 );
			// we have to track any bindings we create so we can unwire them later if need be
			
			// get the uid of our view/new bean
			COMPILE::SWF{
				uid = uidDict[destObject] || (uidDict[destObject] = UIDUtil.createUID());
			}
			COMPILE::JS{
				uid = uidDict.get(destObject);
				if (!uid) {
					uid =  UIDUtil.createUID();
					uidDict.set(destObject, uid);
				}
			}
			// create an array to store bindings for this object if one does not already exist
			injectByProperty[ uid ] ||= [];
			
			//get bindability chain
			var chain:Array = [];
			var typeDef:TypeDefinition = sourceBean.typeDescriptor.typeDefinition;
			var i:int = 0;
			var lastChainInfo:BindableChainInfo;
			while (i < sourcePropertyChain.length) {
				
				var bindabilityInfo:BindabilityInfo = new BindabilityInfo(typeDef);
				var propName:String = sourcePropertyChain[i];
				i++;
				var chainInfoElement:BindableChainInfo = new BindableChainInfo();
				chain.push(chainInfoElement);
				if (lastChainInfo) lastChainInfo.next = chainInfoElement;
				
				chainInfoElement.name = propName;
				chainInfoElement.changeEvents = bindabilityInfo.getChangeEvents(propName);
				var members:Array = [];
				getMembersWithNameMatch(typeDef.accessors, propName, members);
				if (members.length==1) {
					var accessor:AccessorDefinition = members[0] as AccessorDefinition;
					chainInfoElement.accessorDefinition = accessor;
					if (i < sourcePropertyChain.length) {
						typeDef = accessor.type;
					}
					lastChainInfo = chainInfoElement;
				} else {
					throw new Error('Unexpected result')
				}
				
			}
			
			// if destObject[ destPropName ] is a write-only property, checking if it's a function will throw an error in AVM
			try
			{
				// create and store this binding
				if( destObject[ destPropName ] is Function )
				{
					//handle 'setter' style destination:
					injectByProperty[ uid ].push( BindingUtils.bindProperty( destObject, destObject[ destPropName ], sourceObject, chain ) );
				}
				else
				{
					//handle 'destination chain' style destination:
					injectByProperty[ uid ].push( BindingUtils.bindProperty( destObject, destPropName, sourceObject, chain ) );
				}
			}
			catch( error:ReferenceError )
			{
				trace('todo ReferenceError caught', error)
			}
			
		}
		
		/**
		 * Remove Property Binding
		 */
		protected function removePropertyBinding( destination:Bean, source:Bean, injectTag:InjectMetadataTag ):void
		{
			var destObject:Object = ( injectTag.destination == null ) ? destination.source : getDestinationObject( destination.source, injectTag.destination );
			
			var uid:String;
			COMPILE::SWF{
				uid = uidDict[destObject];
			}
			COMPILE::JS{
				uid = uidDict.get(destObject);
			}
			if (uid) {
				var contents:Array = injectByProperty[ uid ];
				for each( var cb:CruxBinding in contents)
				{
					cb.unwatch()
				}
				delete injectByProperty[ uid ];
			}
		}
	}
}

