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

package org.apache.royale.swf;

/**
 * SWF related constants.
 */
public interface ISWFConstants
{
    /**
     * Assumes a resolution of 72 dpi, at which the Macromedia Flash Player
     * renders 20 twips to a pixel.
     */
    static final int TWIPS_PER_PIXEL = 20;

    static final int WIDE_OFFSET_THRESHOLD = 65535;

    static final float FIXED_POINT_MULTIPLE = 65536.0F;

    static final float FIXED_POINT_MULTIPLE_8 = 256.0F;

    static final float MORPH_MAX_RATIO = 65535.0F;

    static final int GRADIENT_SQUARE = 32768;
}
