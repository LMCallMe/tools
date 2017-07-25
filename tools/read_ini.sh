# Simple INI file parser.
#
# Copyright (c) 2009    Kevin Porter / Advanced Web Construction Ltd
#                       (http://coding.tinternet.info, http://webutils.co.uk)
# Copyright (c) 2010-2014     Ruediger Meier <sweet_f_a@gmx.de>
#                             (https://github.com/rudimeier/)
#
# License: BSD-3-Clause
#
# This software is provided under the BSD license.  The text of this license
# is provided below:
#
# --------------------------------------------------------------------------
#
# Copyright (C) 2009 Kevin Porter / Advanced Web Construction Ltd
# Copyright (C) 2010-2014 Ruediger Meier
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the author nor the names of any contributors
#    may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# README
# ======
# This is a comfortable and simple INI file parser to be used in
# bash scripts.
#
# USAGE
# -----
#
# You must source the bash file into your script:
#
# > . read_ini.sh
#
# and then use the read_ini function, defined as:
#
# > read_ini INI_FILE [SECTION] [[--prefix|-p] PREFIX] [[--booleans|b] [0|1]]
#
# If SECTION is supplied, then only the specified section of the file will
# be processed.
#
# After running the read_ini function, variables corresponding to the ini
# file entries will be available to you. Naming convention for variable
# names is:
#
# PREFIX__SECTION__VARNAME
#
# PREFIX is 'INI' by default (but can be changed with the --prefix option),
# SECTION and VARNAME are the section name and variable name respectively.
#
# Additionally you can get a list of all these variable names:
# PREFIX__ALL_VARS
# and get a list of sections:
# PREFIX__ALL_SECTIONS
# and the number of sections:
# PREFIX__NUMSECTIONS
#
# For example, to read and output the variables of this ini file:
#
# -- START test1.ini file
#
# var1="VAR 1"
# var2 = VAR 2
#
# [section1]
# var1="section1 VAR 1"
# var2= section1 VAR 2
#
#
# -- END test1.ini file
#
# you could do this:
#
# -- START bash script
#
# . read_ini.sh
#
# read_ini test1.ini
#
# echo "var1 = ${INI__var1}"
# echo "var2 = ${INI__var2}"
# echo "section1 var1 = ${INI__section1__var1}"
# echo "section1 var2 = ${INI__section1__var2}"
#
# echo "list of all ini vars: ${INI__ALL_VARS}"
# echo "number of sections: ${INI__NUMSECTIONS}"
#
# -- END bash script
#
# OPTIONS
# -------
#
# [--prefix | -p] PREFIX
# String to prepend to generated variable names (automatically followed by '__').
# Default: INI
#
# [--booleans | -b] [0|1]
# Whether to interpret special unquoted string values 'yes', 'no', 'true',
# 'false', 'on', 'off' as booleans.
# Default: 1
#
# INI FILE FORMAT
# ---------------
#
# - Variables are stored as name/value pairs, eg:
# var=value
#
# - Leading and trailing whitespace of the name and the value is discarded.
#
# - Use double or single quotes to get whitespace in the values
#
# - Section names in square brackets, eg:
# [section1]
# var1 = value
#
# - Variable names can be re-used between sections (or out of section), eg:
# var1=value
# [section1]
# var1=value
# [section3]
# var1=value
#
# - Dots are converted to underscores in all variable names.
#
# - Special boolean values: unquoted strings 'yes', 'true' and 'on' are interpreted
# 	as 1; 'no', 'false' and 'off' are interpreted as 0

