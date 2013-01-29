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
package org.apache.flex.utils
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import org.apache.flex.binding.SimpleBinding;
import org.apache.flex.core.IStrand;
import org.apache.flex.core.IBead;
import org.apache.flex.core.IDocument;
import org.apache.flex.core.IInitModel;
import org.apache.flex.core.IInitSkin;
import org.apache.flex.core.UIBase;

public class MXMLDataInterpreter
{
    public function MXMLDataInterpreter()
    {
        super();
    }
    	
    
    public static function generateMXMLObject(document:Object, data:Array):Object
    {
        var i:int = 0;
        var cls:Class = data[i++];
        var comp:Object = new cls();
        
        var m:int;
        var j:int;
        var name:String;
        var simple:*;
        var value:Object;
        var id:String;
        
        m = data[i++]; // num props
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(document, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(document, value as Array);
            if (name == "id")
            {
                document[value] = comp;
                id = value as String;
            }
            else if (name == "_id")
            {
                document[value] = comp;
                id = value as String;
                continue; // skip assignment to comp
            }
            comp[name] = value;
        }
        if (comp is IDocument)
            comp.setDocument(document, id);
        return comp;
    }
    
    public static function generateMXMLArray(document:Object, parent:DisplayObjectContainer, data:Array, recursive:Boolean = true):Array
    {
        var comps:Array = [];
        
        var n:int = data.length;
        var i:int = 0;
        while (i < n)
        {
            var cls:Class = data[i++];
            var comp:Object = new cls();
            
            if (parent)
            {
                if (comp is UIBase)
                    comp.addToParent(parent);
                else
                    parent.addChild(comp as DisplayObject);
            }
            
            var m:int;
            var j:int;
            var name:String;
            var simple:*;
            var value:Object;
            var id:String = null;
            
            m = data[i++]; // num props
            if (m > 0 && data[0] == "model")
            {
                m--;
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, parent, value as Array, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                comp[name] = value;
                if (value is IBead && comp is IStrand)
                    IStrand(comp).addBead(value as IBead);
            }
            if (comp is IInitModel)
            IInitModel(comp).initModel();
            var beadOffset:int = i + (m - 1) * 3;
            if (beadOffset >= -1)
            trace(beadOffset, data[beadOffset]);
            if (m > 0 && data[beadOffset] == "beads")
            {
                m--;
            }
            else
                beadOffset = -1;
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value as Array, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                if (name == "id")
                    id = value as String;
                if (name == "document" && !comp.document)
                    comp.document = document;
                else if (name == "_id")
                    id = value as String; // and don't assign to comp
                else
                    comp[name] = value;
            }
            if (beadOffset > -1)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value as Array, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                else
                    comp[name] = value;
                var beads:Array = value as Array;
                var l:int = beads.length;
                for (var k:int = 0; k < l; k++)
                {
                    var bead:IBead = beads[k] as IBead;
                    IStrand(comp).addBead(bead);
                    bead.strand = comp as IStrand;
                }
            }
            m = data[i++]; // num styles
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value as Array, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                comp.setStyle(name, value);
            }
            if (comp is IInitSkin)
            {
                IInitSkin(comp).initSkin();
            }
            
            
            m = data[i++]; // num effects
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value as Array, recursive);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                comp.setStyle(name, value);
            }
            
            m = data[i++]; // num events
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                value = data[i++];
                comp.addEventListener(name, value);
            }
            
            var children:Array = data[i++];
            if (children)
            {
                if (recursive)
                    generateMXMLInstances(document, comp as DisplayObjectContainer, children, recursive);
                else
                    comp.setMXMLDescriptor(children);
            }
            
            if (id)
                document[id] = comp;
            
            if (comp is IDocument)
                comp.setDocument(document, id);
            comps.push(comp);
        }
        return comps;
    }
    
    public static function generateMXMLInstances(document:Object, parent:DisplayObjectContainer, data:Array, recursive:Boolean = true):void
    {
		if (!data) return;
		
        generateMXMLArray(document, parent, data, recursive);
    }
    
    public static function generateMXMLProperties(host:Object, data:Array):void
    {
		if (!data) return;
		
        var i:int = 0;
        var m:int;
        var j:int;
        var name:String;
        var simple:*;
        var value:Object;
        var id:String = null;
        
        m = data[i++]; // num props
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value as Array, false);
            else if (simple == false)
                value = generateMXMLObject(host, value as Array);
            if (name == "id")
                id = value as String;
            if (name == "_id")
                id = value as String; // and don't assign
            else
                host[name] = value;
        }
        m = data[i++]; // num styles
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value as Array, false);
            else if (simple == false)
                value = generateMXMLObject(host, value as Array);
            host[name] = value;
        }
        
        m = data[i++]; // num effects
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value as Array, false);
            else if (simple == false)
                value = generateMXMLObject(host, value as Array);
            host[name] = value;
        }
        
        m = data[i++]; // num events
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            value = data[i++];
            host.addEventListener(name, value as Function);
        }
    }
    
}
}
