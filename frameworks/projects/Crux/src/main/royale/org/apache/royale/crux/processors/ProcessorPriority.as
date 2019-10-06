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
    /**
	 * The ProcessorPriority class defines constant values for the <code>priority</code> property of <code>IProcessor</code> instances.
	 *
	 * <p>The higher the number, the higher the priority of the processor. All processors with priority N will be executed before
	 * processors with priority N - 1. If two or more processors share the same priority, they are processed in the order in
	 * which they were added.</p>
	 *
	 * <p>Priorities can be positive, 0, or negative. The default priority is 500.</p>
	 *
	 * <p>You should not write code that depends on the numeric values of these constants. They are subject to change in future versions of Crux.</p>
	 */
	public final class ProcessorPriority
	{
		/**
		 * Built-in <code>AutoProxyProcessor</code> runs before any bean setup (as an IFactoryProcessor).
		 *
		 * @see org.apache.royale.crux.processors.AutoProxyProcessor
		 */
		public static const AUTO_PROXY		:int = 900;
		
		/**
		 * Built-in <code>PreDestroyProcessor</code> runs during tear down to allow components to do any
		 * necessary cleanup to ensure proper disposal.
		 *
		 * @see org.apache.royale.crux.processors.PreDestroyProcessor
		 */
		public static const PRE_DESTROY		:int = 800;
		
		/**
		 * Built-in <code>InjectProcessor</code> is the second native processor run to
		 * satisfy declared dependencies in any beans/components provided to Crux.
		 *
		 * @see org.apache.royale.crux.processors.InjectProcessor
		 */
		public static const INJECT			:int = 700;
		
		/**
		 * Built-in <code>EventHandlerProcessor</code> uses this priority.
		 *
		 * @see org.apache.royale.crux.processors.EventHandlerProcessor
		 */
		public static const EVENT_HANDLER			:int = 600;
		
		/**
		 * Built-in <code>DispatcherProcessor</code> uses this priority.
		 *
		 * @see org.apache.royale.crux.processors.DispatcherProcessor
		 */
		public static const DISPATCHER		:int = 500;
		
		/**
		 * Default priority used by <code>BaseMetadataProcessor</code>.
		 *
		 * @see org.apache.royale.crux.processors.BaseMetadataProcessor
		 */
		public static const DEFAULT			:int = 400;
		
		/**
		 * Built-in <code>CruxInterfaceProcessor</code> runs after <code>DefaultProcessors</code>
		 * to allow components to do any necessary initialization based on internal crux interfaces.
		 *
		 * @see org.apache.royale.crux.processors.PostConstructProcessor
		 */
		public static const Crux_INTERFACE	:int = 300;
		
		/**
		 * Built-in <code>PostConstructProcessor</code> runs after <code>InjectProcessor</code>
		 * to allow components to do any necessary initialization once their dependencies have been satisfied.
		 *
		 * @see org.apache.royale.crux.processors.PostConstructProcessor
		 */
		public static const POST_CONSTRUCT	:int = 200;
	}
}
