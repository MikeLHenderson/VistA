#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2012 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

# Perform a copy of a CACHE.DAT to another directory
# This utility requires root privliges

# Process flow:
# 1. Stop Cache
# 2. Copy CACHE.DAT to directory
# 3. Start Cache

# Stop Cache
service cache stop

# Copy CACHE.DAT to directory
mkdir -p /opt/backup
cp /opt/cachesys/mgr/VISTA/CACHE.DAT /opt/backup/CACHE-`date +%m%d%Y`.DAT

# Start Cache
service cace start
