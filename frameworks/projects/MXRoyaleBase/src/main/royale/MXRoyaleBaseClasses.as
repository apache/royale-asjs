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
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class MXRoyaleBaseClasses
{


	import mx.binding.BindabilityInfo; BindabilityInfo;
	import mx.binding.Binding; Binding;
	import mx.binding.BindingManager2; BindingManager2;
	import mx.binding.IBindingClient; IBindingClient;
	import mx.binding.utils.ChangeWatcher; ChangeWatcher;
	import mx.binding.utils.BindingUtils; BindingUtils;


	import mx.collections.ArrayCollection;ArrayCollection;
	import mx.collections.ArrayList;ArrayList;
	import mx.collections.AsyncListView;AsyncListView;
	import mx.collections.ComplexFieldChangeWatcher;ComplexFieldChangeWatcher;
	import mx.collections.CursorBookmark;CursorBookmark;
	import mx.collections.DefaultSummaryCalculator;DefaultSummaryCalculator;
	import mx.collections.Grouping;Grouping;
	import mx.collections.GroupingCollection;GroupingCollection;
	import mx.collections.GroupingCollection2;GroupingCollection2;
	import mx.collections.GroupingField;GroupingField;
	import mx.collections.HierarchicalCollectionView;HierarchicalCollectionView;
	import mx.collections.HierarchicalCollectionViewCursor;HierarchicalCollectionViewCursor;
	import mx.collections.HierarchicalData;HierarchicalData;
	import mx.collections.ICollectionView;ICollectionView;
	import mx.collections.IComplexSortField;IComplexSortField;
	import mx.collections.IGroupingCollection;IGroupingCollection;
	import mx.collections.IGroupingCollection2;IGroupingCollection2;
	import mx.collections.IHierarchicalCollectionView;IHierarchicalCollectionView;
	import mx.collections.IHierarchicalCollectionViewCursor;IHierarchicalCollectionViewCursor;
	import mx.collections.IHierarchicalData;IHierarchicalData;
	import mx.collections.IList;IList;
	import mx.collections.ISort;ISort;
	import mx.collections.ISortField;ISortField;
	import mx.collections.ISummaryCalculator;ISummaryCalculator;
	import mx.collections.IViewCursor;IViewCursor;
	import mx.collections.LeafNodeCursor;LeafNodeCursor;
	import mx.collections.ListCollectionView;ListCollectionView;
	import mx.collections.Sort;Sort;
	import mx.collections.SortField;SortField;
	import mx.collections.SortFieldCompareTypes;SortFieldCompareTypes;
	import mx.collections.SummaryField;SummaryField;
	import mx.collections.SummaryField2;SummaryField2;
	import mx.collections.SummaryObject;SummaryObject;
	import mx.collections.SummaryRow;SummaryRow;
	import mx.collections.XMLListAdapter;XMLListAdapter;
	import mx.collections.XMLListCollection;XMLListCollection;

	import mx.collections.errors.ItemPendingError; ItemPendingError;
	import mx.collections.errors.SortError; SortError;
	import mx.collections.errors.CursorError; CursorError;



	import mx.core.ClassFactory;ClassFactory;
	import mx.core.EventPriority;EventPriority;
	import mx.core.FlexVersion;FlexVersion;
	import mx.core.FlexGlobals;FlexGlobals;
	import mx.core.IChildList;IChildList;
	import mx.core.IFactory;IFactory;
	import mx.core.IFlexDisplayObject;IFlexDisplayObject;
	import mx.core.IFlexModule;IFlexModule;
	import mx.core.IFlexModuleFactory;IFlexModuleFactory;
	import mx.core.IMXMLObject;IMXMLObject;
	import mx.core.IPropertyChangeNotifier;IPropertyChangeNotifier;
	import mx.core.IUIComponent;IUIComponent;
	import mx.core.IUID;IUID;
	import mx.core.Keyboard;Keyboard;
	import mx.core.mx_internal;mx_internal;
	import mx.core.Singleton;Singleton;

	import mx.data.EncryptedLocalStore;EncryptedLocalStore;

	import mx.errors.EOFError;EOFError;
	import mx.errors.IllegalOperationError;IllegalOperationError
	import mx.errors.ScriptTimeoutError;ScriptTimeoutError



	import mx.events.AsyncErrorEvent;AsyncErrorEvent;
	import mx.events.CollectionEvent;CollectionEvent;
	import mx.events.CollectionEventKind;CollectionEventKind;
	import mx.events.DataEvent;DataEvent;
	import mx.events.ErrorEvent;ErrorEvent;
	import mx.events.FlexEvent;FlexEvent;
	import mx.events.HTTPStatusEvent;HTTPStatusEvent;
	import mx.events.IndexChangedEvent;IndexChangedEvent;
	import mx.events.IOErrorEvent;IOErrorEvent;
	import mx.events.NetStatusEvent;NetStatusEvent;
	import mx.events.ProgressEvent;ProgressEvent;
	import mx.events.PropertyChangeEvent;PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;PropertyChangeEventKind;
	import mx.events.ResourceEvent;ResourceEvent;
	import mx.events.RSLEvent;RSLEvent;
	import mx.events.SecurityErrorEvent;SecurityErrorEvent;
	import mx.events.TimerEvent;TimerEvent;
	import mx.events.ValidationResultEvent;ValidationResultEvent;


	import mx.external.ExternalInterface; ExternalInterface;


	import mx.formatters.CurrencyFormatter;CurrencyFormatter;
	import mx.formatters.DateBase;DateBase;
	import mx.formatters.DateFormatter;DateFormatter;
	import mx.formatters.Formatter;Formatter;
	import mx.formatters.IFormatter;IFormatter;
	import mx.formatters.NumberBase;NumberBase;
	import mx.formatters.NumberBaseRoundType;NumberBaseRoundType;
	import mx.formatters.NumberFormatter;mx.formatters.NumberFormatter;
	import mx.formatters.PhoneFormatter;PhoneFormatter;
	import mx.formatters.StringFormatter;StringFormatter;
	import mx.formatters.SwitchSymbolFormatter;SwitchSymbolFormatter;
	import mx.formatters.ZipCodeFormatter;ZipCodeFormatter;


	import mx.geom.Matrix;Matrix;

	import mx.globalization.CurrencyParseResult;CurrencyParseResult;
	import mx.globalization.DateTimeFormatter;DateTimeFormatter;
	import mx.globalization.DateTimeNameStyle;DateTimeNameStyle;
	import mx.globalization.DateTimeStyle;DateTimeStyle;
	import mx.globalization.LastOperationStatus;LastOperationStatus;
	import mx.globalization.LocaleID;LocaleID;
	import mx.globalization.NationalDigitsType;NationalDigitsType;
	import mx.globalization.NumberFormatter;mx.globalization.NumberFormatter;
	import mx.globalization.NumberParseResult;NumberParseResult;
	import mx.globalization.supportClasses.GlobalizationBase;GlobalizationBase;


	import mx.logging.Log; Log;
	import mx.logging.LogLogger; LogLogger;
	import mx.logging.LogEvent; LogEvent;
	import mx.logging.LogEventLevel; LogEventLevel;
	import mx.logging.AbstractTarget; AbstractTarget;
	import mx.logging.ILogger; ILogger;
	import mx.logging.ILoggingTarget; ILoggingTarget;
	import mx.logging.errors.InvalidFilterError; InvalidFilterError;
	import mx.logging.errors.InvalidCategoryError; InvalidCategoryError;
	import mx.logging.targets.LineFormattedTarget; LineFormattedTarget;
	import mx.logging.targets.TraceTarget; TraceTarget;


	import mx.managers.CursorManager;CursorManager;
	import mx.managers.CursorManagerPriority;CursorManagerPriority;
	import mx.managers.ICursorManager;ICursorManager;
	import mx.managers.IDragManager;IDragManager;
	import mx.managers.ISystemManager;ISystemManager;
	import mx.managers.SystemManagerGlobals;SystemManagerGlobals;



	import mx.messaging.messages.HTTPRequestMessage; HTTPRequestMessage;
	import mx.messaging.channels.AMFChannel; AMFChannel;
	import mx.messaging.channels.DirectHTTPChannel; DirectHTTPChannel;
	import mx.messaging.channels.HTTPChannel; HTTPChannel;
	import mx.messaging.channels.SecureHTTPChannel; SecureHTTPChannel;
	import mx.messaging.channels.SecureAMFChannel; SecureAMFChannel;
	import mx.messaging.errors.MessageSerializationError; MessageSerializationError;
	import mx.messaging.messages.AcknowledgeMessage; AcknowledgeMessage;
	import mx.messaging.messages.AsyncMessage; AsyncMessage;
	import mx.messaging.messages.CommandMessage; CommandMessage;
	import mx.messaging.messages.RemotingMessage; RemotingMessage;
	import mx.messaging.messages.AcknowledgeMessageExt;AcknowledgeMessageExt;
	import mx.messaging.messages.AsyncMessageExt;AsyncMessageExt;
	import mx.messaging.messages.CommandMessageExt;CommandMessageExt;

	import mx.modules.IModule; IModule;
	import mx.modules.IModuleInfo; IModuleInfo;


	import mx.net.FileFilter;FileFilter;
	import mx.net.FileReference;FileReference;
	import mx.net.FileReferenceList;FileReferenceList;
	import mx.net.LocalConnection;LocalConnection;
	import mx.net.NetConnection;NetConnection;
	import mx.net.ObjectEncoding;ObjectEncoding;
	import mx.net.Responder;mx.net.Responder;
	import mx.net.SharedObject;SharedObject;
	import mx.net.SharedObjectFlushStatus;SharedObjectFlushStatus;
	import mx.net.SharedObjectJSON;SharedObjectJSON;
	import mx.net.Socket;Socket;
	import mx.net.URLLoader;URLLoader;
	import mx.net.URLLoaderDataFormat;URLLoaderDataFormat;
	import mx.net.URLRequestMethod;URLRequestMethod;
	import mx.net.beads.FileUploaderUsingFormData;FileUploaderUsingFormData;
	import mx.net.supportClasses.ByteArrayFileLoader;ByteArrayFileLoader;


	import mx.netmon.NetworkMonitor;NetworkMonitor;

	import mx.resources.IResourceBundle;IResourceBundle;
	import mx.resources.IResourceManager;IResourceManager;
	import mx.resources.Locale;Locale;
	import mx.resources.LocaleSorter;LocaleSorter;
	import mx.resources.ResourceBundle;ResourceBundle;
	import mx.resources.ResourceManager;ResourceManager;
	import mx.resources.ResourceManagerImpl;ResourceManagerImpl;

	import mx.rpc.http.SerializationFilter; SerializationFilter;
	import mx.rpc.http.AbstractOperation; AbstractOperation;
	import mx.rpc.http.HTTPMultiService; HTTPMultiService;
	import mx.rpc.CallResponder; CallResponder;
	import mx.rpc.http.Operation; Operation;
	import mx.rpc.Fault; Fault;
	import mx.rpc.events.FaultEvent; FaultEvent;
	import mx.rpc.soap.WebService; WebService;
	import mx.rpc.events.InvokeEvent; InvokeEvent;
	import mx.rpc.events.ResultEvent; ResultEvent;
	import mx.rpc.AsyncResponder; AsyncResponder;
	import mx.rpc.Responder; mx.rpc.Responder;
	import mx.rpc.http.HTTPService; HTTPService;
	import mx.rpc.remoting.RemoteObject; RemoteObject;
	import mx.rpc.remoting.CompressedRemoteObject; CompressedRemoteObject;


	//
	import mx.system.ApplicationDomain;ApplicationDomain;
	import mx.system.Capabilities;Capabilities;
	import mx.system.Security;Security;
	import mx.system.System;System;


	import mx.utils.ArrayUtil;ArrayUtil;
	import mx.utils.Base64Decoder;Base64Decoder;
	import mx.utils.Base64Encoder;Base64Encoder;
	import mx.utils.BitFlagUtil;BitFlagUtil;
	import mx.utils.ByteArray;ByteArray;
	import mx.utils.DescribeTypeCache;DescribeTypeCache;
	import mx.utils.Endian;Endian;
	import mx.utils.HexDecoder;HexDecoder;
	import mx.utils.HexEncoder;HexEncoder;
	import mx.utils.IXMLNotifiable;IXMLNotifiable;
	import mx.utils.NameUtil; NameUtil;
	import mx.utils.object_proxy;object_proxy;
	import mx.utils.ObjectProxy;ObjectProxy;
	import mx.utils.ObjectUtil;ObjectUtil;
	//@todo : import mx.utils.RPCObjectUtil;RPCObjectUtil;
	import mx.utils.RPCStringUtil;RPCStringUtil;
	import mx.utils.RPCUIDUtil;RPCUIDUtil;
	import mx.utils.StringUtil;StringUtil;
	import mx.utils.Timer;Timer;
	import mx.utils.UIDUtil;UIDUtil;
	import mx.utils.URLUtil;URLUtil;
	import mx.utils.XMLNotifier;XMLNotifier;
	import mx.utils.XMLUtil;XMLUtil;
	import mx.utils.RoyaleUtil; RoyaleUtil;




	import mx.validators.DateValidator;DateValidator;
	import mx.validators.EmailValidator;EmailValidator;
	import mx.validators.IValidator;IValidator;
	import mx.validators.IValidatorListener;IValidatorListener;
	import mx.validators.NumberValidator;NumberValidator;
	import mx.validators.NumberValidatorDomainType;NumberValidatorDomainType;
	import mx.validators.PhoneNumberValidator;PhoneNumberValidator;
	import mx.validators.ZipCodeValidator; ZipCodeValidator;
	import mx.validators.ZipCodeValidatorDomainType; ZipCodeValidatorDomainType;
	import mx.validators.RegExpValidationResult;RegExpValidationResult;
	import mx.validators.RegExpValidator;RegExpValidator;
	import mx.validators.StringValidator;StringValidator;
	import mx.validators.ValidationResult;ValidationResult;
	import mx.validators.Validator;Validator;
	import mx.core.DragSource; DragSource;
	import mx.events.DragEvent; DragEvent;
	import mx.events.MouseEvent; MouseEvent;



	// --- RpcClassAliasInitializer
	import org.apache.royale.reflection.registerClassAlias;


	registerClassAlias("flex.messaging.messages.CommandMessage", CommandMessage);
	registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
	registerClassAlias("flex.messaging.messages.AsyncMessage", AsyncMessage);
	registerClassAlias("flex.messaging.messages.RemotingMessage", RemotingMessage);  


	registerClassAlias("DSK", AcknowledgeMessageExt);
	registerClassAlias("DSA", AsyncMessageExt);
	registerClassAlias("DSC", CommandMessageExt);
	// RpcClassAliasInitializer ----------------------------------------
    


}

}

