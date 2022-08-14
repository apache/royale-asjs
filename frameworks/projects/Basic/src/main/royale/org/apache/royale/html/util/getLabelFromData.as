////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.html.util
{

    import org.apache.royale.core.IHasLabelField;
    import org.apache.royale.core.IHasDataField;
    import org.apache.royale.core.ILabeledData;

    /**
     *  Utility function to get a label string from a value object
     *  Strings are just returned as-is
     *  The most effective way to use the function for data is to use `ILabeledData`.
     *  If your data is an instantiated class, always implement `ILabeledData`
     *  and returns the correct value with the `label` getter.
     *  This ensures that it will work even after full minimization.
     *  If you are using plain objects (i.e. using `JSON.parse()` or similar) it will use the following logic flow:
     *  First it tries a `labelField`
     *  Then the `dataField`
     *  If both of those fail, it tries a `label` property
     *  If all else fails, it just converts the object to a string
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
     *  @royaleignorecoercion org.apache.royale.core.IHasLabelField
     *  @royaleignorecoercion org.apache.royale.core.IHasDataField
     *  @royaleignorecoercion org.apache.royale.core.ILabeledData
     */
    public function getLabelFromData(obj:Object,data:Object):String
    {
        // slightly more code, but we bail early if it's a string which is often
        if (data is String) return "" + data;
        if(!data) return "";
        if(data is ILabeledData) return (data as ILabeledData).label;
        if (obj is IHasLabelField && (obj as IHasLabelField).labelField)
        {
            return data[(obj as IHasLabelField).labelField] == null ?
                "" :
                "" + data[(obj as IHasLabelField).labelField];
        } 

        if (obj is IHasDataField && (obj as IHasDataField).dataField)
        {
            return data[(obj as IHasDataField).dataField] == null ?
                "" :
                "" + data[(obj as IHasDataField).dataField];
        }

        var label:String = data["label"];
        if(label != null)
            return label;

        return "" + data;

    }
}
