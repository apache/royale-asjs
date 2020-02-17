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
package org.apache.royale.crux
{
	COMPILE::SWF{
		import flash.events.Event;
	}
	COMPILE::JS{
		import goog.events;

		import org.apache.royale.events.Event;
	}
	import org.apache.royale.core.IFlexInfo;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.crux.events.BeanEvent;
	import org.apache.royale.crux.events.CruxEvent;
	import org.apache.royale.crux.processors.IBeanProcessor;
	import org.apache.royale.crux.processors.IFactoryProcessor;
	import org.apache.royale.crux.processors.IMetadataProcessor;
	import org.apache.royale.crux.processors.IProcessor;
	import org.apache.royale.crux.reflection.TypeCache;
	import org.apache.royale.crux.utils.view.simulatedSingleEnterFrame;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.reflection.getQualifiedClassName;

    public class BeanFactory extends EventDispatcher implements IBeanFactory
	{
        /**
		 * Constructor
		 */
		public function BeanFactory()
		{
			super();
		}

		protected const ignoredClasses:RegExp = /^mx\.|^spark\.|^flash\.|^fl\.|^org\.apache\.royale\.|__/;
        
		protected var crux:ICrux;

		protected var _parentBeanFactory:IBeanFactory;
		
        protected var _beans:Array = [];

		protected var removedDisplayObjects:Array = [];

		protected var isListeningForEnterFrame:Boolean = false;

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var waitForSetup:Boolean = false;

        public function get beans():Array
		{
			return _beans;
		}

		public function setUp(crux:ICrux):void
		{
			this.crux = crux;
			
			crux.dispatcher.addEventListener(BeanEvent.ADD_BEAN, handleBeanEvent);
			crux.dispatcher.addEventListener(BeanEvent.SET_UP_BEAN, handleBeanEvent);
			crux.dispatcher.addEventListener(BeanEvent.TEAR_DOWN_BEAN, handleBeanEvent);
			crux.dispatcher.addEventListener(BeanEvent.REMOVE_BEAN, handleBeanEvent);
			
			for each(var beanProvider:IBeanProvider in crux.beanProviders)
			{
				addBeanProvider(beanProvider, false);
			}
			
			// run any factory processors before setting up any beans
			runFactoryProcessors();
			
			// todo: everything else should be delayed if the factoryProcessor initialized an aop autoproxy processor
			completeBeanFactorySetup();
		}

		/**
		 * Executes any Factory Processors
		 */
		public function runFactoryProcessors():void
		{
			for each(var processor:IProcessor in crux.processors)
			{
				// Handle Metadata Processors
				if(processor is IFactoryProcessor)
				{
					IFactoryProcessor(processor).setUpFactory(this);
				}
			}
		}

		public function completeBeanFactorySetup():void
		{
			if( waitForSetup )
				return;
			
			//trace("BeanFactory completing setup");
			
			// bean setup has to be delayed until after all startup beans have been added
			for each(var bean:Bean in beans)
			{
				if(!(bean is Prototype))
					setUpBean( bean );
			}
			
			//if we are not processing view-based events, do not set up for them...
			if( crux.catchViews == false )
			 	return;
			
			var className:String = getQualifiedClassName(crux.dispatcher);

			
			COMPILE::JS {
				//support for capture phase
				goog.events.listen( crux.dispatcher,
						crux.config.setUpEventType,
						setUpEventHandler,
						(crux.config.setUpEventPhase == 1));
				goog.events.listen( crux.dispatcher,
						crux.config.tearDownEventType,
						tearDownEventHandler,
						(crux.config.tearDownEventPhase == 1));
			}
			
			COMPILE::SWF{
				crux.dispatcher.addEventListener( crux.config.setUpEventType,
						setUpEventHandler,
						(crux.config.setUpEventPhase == 1), //EventPhase.CAPTURING_PHASE ),
						crux.config.setUpEventPriority ); //, true - weak refernce
				
				crux.dispatcher.addEventListener( crux.config.tearDownEventType,
						tearDownEventHandler,
						(crux.config.tearDownEventPhase == 1), //EventPhase.CAPTURING_PHASE )
						crux.config.tearDownEventPriority);//, true ); - weak refernce
			}
			
			
			/**
			 * override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
			 {
            var source:Object = getActualDispatcher_(type);
            goog.events.listen(source, type, handler);
        }
			 */
			//@todo...
			/*if(crux.dispatcher)
			{
				// as long as the dispatcher is a view, set it up like any other view
				// this allows it to be automatically torn down if caught by tearDownEventHandler()
				if( crux.dispatcher is IRoyaleElement) //DisplayObject
				{
						CruxManager.setUp( UIBase( crux.dispatcher ) );

				}
				else
				{
					setUpBean( createBeanFromSource( crux.dispatcher ) );
				}
			}*/
			
			crux.dispatcher.dispatchEvent( new CruxEvent( CruxEvent.LOAD_COMPLETE, crux ) );
		}

		public function tearDown():void
		{
			for each( var beanProvider:IBeanProvider in crux.beanProviders )
			{
				removeBeanProvider( beanProvider );
			}
			
			crux.dispatcher.removeEventListener( BeanEvent.ADD_BEAN, handleBeanEvent );
			crux.dispatcher.removeEventListener( BeanEvent.SET_UP_BEAN, handleBeanEvent );
			crux.dispatcher.removeEventListener( BeanEvent.TEAR_DOWN_BEAN, handleBeanEvent );
			crux.dispatcher.removeEventListener( BeanEvent.REMOVE_BEAN, handleBeanEvent );
			
			
			COMPILE::JS {
				//support for capture phase
				goog.events.unlisten(crux.dispatcher,
						crux.config.setUpEventType,
						setUpEventHandler,
						(crux.config.setUpEventPhase == 0))
				
				goog.events.unlisten(crux.dispatcher,
						crux.config.tearDownEventType,
						tearDownEventHandler,
						(crux.config.tearDownEventPhase == 0))
			}
			
			COMPILE::SWF{
				
				crux.dispatcher.removeEventListener( crux.config.setUpEventType, setUpEventHandler, ( crux.config.setUpEventPhase == 0));//EventPhase.CAPTURING_PHASE ) );
				crux.dispatcher.removeEventListener( crux.config.tearDownEventType, tearDownEventHandler, ( crux.config.tearDownEventPhase == 0));//EventPhase.CAPTURING_PHASE ) );
				
			}
			
		}
		
		protected function createBeanFromSource( source:Object, beanName:String = null ):Bean
		{
			var bean:Bean = getBeanForSource( source );
			
			if( bean == null )
				bean = constructBean(source, beanName);
			
			return bean;
		}
		
		protected function getBeanForSource( source:Object ):Bean
		{
			for each( var bean:Bean in beans )
			{
				if( bean is Prototype && ( Prototype( bean ).singleton == false || Prototype( bean ).initialized == false ) )
					continue;
				else if( bean.source === source )
					return bean;
			}
			
			return null;
		}
		
		public function addBeanProvider( beanProvider:IBeanProvider, autoSetUpBeans:Boolean = true ):void
		{
			var bean:Bean;
			
			// add all beans before setting them up, in case they rely on each other
			for each( bean in beanProvider.beans )
			{
				addBean( bean, false );
			}
			
			if( autoSetUpBeans )
			{
				for each( bean in beanProvider.beans )
				{
					if( !( bean is Prototype ) )
						setUpBean( bean );
				}
			}
		}

		public function addBean( bean:Bean, autoSetUpBean:Boolean = true ):Bean
		{
			bean.beanFactory = this;
			beans.push( bean );
			
			if( autoSetUpBean && !( bean is Prototype ) )
				setUpBean( bean );
			
			return bean;
		}
		
		public function removeBeanProvider( beanProvider:IBeanProvider ):void
		{
			for each( var bean:Bean in beanProvider.beans )
			{
				removeBean( bean );
			}
		}
		
		public function removeBean( bean:Bean ):void
		{
			if( beans.indexOf( bean ) > -1 )
				beans.splice( beans.indexOf( bean ), 1 );
			
			tearDownBean( bean );
			bean.beanFactory = null;
			bean.typeDescriptor = null;
			bean.source = null;
			bean = null;
		}

		public function getBeanByName( name:String ):Bean
		{
			var foundBean:Bean = null;
			
			for each( var bean:Bean in beans )
			{
				if( bean.name == name )
				{
					foundBean = bean;
					break;
				}
			}
			
			if( foundBean != null && !( foundBean is Prototype ) && !foundBean.initialized )
				setUpBean( foundBean );
			else if( foundBean == null && parentBeanFactory != null )
				foundBean = parentBeanFactory.getBeanByName( name );
			
			return foundBean;
		}
		
		public function getBeanByType(beanType:Class):Bean
		{
			var foundBean:Bean;
			
			var beanTypeName:String = getQualifiedClassName(beanType);
			//tracer(beanTypeName);
			//tracer('beans length', beans? beans.length:0);
			for each(var bean:Bean in beans)
			{
				if(bean.typeDescriptor.satisfiesType(beanTypeName))
				{
					if(foundBean != null)
					{
						throw new Error("AmbiguousReferenceError. More than one bean was found with type: " + beanType);
					}
					
					foundBean = bean;
				}
			}
			//tracer('found bean', foundBean != null);
			if( foundBean != null && !(foundBean is Prototype ) && !foundBean.initialized)
				setUpBean( foundBean );
			else if( foundBean == null && parentBeanFactory != null )
				foundBean = parentBeanFactory.getBeanByType( beanType );
			
			return foundBean;
		}
		
		public function get parentBeanFactory():IBeanFactory
		{
			return _parentBeanFactory;
		}
		public function set parentBeanFactory( beanFactory:IBeanFactory ):void
		{
			_parentBeanFactory = beanFactory;
		}

		/**
		 * Initialze Bean
		 */
		public function setUpBean( bean:Bean ):void
		{
			if( bean.initialized )
				return;
			
			//trace("BeanFactory::setUpBean", bean);
			bean.initialized = true;
			
			var processor:IProcessor;
			
			for each( processor in crux.processors )
			{
				// skip factory processors
				if(processor is IFactoryProcessor)
					continue;
				
				// Handle Metadata Processors
				if(processor is IMetadataProcessor)
				{
					//trace("processor is IMetadataProcessor");
					var metadataProcessor:IMetadataProcessor = IMetadataProcessor( processor );
					
					// get the tags this processor is interested in
					var metadataTags:Array = [];
					for each(var metadataName:String in metadataProcessor.metadataNames)
					{
						 metadataTags = metadataTags.concat(bean.typeDescriptor.getMetadataTagsByName(metadataName));
					}
					
					metadataProcessor.setUpMetadataTags(metadataTags, bean);
				}
				
				// Handle Bean Processors
				if(processor is IBeanProcessor)
				{
					//trace("processor is IBeanProcessor");
					IBeanProcessor(processor).setUpBean(bean);
				}
			}
		}

		/**
		 * Tear down the specified Bean, or any bean with the same source, and remove it from the cache.
		 */
		public function tearDownBean( bean:Bean ):void
		{
			if( bean.source == null )
				return;
				
			for each( var processor:IProcessor in crux.processors )
			{
				// skip factory processors
				if( processor is IFactoryProcessor )
					continue;
				
				// Handle Metadata Processors
				if( processor is IMetadataProcessor )
				{
					var metadataProcessor:IMetadataProcessor = IMetadataProcessor( processor );
					
					// get the tags this processor is interested in
					var metadataTags:Array = [];
					for each( var metadataName:String in metadataProcessor.metadataNames )
					{
						metadataTags = metadataTags.concat( bean.typeDescriptor.getMetadataTagsByName( metadataName ) );
					}
					
					metadataProcessor.tearDownMetadataTags( metadataTags, bean );
				}
				
				// Handle Bean Processors
				if( processor is IBeanProcessor )
				{
					IBeanProcessor( processor ).tearDownBean( bean );
				}
			}
			
			bean.initialized = false;
		}
		
		/**
		 * Handle bean set up and tear down events.
		 */
		protected function handleBeanEvent( event:BeanEvent ):void
		{
			var existingBean:Bean = getBeanForSource( event.source );
			
			switch( event.type )
			{
				case BeanEvent.ADD_BEAN:
					if( existingBean )
						trace("{0} already exists as a bean. Ignoring ADD_BEAN request.", event.source.toString());// logger.warn( "{0} already exists as a bean. Ignoring ADD_BEAN request.", event.source.toString() );
					else
						addBean( constructBean(event.source, event.beanName));
					break;
				
				case BeanEvent.SET_UP_BEAN:
					if( existingBean )
						if( existingBean.initialized )
							trace("{0} is already set up as a bean. Ignoring SET_UP_BEAN request.", event.source.toString());// logger.warn( "{0} is already set up as a bean. Ignoring SET_UP_BEAN request.", event.source.toString() );
						else
							setUpBean( existingBean );
					else
						setUpBean( constructBean(event.source, event.beanName));
					break;
				
				case BeanEvent.TEAR_DOWN_BEAN:
					if( existingBean )
						tearDownBean( existingBean );
					else
						tearDownBean( constructBean(event.source, null) ); // non-singleton Prototype beans are not stored, so this is how we tear them down
					break;
				
				case BeanEvent.REMOVE_BEAN:
					if( existingBean )
						removeBean( existingBean );
					else
						trace("Could not find bean with {0} as its source. Ignoring REMOVE_BEAN request.", event.source.toString());//logger.warn( "Could not find bean with {0} as its source. Ignoring REMOVE_BEAN request.", event.source.toString() );
					break;
			}
		}
		
		/**
		 * Evaluate whether Crux is configured such that the specified class is a potential injection target.
		 */
		protected function isPotentialInjectionTarget( instance:Object ):Boolean
		{
			var className:String = getQualifiedClassName( instance );
			
			if( crux.config.viewPackages.length > 0 ) {
				for each( var viewPackage:String in crux.config.viewPackages ) {
					if( className.indexOf( viewPackage ) == 0 && className.indexOf( "__" ) < 0 )
								return true;
				}
				return false;
			} else {
				//trace('checking ',className,!( ignoredClasses.test( className ) ));
				return !( ignoredClasses.test( className ) )
			}
		}
		
		/**
		 * Injection Event Handler
		 */
		protected function setUpEventHandler( event:Event ):void
		{
			//tracer('BeanFactory setUpEventHandler',event.type,event.bubbles, getQualifiedClassName(event.target), getQualifiedClassName(event.currentTarget));
			if( event.target is ISetUpValidator && !( ISetUpValidator( event.target ).allowSetUp() ) )
				return;
			
			if( isPotentialInjectionTarget( event.target ) )
			{
				var i:int = removedDisplayObjects.indexOf( event.target );
				
				if( i != -1 )
				{
					removedDisplayObjects.splice( i, 1 );
					
					if( removedDisplayObjects.length == 0 )
					{
						//like 'removing' enterframe event listener...
						simulatedSingleEnterFrame(IFlexInfo(crux.dispatcher), enterFrameHandler, true);
						isListeningForEnterFrame = false;
					}
					
					return;
				}
				
				CruxManager.setUp( UIBase( event.target ) );
			}
		}
		
		/**
		 * Injection Event Handler defined on SysMgr
		 */
		protected function setUpEventHandlerSysMgr( event:Event ):void
		{

			trace('todo setUpEventHandlerSysMgr')
			// make sure the view is not a descendant of the main dispatcher
			// if it's not, it is a popup, so we pass it along for processing
			// if( !Sprite( crux.dispatcher ).contains( DisplayObject( event.target ) ) )
			// {
			// 	setUpEventHandler( event );
			// }
		}
		
		/**
		 * Remove Event Handler
		 */
		protected function tearDownEventHandler( event:Event ):void
		{

			if( event.target is ITearDownValidator && !( ITearDownValidator( event.target ).allowTearDown() ) )
				return;
			
			//tracer('BeanFactory tearDownEventHandler',event.type,event.bubbles, getQualifiedClassName(event.target), getQualifiedClassName(event.currentTarget));
			
			// only views previously processed can be torn down
			
			COMPILE::SWF{
				if( CruxManager.wiredViews[ event.target ] ) {
					//tracer('addRemovedDisplayObject::', getQualifiedClassName(event.target));
					addRemovedDisplayObject( UIBase( event.target ) );
				}
				
			}
			COMPILE::JS{
				if( CruxManager.wiredViews.get(event.target)) {
					//tracer('addRemovedDisplayObject::', getQualifiedClassName(event.target));
					addRemovedDisplayObject( UIBase( event.target ) );
				}
			}
		}
		
		protected function addRemovedDisplayObject( displayObject:UIBase ):void
		{
			if( removedDisplayObjects.indexOf( displayObject ) == -1 )
				removedDisplayObjects.push( displayObject );

			if( !isListeningForEnterFrame )
			{
		 		//crux.dispatcher.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
				simulatedSingleEnterFrame(IFlexInfo(crux.dispatcher), enterFrameHandler, false);
		 		isListeningForEnterFrame = true;
		 	}
		 }
		
		protected function enterFrameHandler( event:Event ):void
		{
			//simulatedSingleEnterFrame(ApplicationBase(crux.dispatcher), enterFrameHandler);
			//crux.dispatcher.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			isListeningForEnterFrame = false;

			var displayObject:UIBase = UIBase( removedDisplayObjects.shift() );

			while( displayObject )
			{
				CruxManager.tearDown( displayObject );
				displayObject = UIBase( removedDisplayObjects.shift() );
			}
		}

		/**
		 *
		 * @royaleignorecoercion org.apache.royale.crux.Bean
		 */
		public static function constructBean(obj:*, name:String):Bean
		{
			//tracer("constructBean", getQualifiedClassName(obj), name);
			var bean:Bean;
			
			if(obj is Bean)
			{
				//trace("obj is Bean");
				bean = Bean(obj);
			}
			else
			{
				//trace("obj is not Bean, create a Bean from the obj");
				bean = new Bean();
				bean.source = obj;
			}
			//trace("Bean ", bean);
			//trace("bean.name ", bean.name);
			bean.name ||= name;
			//trace("after ||=", bean.name);
			bean.typeDescriptor = TypeCache.getTypeDescriptor(bean.type);
			
			return bean;
		}
    }
}
