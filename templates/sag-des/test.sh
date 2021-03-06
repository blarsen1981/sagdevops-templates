#!/bin/sh -e
#*******************************************************************************
#  Copyright ? 2013 - 2018 Software AG, Darmstadt, Germany and/or its licensors
#
#   SPDX-License-Identifier: Apache-2.0
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.                                                            
#
#*******************************************************************************

# if managed image
if [ -d $SAG_HOME/profiles/SPM ] ; then
    # point to local SPM
    export CC_SERVER=http://localhost:8092/spm

    echo "Verifying managed container $CC_SERVER ..."
    sagcc get inventory products -e "DEV" --wait-for-cc

    export CC_WAIT=10
    
    echo "Verifying fixes ..."
    sagcc get inventory fixes
    # -e wMFix.DEV ???

    echo "Verifying inventory ..."
    sagcc get inventory components -e "-DigitalEventServices"
    id=`sagcc get inventory components properties=id includeHeaders=false | grep "OSGI-IS_default-DigitalEventServices"`
    echo "Component id: $id"

    echo "Verifying configs for $id ..."
    sagcc get configuration types $id
    sagcc get configuration instances $id properties=id -e UniversalMessaging
    sagcc get configuration data $id UniversalMessaging -f json -e "UniversalMessaging service"
fi

# echo "TODO: Verifying product runtime ..."

echo "DONE testing"
