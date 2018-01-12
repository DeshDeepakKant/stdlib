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

# RULES #

#/
# Runs Fortran benchmarks consecutively.
#
# ## Notes
#
# -   The recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This rule is useful when wanting to glob for Fortran benchmark files (e.g., run all Fortran benchmarks for a particular package).
#
#
# @param {string} [BENCHMARKS_FILTER] - file path pattern (e.g., `.*/blas/base/daxpy/.*`)
# @param {string} [FORTRAN_COMPILER] - Fortran compiler (e.g., `gfortran`)
#
# @example
# make benchmark-fortran
#
# @example
# make benchmark-fortran BENCHMARKS_FILTER=.*/blas/base/daxpy/.*
#/
benchmark-fortran:
	$(QUIET) $(FIND_FORTRAN_BENCHMARKS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && \
		$(MAKE) clean && \
		$(MAKE) && \
		FORTRAN_COMPILER="$(FC)" \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-fortran

#/
# Runs a specified list of Fortran benchmarks consecutively.
#
# ## Notes
#
# -   The recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This rule is useful when wanting to run a list of Fortran benchmark files generated by some other command (e.g., a list of changed Fortran benchmark files obtained via `git diff`).
#
#
# @param {string} FILES - list of Fortran benchmark file paths
# @param {string} [FORTRAN_COMPILER] - Fortran compiler (e.g., `gfortran`)
#
# @example
# make benchmark-fortran-files FILES='/foo/benchmark.f /bar/benchmark.f'
#/
benchmark-fortran-files:
	$(QUIET) for file in $(FILES); do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && \
		$(MAKE) clean && \
		$(MAKE) && \
		FORTRAN_COMPILER="$(FC)" \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-fortran-files
