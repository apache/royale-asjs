////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package
{

    /**
     *  @private
     *  This class is used to link additional classes into Crux.swc
     *  beyond those that are found by dependency analysis starting
     *  from the classes specified in manifest.xml.
     */
    internal class CruxClasses
    {
    
        import org.apache.royale.crux.Bean; Bean;
        import org.apache.royale.crux.BeanFactory; BeanFactory;
        import org.apache.royale.crux.BeanProvider; BeanProvider;
        import org.apache.royale.crux.Crux; Crux;
        import org.apache.royale.crux.CruxConfig; CruxConfig;
        import org.apache.royale.crux.CruxManager; CruxManager;
        import org.apache.royale.crux.IBeanFactory; IBeanFactory;
        import org.apache.royale.crux.IBeanFactoryAware; IBeanFactoryAware;
        import org.apache.royale.crux.IBeanProvider; IBeanProvider;
        import org.apache.royale.crux.ICrux; ICrux;
        import org.apache.royale.crux.ICruxAware; ICruxAware;
        import org.apache.royale.crux.ICruxConfig; ICruxConfig;
        import org.apache.royale.crux.ICruxHost; ICruxHost;
        import org.apache.royale.crux.ICruxInterface; ICruxInterface;
        import org.apache.royale.crux.IDispatcherAware; IDispatcherAware;
        import org.apache.royale.crux.IDisposable; IDisposable;
        import org.apache.royale.crux.IInitializing; IInitializing;
        import org.apache.royale.crux.ISetUpValidator; ISetUpValidator;
        import org.apache.royale.crux.ITearDownValidator; ITearDownValidator;
        import org.apache.royale.crux.Prototype; Prototype;

    
    
    
        import org.apache.royale.crux.beads.JSStageEvents; JSStageEvents;

        //import org.apache.royale.crux.binding.BeanProviderStartupBindingSupport.temp
        import org.apache.royale.crux.binding.BindabilityInfo; BindabilityInfo;
        //import org.apache.royale.crux.binding.BindingUtls.temp

        import org.apache.royale.crux.controller.AbstractController; AbstractController;

        import org.apache.royale.crux.events.BeanEvent; BeanEvent;
        import org.apache.royale.crux.events.ChainEvent; ChainEvent;
        import org.apache.royale.crux.events.CruxEvent; CruxEvent;

        import org.apache.royale.crux.factories.MetadataHostFactory; MetadataHostFactory;

        import org.apache.royale.crux.metadata.EventHandlerMetadataTag; EventHandlerMetadataTag;
        import org.apache.royale.crux.metadata.EventTypeExpression; EventTypeExpression;
        import org.apache.royale.crux.metadata.InjectMetadataTag; InjectMetadataTag;
        import org.apache.royale.crux.metadata.PostConstructMetadataTag; PostConstructMetadataTag;
        import org.apache.royale.crux.metadata.PreDestroyMetadataTag; PreDestroyMetadataTag;

        import org.apache.royale.crux.processors.BaseMetadataProcessor; BaseMetadataProcessor;
        import org.apache.royale.crux.processors.CruxInterfaceProcessor; CruxInterfaceProcessor;
        import org.apache.royale.crux.processors.DispatcherProcessor; DispatcherProcessor;
        import org.apache.royale.crux.processors.EventHandlerProcessor; EventHandlerProcessor;
        import org.apache.royale.crux.processors.IBeanProcessor; IBeanProcessor;
        import org.apache.royale.crux.processors.IFactoryProcessor; IFactoryProcessor;
        import org.apache.royale.crux.processors.IMetadataProcessor; IMetadataProcessor;
        import org.apache.royale.crux.processors.InjectProcessor; InjectProcessor;
        import org.apache.royale.crux.processors.IProcessor; IProcessor;
        import org.apache.royale.crux.processors.PostConstructProcessor; PostConstructProcessor;
        import org.apache.royale.crux.processors.PreDestroyProcessor; PreDestroyProcessor;
        import org.apache.royale.crux.processors.ProcessorPriority; ProcessorPriority;
        import org.apache.royale.crux.processors.ViewProcessor; ViewProcessor;

        import org.apache.royale.crux.reflection.BaseMetadataHost; BaseMetadataHost;
        import org.apache.royale.crux.reflection.BaseMetadataTag; BaseMetadataTag;
        import org.apache.royale.crux.reflection.BindableMetadataHost; BindableMetadataHost;
        import org.apache.royale.crux.reflection.ClassConstant; ClassConstant;
        import org.apache.royale.crux.reflection.Constant; Constant;
        import org.apache.royale.crux.reflection.IMetadataHost; IMetadataHost;
        import org.apache.royale.crux.reflection.IMetadataTag; IMetadataTag;
        import org.apache.royale.crux.reflection.MetadataArg; MetadataArg;
        import org.apache.royale.crux.reflection.MetadataHostClass; MetadataHostClass;
        import org.apache.royale.crux.reflection.MetadataHostMethod; MetadataHostMethod;
        import org.apache.royale.crux.reflection.MetadataHostProperty; MetadataHostProperty;
        import org.apache.royale.crux.reflection.MethodParameter; MethodParameter;
        import org.apache.royale.crux.reflection.TypeCache; TypeCache;
        import org.apache.royale.crux.reflection.TypeDescriptor; TypeDescriptor;

        import org.apache.royale.crux.utils.async.AbstractAsynchronousDispatcherOperation; AbstractAsynchronousDispatcherOperation;
        import org.apache.royale.crux.utils.async.AbstractAsynchronousOperation; AbstractAsynchronousOperation;
        import org.apache.royale.crux.utils.async.AsynchronousChainOperation; AsynchronousChainOperation;
        import org.apache.royale.crux.utils.async.AsynchronousEvent; AsynchronousEvent;
        import org.apache.royale.crux.utils.async.AsynchronousIOOperation; AsynchronousIOOperation;
        import org.apache.royale.crux.utils.async.AsyncTokenOperation; AsyncTokenOperation;
        import org.apache.royale.crux.utils.async.IAsynchronousEvent; IAsynchronousEvent;
        import org.apache.royale.crux.utils.async.IAsynchronousOperation; IAsynchronousOperation;
        
        import org.apache.royale.crux.utils.commands.CommandMap; CommandMap;

        import org.apache.royale.crux.utils.chain.AbstractChain; AbstractChain;
        import org.apache.royale.crux.utils.chain.AsyncCommandChainStep; AsyncCommandChainStep;
        import org.apache.royale.crux.utils.chain.BaseChainStep; BaseChainStep;
        import org.apache.royale.crux.utils.chain.BaseCompositeChain; BaseCompositeChain;
        import org.apache.royale.crux.utils.chain.ChainType; ChainType;
        import org.apache.royale.crux.utils.chain.ChainUtil; ChainUtil;
        import org.apache.royale.crux.utils.chain.CommandChain; CommandChain;
        import org.apache.royale.crux.utils.chain.CommandChainStep; CommandChainStep;
        import org.apache.royale.crux.utils.chain.EventChain; EventChain;
        import org.apache.royale.crux.utils.chain.EventChainStep; EventChainStep;
        import org.apache.royale.crux.utils.chain.FunctionChainStep; FunctionChainStep;
        import org.apache.royale.crux.utils.chain.IAsyncChainStep; IAsyncChainStep;
        import org.apache.royale.crux.utils.chain.IAutonomousChainStep; IAutonomousChainStep;
        import org.apache.royale.crux.utils.chain.IChain; IChain;
        import org.apache.royale.crux.utils.chain.IChainStep; IChainStep;

        import org.apache.royale.crux.utils.event.EventHandler; EventHandler;

        import org.apache.royale.crux.utils.services.ChannelSetHelper; ChannelSetHelper;
        import org.apache.royale.crux.utils.services.CruxResponder; CruxResponder;
        import org.apache.royale.crux.utils.services.CruxURLRequest; CruxURLRequest;
        import org.apache.royale.crux.utils.services.IServiceHelper; IServiceHelper;
        import org.apache.royale.crux.utils.services.IURLRequestHelper; IURLRequestHelper;
        import org.apache.royale.crux.utils.services.MockDelegateHelper; MockDelegateHelper;
        import org.apache.royale.crux.utils.services.ServiceHelper; ServiceHelper;
        import org.apache.royale.crux.utils.services.URLRequestHelper; URLRequestHelper;

        import org.apache.royale.crux.utils.view.applicationContains; applicationContains;
        import org.apache.royale.crux.utils.view.containerContains; containerContains;
        import org.apache.royale.crux.utils.view.simulatedSingleEnterFrame; simulatedSingleEnterFrame;
    }
}
