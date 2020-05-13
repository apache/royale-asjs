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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.crux.events.CruxEvent;
    import org.apache.royale.crux.processors.CruxInterfaceProcessor;
    import org.apache.royale.crux.processors.DispatcherProcessor;
    import org.apache.royale.crux.processors.EventHandlerProcessor;
    import org.apache.royale.crux.processors.IProcessor;
    import org.apache.royale.crux.processors.InjectProcessor;
    import org.apache.royale.crux.processors.PostConstructProcessor;
    import org.apache.royale.crux.processors.PreDestroyProcessor;
    import org.apache.royale.crux.processors.ProcessorPriority;
    import org.apache.royale.crux.processors.ViewProcessor;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.reflection.ExtraData;
    import org.apache.royale.reflection.TypeDefinition;

    [DefaultProperty("beanProviders")]
	
	/**
	 * Core framework class that serves as an IoC container rooted
	 * at the IEventDispatcher passed into its constructor.
	 */
	public class Crux extends EventDispatcher implements IBead, ICrux
	{
		/**
		 * Constructor
		 */
		public function Crux(dispatcher:IEventDispatcher = null,
									config:ICruxConfig = null,
									beanFactory:IBeanFactory = null, 
									beanProviders:Array = null, 
									customProcessors:Array = null )
		{
			super();
			
			this.dispatcher = dispatcher;
			this.config = config;
			this.beanFactory = beanFactory;
			this.beanProviders = beanProviders;
			this.customProcessors = customProcessors;
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			if (dispatcher == null && value is IEventDispatcher) dispatcher = IEventDispatcher(value);
			init();
		}
		
		
		protected var _dispatcher:IEventDispatcher;
		protected var _globalDispatcher:IEventDispatcher;
		protected var _config:ICruxConfig;
		protected var _beanFactory:IBeanFactory;
		protected var _beanProviders:Array;
		protected var _processors:Array = [new InjectProcessor(), new DispatcherProcessor(), new EventHandlerProcessor() ,
											new CruxInterfaceProcessor(), new PostConstructProcessor(), new PreDestroyProcessor(),
											new ViewProcessor() ];
		
		protected var _parentCrux:ICrux;
		
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}
		public function set dispatcher(value:IEventDispatcher):void
		{
			_dispatcher = value;
		}
		
		public function get globalDispatcher():IEventDispatcher
		{
			return _globalDispatcher;
		}
		public function set globalDispatcher(value:IEventDispatcher):void
		{
			_globalDispatcher = value;
		}
		
		public function get config():ICruxConfig
		{
			return _config;
		}
		public function set config(value:ICruxConfig):void
		{
			_config = value;
		}
		
		public function get beanFactory():IBeanFactory
		{
			return _beanFactory;
		}
		
		public function set beanFactory( value:IBeanFactory ):void
		{
			_beanFactory = value;
		}
		
		[ArrayElementType( "org.apache.royale.crux.IBeanProvider" )]
		public function get beanProviders():Array
		{
			return _beanProviders;
		}
		public function set beanProviders( value:Array ):void
		{
			_beanProviders = value;
		}
		
		[ArrayElementType( "org.apache.royale.crux.processors.IProcessor" )]
		public function get processors():Array
		{
			return _processors;
		}
		public function set customProcessors(value:Array):void
		{
			if( value != null )
			{
				/*
				 iterate over the incoming processors. if a new processor has the same
				 priority as a default processor, replace the built in one with the new one.
				 if the priority is default or anything else, simply add the processor.
				*/
				var processor:IProcessor;
				for(var i:int = 0; i < value.length; i++)
				{
					processor = IProcessor(value[i]);
					if(processor.priority == ProcessorPriority.DEFAULT)
					{
						_processors.push(processor);
					}
					else
					{
						var found:Boolean = false;
						for(var j:int = 0; j < _processors.length; j++)
						{
							if(IProcessor(_processors[j]).priority == processor.priority)
							{
								_processors[j] = processor;
								found = true;
								break;
							}
						}
						
						if(!found) 
							_processors.push(processor);
					}
				}
			}
		}
		
		public function get parentCrux():ICrux
		{
			return _parentCrux;
		}
		public function set parentCrux( parentCrux:ICrux ):void
		{
			_parentCrux = parentCrux;
		}
		
		
		/**
		 * Backing variable for <code>catchViews</code> getter/setter.
		 */
		protected var _catchViews:Boolean = true;
		
		/**
		 * If set to false, no view processing is done by this Crux instance.
		 */
		public function get catchViews():Boolean
		{
			return _catchViews;
		}
		public function set catchViews( value:Boolean ):void
		{
			_catchViews = value;
		}
		
		/**
		 * initialize Crux
		 */
		public function init():void
		{
			
			ExtraData.addAll();
			TypeDefinition.useCache = true;

			CruxManager.addCrux(this);
			
			if(dispatcher == null)
			{
				dispatcher = this;
			}
			
			if(config == null)
			{
				config = new CruxConfig();
			}
			
			if(beanFactory == null)
			{
				beanFactory = new BeanFactory();
			}
			
			// dispatch a Crux created event before fully initializing
			dispatchCruxCreatedEvent();
			
			if(parentCrux != null)
			{
				_beanFactory.parentBeanFactory = _parentCrux.beanFactory;
				
				globalDispatcher = parentCrux.globalDispatcher;
				
				config.eventPackages = config.eventPackages.concat(_parentCrux.config.eventPackages);
				config.viewPackages = config.viewPackages.concat(_parentCrux.config.viewPackages);
			}
			
			// set global dispatcher if a parent wasn't able to set it
			if(globalDispatcher == null)
			{
				globalDispatcher = dispatcher;
			}
			
			constructProviders();
			
			initializeProcessors();
			
			beanFactory.setUp(this);
			
		}
		
		/**
		 * CruxConfig can accept bean providers as Classes as well as instances. ContructProviders
		 * ensures that provider is created and initialized before the bean factory accesses them.
		 */
		protected function constructProviders():void
		{
			var providerClass:Class;
			var providerInst:IBeanProvider;
			
			if(beanProviders == null)
				return;
			
			for(var i:int = 0; i < beanProviders.length; i++)
			{
				// if the provider is a class, instantiate it//
				// then replace the item in the array
				
				if(beanProviders[i] is Class)
				{
					providerClass = beanProviders[i] as Class;
					providerInst = new providerClass();
					beanProviders[i] = providerInst;
				}
				else
				{
					providerInst = beanProviders[i];
				}
				
				providerInst.initialize();
			}
		}
		
		protected function initializeProcessors():void
		{
			processors.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
				
			for each(var processor:IProcessor in processors)
			{
				processor.init(this);
			}
			
		}
		
		/**
		 * Clean up this Crux instance
		 */
		public function tearDown():void
		{
			// tear down any child views that have been wired
			CruxManager.tearDownAllWiredViewsForCruxInstance(this);
			
			// tear down beans defined in bean providers or added with BeanEvents
			beanFactory.tearDown();
			
			dispatcher.removeEventListener(CruxEvent.CREATED, handleCruxCreatedEvent);
			// clear out refs
			parentCrux = null;
			CruxManager.removeCrux(this);
		}
		
		/**
		 * Dispatches a Crux creation event to find parents and attaches a listener to
		 * find potential children.
		 */
		protected function dispatchCruxCreatedEvent():void
		{
			// dispatch a creation event to find parents
			dispatcher.dispatchEvent(new CruxEvent(CruxEvent.CREATED, this));
			// and attach a listener for children
			dispatcher.addEventListener(CruxEvent.CREATED, handleCruxCreatedEvent);
			
		}
		
		/**
		 * Receives Crux creation events from potential child Crux instances, and sets this instance
		 * as the parent. Relies on display list ordering as a means of conveying parent / child
		 * relationships. Pure AS projects will need to call setParent explicitly.
		 */
		protected function handleCruxCreatedEvent( event:CruxEvent ):void
		{
			if( event.crux != null  && event.crux.parentCrux == null)
			{
				event.stopImmediatePropagation();
				event.crux.parentCrux = this;
			}
			
			//trace("Received CruxEvent.CREATED, set self to parent." );
		}
	}
}
