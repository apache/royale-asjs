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

/**
 *  A factory that represents the class the series will use to represent individual items on the chart. This class is instantiated once for each element in the chart.
 *	Classes used as an itemRenderer should implement the IFlexDisplayObject, ISimpleStyleClient, and IDataRenderer interfaces. The <code>data</code> property is assigned the 
 *	chartItem that the skin instance renders.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="itemRenderer", type="mx.core.IFactory", inherit="no")]

/**
 *  The class that the series uses to render the series's marker in any associated legends. If this style is <code>null</code>, most series default to
 *	using their itemRenderer as a legend marker skin instead. Classes used as legend markers should implement the IFlexDisplayObject interface, and optionally the ISimpleStyleClient and IDataRenderer interfaces.
 *	If the class used as a legend marker implements the IDataRenderer interface, the data property is assigned a LegendData instance.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="legendMarkerRenderer", type="mx.core.IFactory", inherit="no")]

