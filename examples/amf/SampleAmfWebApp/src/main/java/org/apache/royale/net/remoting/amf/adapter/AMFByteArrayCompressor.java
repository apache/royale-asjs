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

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.DataFormatException;

import flex.messaging.io.SerializationContext;
import flex.messaging.io.amf.Amf3Input;
import flex.messaging.io.amf.Amf3Output;

/**
 * The {@link AMFByteArrayCompressor} provides methods for AMF to Java compression.
 */
public final class AMFByteArrayCompressor {

    /**
     * Default constructor.
     */
    private AMFByteArrayCompressor() {

    }

    /**
     * Inflate (uncompress) an array of bytes into a Java object.
     * 
     * @param ba The bytearray
     * @return The compressed object.
     * @throws AMFCompressionException if there's an error during the compression.
     */
    public static Object inflate(final byte[] ba) throws AMFCompressionException {
        Object result = null;
        try {
            ByteArrayInputStream bais = new ByteArrayInputStream(ByteArrayCompressor.inflate(ba));
            SerializationContext sc = new SerializationContext();
            Amf3Input amf3Input = new Amf3Input(sc);
            amf3Input.setInputStream(bais);
            result = amf3Input.readObject();
            amf3Input.close();
            bais.close();
        } catch (ClassNotFoundException e) {
            throw new AMFCompressionException(AMFCompressionError.AMF_COMPRESSION_ERROR);
        } catch (IOException e) {
            throw new AMFCompressionException(AMFCompressionError.AMF_COMPRESSION_ERROR);
        } catch (DataFormatException e) {
            throw new AMFCompressionException(AMFCompressionError.AMF_COMPRESSION_ERROR);
        }
        return result;
    }

    /**
     * Deflate (compress) a Java object into a bytearray.
     * 
     * @param obj The serializable Java object.
     * @return The uncompressed object.
     * @throws AMFCompressionException if there's an error during the compression.
     */
    public static byte[] deflate(final Object obj) throws AMFCompressionException {
        byte[] ba = null;
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            SerializationContext sc = new SerializationContext();
            Amf3Output amf3Output = new Amf3Output(sc);
            amf3Output.setOutputStream(baos);
            amf3Output.writeObject(obj);
            amf3Output.flush();
            amf3Output.close();
            baos.close();
            ba = ByteArrayCompressor.deflate(baos.toByteArray());
        } catch (IOException e) {
            throw new AMFCompressionException(AMFCompressionError.AMF_COMPRESSION_ERROR);
        } catch (DataFormatException e) {
            throw new AMFCompressionException(AMFCompressionError.AMF_COMPRESSION_ERROR);
        }
        return ba;
    }
}