function read_ini()
{
	# Be strict with the prefix, since it's going to be run through eval
	function check_prefix()
	{
		if ! [[ "${VARNAME_PREFIX}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] ;then
			echo "read_ini: invalid prefix '${VARNAME_PREFIX}'" >&2
			return 1
		fi
	}

	function check_ini_file()
	{
		if [ ! -r "$INI_FILE" ] ;then
			echo "read_ini: '${INI_FILE}' doesn't exist or not" \
				"readable" >&2
			return 1
		fi
	}

	# enable some optional shell behavior (shopt)
	function pollute_bash()
	{
		if ! shopt -q extglob ;then
			SWITCH_SHOPT="${SWITCH_SHOPT} extglob"
		fi
		if ! shopt -q nocasematch ;then
			SWITCH_SHOPT="${SWITCH_SHOPT} nocasematch"
		fi
		shopt -q -s ${SWITCH_SHOPT}
	}

	# unset all local functions and restore shopt settings before returning
	# from read_ini()
	function cleanup_bash()
	{
		shopt -q -u ${SWITCH_SHOPT}
		unset -f check_prefix check_ini_file pollute_bash cleanup_bash
	}

	local INI_FILE=""
	local INI_SECTION=""

	# {{{ START Deal with command line args

	# Set defaults
	local BOOLEANS=1
	local VARNAME_PREFIX=INI
	local CLEAN_ENV=0

	# {{{ START Options

	# Available options:
	#	--boolean		Whether to recognise special boolean values: ie for 'yes', 'true'
	#					and 'on' return 1; for 'no', 'false' and 'off' return 0. Quoted
	#					values will be left as strings
	#					Default: on
	#
	#	--prefix=STRING	String to begin all returned variables with (followed by '__').
	#					Default: INI
	#
	#	First non-option arg is filename, second is section name

	while [ $# -gt 0 ]
	do

		case $1 in

			--clean | -c )
				CLEAN_ENV=1
			;;

			--booleans | -b )
				shift
				BOOLEANS=$1
			;;

			--prefix | -p )
				shift
				VARNAME_PREFIX=$1
			;;

			* )
				if [ -z "$INI_FILE" ]
				then
					INI_FILE=$1
				else
					if [ -z "$INI_SECTION" ]
					then
						INI_SECTION=$1
					fi
				fi
			;;

		esac

		shift
	done

	if [ -z "$INI_FILE" ] && [ "${CLEAN_ENV}" = 0 ] ;then
		echo -e "Usage: read_ini [-c] [-b 0| -b 1]] [-p PREFIX] FILE"\
			"[SECTION]\n  or   read_ini -c [-p PREFIX]" >&2
		cleanup_bash
		return 1
	fi

	if ! check_prefix ;then
		cleanup_bash
		return 1
	fi

	local INI_ALL_VARNAME="${VARNAME_PREFIX}__ALL_VARS"
	local INI_ALL_SECTION="${VARNAME_PREFIX}__ALL_SECTIONS"
	local INI_NUMSECTIONS_VARNAME="${VARNAME_PREFIX}__NUMSECTIONS"
	if [ "${CLEAN_ENV}" = 1 ] ;then
		eval unset "\$${INI_ALL_VARNAME}"
	fi
	unset ${INI_ALL_VARNAME}
	unset ${INI_ALL_SECTION}
	unset ${INI_NUMSECTIONS_VARNAME}

	if [ -z "$INI_FILE" ] ;then
		cleanup_bash
		return 0
	fi

	if ! check_ini_file ;then
		cleanup_bash
		return 1
	fi

	# Sanitise BOOLEANS - interpret "0" as 0, anything else as 1
	if [ "$BOOLEANS" != "0" ]
	then
		BOOLEANS=1
	fi


	# }}} END Options

	# }}} END Deal with command line args

	local LINE_NUM=0
	local SECTIONS_NUM=0
	local SECTION=""

	# IFS is used in "read" and we want to switch it within the loop
	local IFS=$' \t\n'
	local IFS_OLD="${IFS}"

	# we need some optional shell behavior (shopt) but want to restore
	# current settings before returning
	local SWITCH_SHOPT=""
	pollute_bash

	while read -r line || [ -n "$line" ]
	do
#echo line = "$line"

		((LINE_NUM++))

		# Skip blank lines and comments
		if [ -z "$line" -o "${line:0:1}" = ";" -o "${line:0:1}" = "#" ]
		then
			continue
		fi

		# Section marker?
		if [[ "${line}" =~ ^\[[a-zA-Z0-9_]{1,}\]$ ]]
		then

			# Set SECTION var to name of section (strip [ and ] from section marker)
			SECTION="${line#[}"
			SECTION="${SECTION%]}"
			eval "${INI_ALL_SECTION}=\"\${${INI_ALL_SECTION}# } $SECTION\""
			((SECTIONS_NUM++))

			continue
		fi

		# Are we getting only a specific section? And are we currently in it?
		if [ ! -z "$INI_SECTION" ]
		then
			if [ "$SECTION" != "$INI_SECTION" ]
			then
				continue
			fi
		fi

		# Valid var/value line? (check for variable name and then '=')
		if ! [[ "${line}" =~ ^[a-zA-Z0-9._]{1,}[[:space:]]*= ]]
		then
			echo "Error: Invalid line:" >&2
			echo " ${LINE_NUM}: $line" >&2
			cleanup_bash
			return 1
		fi


		# split line at "=" sign
		IFS="="
		read -r VAR VAL <<< "${line}"
		IFS="${IFS_OLD}"

		# delete spaces around the equal sign (using extglob)
		VAR="${VAR%%+([[:space:]])}"
		VAL="${VAL##+([[:space:]])}"
		VAR=$(echo $VAR)


		# Construct variable name:
		# ${VARNAME_PREFIX}__$SECTION__$VAR
		# Or if not in a section:
		# ${VARNAME_PREFIX}__$VAR
		# In both cases, full stops ('.') are replaced with underscores ('_')
		if [ -z "$SECTION" ]
		then
			VARNAME=${VARNAME_PREFIX}__${VAR//./_}
		else
			VARNAME=${VARNAME_PREFIX}__${SECTION}__${VAR//./_}
		fi
		eval "${INI_ALL_VARNAME}=\"\${${INI_ALL_VARNAME}# } ${VARNAME}\""

		if [[ "${VAL}" =~ ^\".*\"$  ]]
		then
			# remove existing double quotes
			VAL="${VAL##\"}"
			VAL="${VAL%%\"}"
		elif [[ "${VAL}" =~ ^\'.*\'$  ]]
		then
			# remove existing single quotes
			VAL="${VAL##\'}"
			VAL="${VAL%%\'}"
		elif [ "$BOOLEANS" = 1 ]
		then
			# Value is not enclosed in quotes
			# Booleans processing is switched on, check for special boolean
			# values and convert

			# here we compare case insensitive because
			# "shopt nocasematch"
			case "$VAL" in
				yes | true | on )
					VAL=1
				;;
				no | false | off )
					VAL=0
				;;
			esac
		fi


		# enclose the value in single quotes and escape any
		# single quotes and backslashes that may be in the value
		VAL="${VAL//\\/\\\\}"
		VAL="\$'${VAL//\'/\'}'"

		eval "$VARNAME=$VAL"
	done  <"${INI_FILE}"

	# return also the number of parsed sections
	eval "$INI_NUMSECTIONS_VARNAME=$SECTIONS_NUM"

	cleanup_bash
}
