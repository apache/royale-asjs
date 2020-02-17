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
	import org.apache.royale.crux.Bean;
	import org.apache.royale.crux.IBeanFactoryAware;
	import org.apache.royale.crux.ICrux;
	import org.apache.royale.crux.ICruxAware;
	import org.apache.royale.crux.IDispatcherAware;
	import org.apache.royale.crux.IDisposable;
	import org.apache.royale.crux.IInitializing;
	
	public class CruxInterfaceProcessor implements IBeanProcessor
	{
		private var crux:ICrux;
		
		public function CruxInterfaceProcessor()
		{
		}
		
		public function setUpBean( bean:Bean ):void
		{
			var obj:* = bean.type;
			
			if( obj is ICruxAware )
				ICruxAware( obj ).crux = crux;
			if( obj is IBeanFactoryAware )
				IBeanFactoryAware( obj ).beanFactory = crux.beanFactory;
			if( obj is IDispatcherAware )
				IDispatcherAware( obj ).dispatcher = crux.dispatcher;
			if( obj is IInitializing )
				IInitializing( obj ).afterPropertiesSet();
		}
		
		public function tearDownBean( bean:Bean ):void
		{
			var obj:* = bean.type;
			
			if( obj is ICruxAware )
				ICruxAware( obj ).crux = null;
			if( obj is IBeanFactoryAware )
				IBeanFactoryAware( obj ).beanFactory = null;
			if( obj is IDispatcherAware )
				IDispatcherAware( obj ).dispatcher = null;
			if( obj is IDisposable )
				IDisposable( obj ).destroy();
		}
		
		public function init( crux:ICrux ):void
		{
			this.crux = crux;
		}
		
		public function get priority():int
		{
			return ProcessorPriority.Crux_INTERFACE;
		}
	}
}
