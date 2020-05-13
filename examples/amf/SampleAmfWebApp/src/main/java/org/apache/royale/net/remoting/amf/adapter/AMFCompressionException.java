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

/**
 * Thrown to indicate that there was a problem compressing an ActionScript Object.
 */
public class AMFCompressionException extends RuntimeException {
    
	private static final long serialVersionUID = 3373303053093469687L;

	/**
	 * Creates an exception with an error code.
	 *
	 * @param compressionError the amf compression error
	 */
	public AMFCompressionException(AMFCompressionError compressionError) {
		super(compressionError.getMessage());
	}

	/**
	 * Creates an exception with an error code and cause.
	 *
	 * @param compressionError the amf compression error
	 * @param cause the cause
	 */
	public AMFCompressionException(AMFCompressionError compressionError, Throwable cause) {
		super(compressionError.getMessage(), cause);
	}
}
