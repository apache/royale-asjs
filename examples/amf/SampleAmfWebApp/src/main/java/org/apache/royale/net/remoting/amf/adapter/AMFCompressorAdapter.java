/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package org.apache.royale.net.remoting.amf.adapter;

import java.util.Collection;
import java.util.List;
import java.util.Arrays;

import flex.messaging.config.ConfigMap;
import flex.messaging.messages.Message;
import flex.messaging.services.remoting.adapters.JavaAdapter;

/**
 * BlazeDS Java adapter extension for AMF compression of complex data types using
 * ByteArrays for performance optimization.
 */
public class AMFCompressorAdapter extends JavaAdapter
{
    private List<String> includePackages;
    private List<String> includeClasses;
    private List<String> excludeClasses;

    /*
     * (non-Javadoc)
     * 
     * @see flex.messaging.services.remoting.adapters.JavaAdapter#initialize(java.lang.String, flex.messaging.config.ConfigMap)
     */
    @Override
    public void initialize(final String id, final ConfigMap properties) {
        super.initialize(id, properties);
        
        includePackages = properties.getPropertyAsList("include-packages", null);
        includeClasses = properties.getPropertyAsList("include-classes", null);
        excludeClasses = properties.getPropertyAsList("exclude-classes", null);
    }

    /*
     * (non-Javadoc)
     * 
     * @see flex.messaging.services.remoting.adapters.JavaAdapter#invoke(flex.messaging.messages.Message)
     */
    @Override
    public Object invoke(final Message message) {
        Object body = message.getBody();
        
        try {
            Object[] parameters = (Object[]) body;
            for (int i = 0; i < parameters.length; i++) {
                if (parameters[i] instanceof byte[]) {
                    parameters[i] = AMFByteArrayCompressor.inflate((byte[]) parameters[i]);
                }
            }
            message.setBody(parameters);
            Object result = super.invoke(message);
            if (isIncludedInCompression(result)) {
                result = AMFByteArrayCompressor.deflate(result);
            }
            return result;
        } catch (AMFCompressionException e) {            
            throw new AMFCompressionException(AMFCompressionError.AMF_COMPRESSION_ERROR);
        }
    }

    /**
     * Specifies whether an object should be compressed as a bytearray or not.
     * 
     * @param obj The object to compress.
     * @return Whether to serialize the object as a bytearray or not.
     */
    private boolean isIncludedInCompression(final Object obj) {
        return obj != null && !isInExcludedClasses(obj) && (isInIncludedPackages(obj) || isInIncludedClasses(obj));
    }

    /**
     * Specifies whether an object belongs to the list of included packages or not.
     * 
     * @param obj The object to compress.
     * @return Whether the object is in the list of included packages or not.
     */
    protected final boolean isInIncludedPackages(final Object obj) {
        Class<?> objClass = obj.getClass();
        if (includePackages != null && includePackages.size() > 0) {
            if (obj instanceof Collection<?> && ((Collection<?>) obj).size() > 0) {
                objClass = ((Collection<?>) obj).toArray()[0].getClass();
            }
            for (String includePackage:includePackages) {
                if (objClass.getPackage().getName().contains(includePackage)) {
                    return true;
	            }
            }
        }
        return false;
    }

    /**
     * Specifies whether an object belongs to the list of included classes or not.
     * 
     * @param obj The object to inspect.
     * @return Whether the object is in the list of included classes or not.
     */
    protected final boolean isInIncludedClasses(final Object obj) {
        return includeClasses != null && includeClasses.size() > 0 && includeClasses.contains(obj.getClass().getName());
    }

    /**
     * Specifies whether an object belongs to the list of excluded classes or not.
     * 
     * @param obj The object to inspect.
     * @return Whether the object is in the list of excluded classes or not.
     */
    protected final boolean isInExcludedClasses(final Object obj) {
        return excludeClasses != null && excludeClasses.size() > 0 && excludeClasses.contains(obj.getClass().getName());
    }

    /**
     * @return The packages that shall be compressed.
     */
    public List<String> getIncludePackages() {
        return includePackages;
    }

    /**
     * @param newIncludePackages The packages that shall be compressed.
     */
    public void setIncludePackages(final List<String> newIncludePackages) {
        includePackages = newIncludePackages;
    }

    /**
     * @return The classes that shall be compressed.
     */
    public List<String> getIncludeClasses() {
        return includeClasses;
    }

    /**
     * @param newIncludeClasses The classes that shall be compressed.
     */
    public void setIncludeClasses(final List<String> newIncludeClasses) {
        includeClasses = newIncludeClasses;
    }

    /**
     * @return The classes that shall not be compressed.
     */
    public List<String> getExcludeClasses() {
        return excludeClasses;
    }

    /**
     * @param newExcludeClasses
     *            The classes that shall not be compressed.
     */
    public void setExcludeClasses(final List<String> newExcludeClasses) {
        includeClasses = newExcludeClasses;
    }
}
