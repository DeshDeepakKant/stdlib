#/
# @license Apache-2.0
#
# Copyright (c) 2017 The Stdlib Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#/

# VARIABLES #

# Define the path to a script for compiling a C benchmark:
compile_c_benchmark_bin := $(TOOLS_DIR)/scripts/compile_c_benchmark


# RULES #

#/
# Runs C benchmarks consecutively.
#
# ## Notes
#
# -   The recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This rule is useful when wanting to glob for C benchmark files (e.g., run all C benchmarks for a particular package).
#
#
# @param {string} [BENCHMARKS_FILTER] - file path pattern (e.g., `.*/math/base/special/abs/.*`)
# @param {string} [C_COMPILER] - C compiler (e.g., `gcc`)
# @param {string} [BLAS] - BLAS library name (e.g., `openblas`)
# @param {string} [BLAS_DIR] - BLAS directory
#
# @example
# make benchmark-c
#
# @example
# make benchmark-c BENCHMARKS_FILTER=.*/math/base/special/abs/.*
#/
benchmark-c:
	$(QUIET) $(FIND_C_BENCHMARKS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && $(MAKE) clean && \
		OS="$(OS)" \
		NODE="$(NODE)" \
		NODE_PATH="$(NODE_PATH)" \
		C_COMPILER="$(CC)" \
		BLAS="$(BLAS)" \
		BLAS_DIR="$(BLAS_DIR)" \
		CEPHES="$(DEPS_CEPHES_BUILD_OUT)" \
		CEPHES_SRC="$(DEPS_CEPHES_SRC)" \
		"${compile_c_benchmark_bin}" $$file && \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-c

#/
# Runs a specified list of C benchmarks consecutively.
#
# ## Notes
#
# -   The recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This rule is useful when wanting to run a list of C benchmark files generated by some other command (e.g., a list of changed C benchmark files obtained via `git diff`).
#
#
# @param {string} FILES - list of C benchmark file paths
# @param {string} [C_COMPILER] - C compiler (e.g., `gcc`)
# @param {string} [BLAS] - BLAS library name (e.g., `openblas`)
# @param {string} [BLAS_DIR] - BLAS directory
#
# @example
# make benchmark-c-files FILES='/foo/benchmark.c /bar/benchmark.c'
#/
benchmark-c-files:
	$(QUIET) for file in $(FILES); do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && $(MAKE) clean && \
		OS="$(OS)" \
		NODE="$(NODE)" \
		NODE_PATH="$(NODE_PATH)" \
		C_COMPILER="$(CC)" \
		BLAS="$(BLAS)" \
		BLAS_DIR="$(BLAS_DIR)" \
		CEPHES="$(DEPS_CEPHES_BUILD_OUT)" \
		CEPHES_SRC="$(DEPS_CEPHES_SRC)" \
		"${compile_c_benchmark_bin}" $$file && \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-c-files
