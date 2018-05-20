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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.DataFormatException;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

/**
 * The {@link ByteArrayCompressor} class provides methods for bytearray compression.
 */
public final class ByteArrayCompressor {

    /**
     * Default constructor.
     */
    private ByteArrayCompressor() {
    }

    /**
     * Compresses a bytearray.
     * 
     * @param ba The source bytearray.
     * @return A compressed bytearray.
     * @throws IOException If there is an IO error.
     * @throws DataFormatException If the data cannot be uncompressed.
     */
    public static byte[] deflate(final byte[] ba) throws IOException, DataFormatException {
        Deflater deflater = new Deflater();
        deflater.setInput(ba);
        deflater.finish();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        final int overflow = 128;
        byte[] defBa = new byte[ba.length + overflow];
        while (!deflater.finished()) {
            int count = deflater.deflate(defBa);
            baos.write(defBa, 0, count);
        }
        baos.close();
        return baos.toByteArray();
    }

    /**
     * Uncompresses an previously compressed bytearray.
     * 
     * @param ba The compressed bytearray.
     * @return An uncompressed bytearray.
     * @throws IOException If there is an IO error.
     * @throws DataFormatException If the data cannot be uncompressed.
     */
    public static byte[] inflate(final byte[] ba) throws IOException, DataFormatException {
        Inflater inflater = new Inflater();
        inflater.setInput(ba);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] infBa = new byte[ba.length * 2];
        while (!inflater.finished()) {
            int count = inflater.inflate(infBa);
            baos.write(infBa, 0, count);
        }
        baos.close();
        return baos.toByteArray();
    }
}
