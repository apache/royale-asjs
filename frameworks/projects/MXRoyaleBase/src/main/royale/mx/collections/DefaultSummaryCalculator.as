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

package mx.collections
{

/**
 *  The DefaultSummaryCalculator class provides summary calculation logic for 
 *  <code>SUM</code>, <code>MIN</code>, <code>MAX</code>, <code>AVG</code>, and <code>COUNT</code> operations.
 *
 *  @see mx.collections.SummaryField2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
public class DefaultSummaryCalculator implements ISummaryCalculator
{
	//--------------------------------------------------------------------------
	//
	// Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
 	public function summaryCalculationBegin(field:SummaryField2):Object
 	{
		var dataField:String = field.dataField;
		var newObj:Object = {};
		switch (field.summaryOperation)
		{
			case "SUM": newObj[dataField] = 0;
						break;
			case "MIN": newObj[dataField] = Number.MAX_VALUE;
						break;
			case "MAX": newObj[dataField] = -Number.MAX_VALUE;
						break;
			case "COUNT": newObj[dataField] = [];
						  newObj[dataField + "Counter"] = 0;
						  break;
			case "AVG": newObj[dataField] = 0;
						newObj[dataField + "Count"] = 0;
						break;
		}
		return newObj;
 	}
 	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
 	public function calculateSummary(data:Object, field:SummaryField2, rowData:Object):void
 	{
		var dataField:String = field.dataField;
		var value:Number = rowData[dataField];
		if (typeof(value) == "xml")
			value = Number(value.toString());
		
		switch (field.summaryOperation)
		{
			case "SUM": if (!data.hasOwnProperty(dataField))
							data[dataField] = value ;
						else
							data[dataField] += value;
						break;
			case "MIN": if (!data.hasOwnProperty(dataField))
							data[dataField] = value;
						else
							data[dataField] =  data[dataField] < value ? data[dataField] : value;
						break;
			case "MAX": if (!data.hasOwnProperty(dataField))
							data[dataField] = value;
						else
							data[dataField] =  data[dataField] > value ? data[dataField] : value;
						break;
			case "COUNT": if (!data.hasOwnProperty(dataField))
						  {
							  data[dataField] = [rowData[dataField]];
							  data[dataField + "Counter"] = 1;
						  }
						  else
						  {
							  data[dataField].push(rowData[dataField]);
							  data[dataField + "Counter"] = data[dataField + "Counter"] + 1;
						  }
						  break;
			case "AVG": if (!data.hasOwnProperty(dataField))
						{
							data[dataField] = value;
							data[dataField + "Count"] = 1;
						}
						else
						{
							data[dataField] += value;
							data[dataField + "Count"] = data[dataField + "Count"] + 1;
						}
						break;
		}
 	}
 	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
 	public function returnSummary(data:Object, field:SummaryField2):Number
 	{
		var summary:Number = 0;
		var dataField:String = field.dataField;
		switch (field.summaryOperation)
		{
			case "SUM":
			case "MIN":
			case "MAX": summary = data[dataField];
						break;
			case "COUNT": 	summary = data[dataField + "Counter"];
							break;
			case "AVG": summary = data[dataField]/data[dataField + "Count"];
						break;
		}
		
		return summary;
 	}
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
	public function summaryOfSummaryCalculationBegin(value:Object, field:SummaryField2):Object
	{
		var newObj:Object = {};
		for (var p:String in value)
		{
			newObj[p] = value[p];
		}
		return newObj;
	}
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
	public function calculateSummaryOfSummary(oldValue:Object, newValue:Object, field:SummaryField2):void
	{
		var p:String;
		switch (field.summaryOperation)
		{
			case "AVG":
			case "SUM": for (p in newValue)
						{
							oldValue[p] += newValue[p];
						}
						break;
			case "MIN": for (p in newValue)
						{
							oldValue[p] = oldValue[p] < newValue[p] ? oldValue[p] : newValue[p];
						}
						break;
			case "MAX": for (p in newValue)
						{
							oldValue[p] = oldValue[p] > newValue[p] ? oldValue[p] : newValue[p];
						}
						break;
			case "COUNT": 	for (p in newValue)
							{
								if (oldValue[p] is Array)
									oldValue[p] = oldValue[p].concat(newValue[p]);
								else
									oldValue[p] += newValue[p];
							}
							break;
		}
	}
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
	public function returnSummaryOfSummary(oldValue:Object, field:SummaryField2):Number
	{
		var summary:Number = 0;
		var dataField:String = field.dataField;
		switch (field.summaryOperation)
		{
			case "SUM":
			case "MIN":
			case "MAX": summary = oldValue[dataField];
						break;
			case "COUNT":   summary = oldValue[dataField + "Counter"];
							break;
			case "AVG": summary = oldValue[dataField]/oldValue[dataField + "Count"];
						break;
		}
		
		return summary;
	}
}
}