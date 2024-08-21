#!/bin/bash

set -euo pipefail

#
# Reference: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/build.sh
#
# This script requires buildkit: https://docs.docker.com/buildx/working-with-buildx/
#
IMAGE_NAME="ascend/cann"
IMAGE_TAG=""
CANN_VERSION=""
CANN_CHIP=""
OS=""
OS_VERSION=""
PY_VERSION=""
ARCHES=""
LOAD_ARG=""
PUSH_ARG=""

args=("$@")
script_name=$(basename $0)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
run_cmd_output=""
run_cmd_return=0
debug_flag=0
dry_run=0

err() {
    local mesg=$1; shift
    printf "ERROR: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}\n\n" "$mesg" 1>&2
    if [[ $# -gt 0 ]]; then
        printf '%s ' "${@}" 1>&2
        printf '\n\n'
    fi
    exit 1
}

msg() {
    local mesg=$1; shift
    printf ">>> $(basename ${BASH_SOURCE[1]})#${BASH_LINENO[0]} %s\n\n" "$mesg"
    if [[ $# -gt 0 ]]; then
        printf '%s ' "${@}"
        printf '\n\n'
    fi
}

debug() {
    # $1: The message to print.
    if [[ ${debug_flag} -eq 1 ]]; then
        local mesg=$1; shift
        printf "%s\n\n" "### DEBUG: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}" 1>&2
        if [[ $# -gt 0 ]]; then
            printf '%s ' "${@}" 1>&2
            printf '\n\n'
        fi
    fi
}

warning() {
    local mesg=$1; shift
    printf "WARNING: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}\n\n" "$mesg" 1>&2
    if [[ $# -gt 0 ]]; then
        printf '%s ' "${@}" 1>&2
        printf '\n\n'
    fi
}

norun() {
    local mesg=$1; shift
    printf "XXXX NORUN: $(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} ${mesg}\n\n" "$mesg"
    if [[ $# -gt 0 ]]; then
        printf '%s ' "$@"
        printf '\n\n'
    fi
}

usage() {
    echo "${script_name} - CANN Image Build Helper"
    echo
    echo "Usage: ${script_name} [options]"
    echo
    echo "OPTIONS"
    echo
    echo "    -h, --help            - Show this message."
    echo "    -n, --dry-run         - Show commands but don't do anything."
    echo "    -d, --debug           - Show debug output."
    ## TODO: allow the user to pass arguments to docker buildx
    echo "    --load                - Load the images on the build host. (Out of the docker cache)."
    echo "    --push                - Push the images to the remote repository."
    echo "    --image-name string   - The image name to use. Default: ascend/cann"
    echo "    --cann-version string - The cann version to use."
    echo "    --cann-chip string    - The cann chip to use."
    echo "    --os string           - The target operating system. ubuntu or openeuler"
    echo "    --os-version string   - The target operating system version."
    echo "    --py-version string   - The python version to use."
    echo "    --arch list           - Target architectures as a comma separated string. e.g., --arch amd64,arm64"
    echo
    exit 155
}

# Runs a command. Output is not captured
# To use this function, define the following in your calling script:
# run_cmd_return=""
run_cmd() {
    run_cmd_return=0
    run_cmd_return=0
    # $@: The command and args to run
    if [[ ${dry_run} -eq 1 ]]; then
        SOURCE_LINE_OVERRIDE=2 BASH_LINE_OVERRIDE=1 norun "CMD:" "$@"
    else
        printf "%s\n\n" "$(basename ${BASH_SOURCE[${SOURCE_LINE_OVERRIDE:-1}]})#${BASH_LINENO[${BASH_LINE_OVERRIDE:-0}]} Running command:"
        printf "%s " "${@}"
        printf "\n\n"
        printf "Output: \n\n"
        echo -e "$@" | source /dev/stdin
        run_cmd_return=$?
        echo
        printf "Command returned: %s\n\n" "${run_cmd_return}"
        return $run_cmd_return
    fi
}

if [[ ${#args[@]} -eq 0 ]]; then
  echo
  err "No arguments specified!"
  usage
fi

check_vars() {
    if [[ -z ${CANN_VERSION} ]]; then
        err "--cann-version argument not set!"
    elif [[ -z ${CANN_CHIP} ]]; then
        err "--cann-chip argument not set!"
    elif [[ -z ${OS} ]]; then
        err "--os argument not set!"
    elif [[ -z ${OS_VERSION} ]]; then
        err "--os-version argument not set!"
    elif [[ -z ${PY_VERSION} ]]; then
        err "--py-version argument not set!"
    fi

    if [[ ${OS} != "ubuntu" && ${OS} != "openeuler" ]]; then
        err "Unsupported OS detected: ${OS}"
    fi

    if [[ -n ${ARCHES} ]]; then
        PLATFORM_ARG=`printf '%s ' '--platform'; for var in $(echo $ARCHES | sed "s/,/ /g"); do printf 'linux/%s,' "$var"; done | sed 's/,*$//g'`
        if [[ "${PLATFORM_ARG}" =~ .*,.* ]]; then
            warning "Multiple platforms detected, removing '--load' argument from docker build... (https://github.com/docker/buildx/issues/59)"
            warning "Try doing one platform at a time as a workaround..."
            LOAD_ARG=""
        fi
    fi
}

main() {
    printf "\n"
    debug "${script_name} START"

    for (( a = 0; a < ${#args[@]}; a++ )); do
        if [[ ${args[$a]} == "-h" ]] || [[ ${args[$a]} == "--help" ]]; then
            usage
        elif [[ ${args[$a]} == "-n" ]] || [[ ${args[$a]} == "--dry-run" ]]; then
            debug "found arg 'dry-run'"
            dry_run=1
        elif [[ ${args[$a]} == "-d" ]] || [[ ${args[$a]} == "--debug" ]]; then
            debug "found arg 'debug'"
            debug_flag=1
        elif [[ ${args[$a]} == "--load" ]]; then
            debug "found command '${args[$a]}'"
            LOAD_ARG=${args[$a]}
        elif [[ ${args[$a]} == "--push" ]]; then
            debug "found command '${args[$a]}'"
            PUSH_ARG=${args[$a]}
        elif [[ ${args[$a]} == "--image-name" ]]; then
            debug "found command '${args[$a]}'"
            IMAGE_NAME=${args[(($a+1))]}
            debug "IMAGE_NAME=${IMAGE_NAME}"
            ((a=a+1))
        elif [[ ${args[$a]} == "--cann-version" ]]; then
            debug "found command '${args[$a]}'"
            CANN_VERSION=${args[(($a+1))]}
            debug "CANN_VERSION=${CANN_VERSION}"
            ((a=a+1))
        elif [[ ${args[$a]} == "--cann-chip" ]]; then
            debug "found command '${args[$a]}'"
            CANN_CHIP=${args[(($a+1))]}
            debug "CANN_CHIP=${CANN_CHIP}"
            ((a=a+1))
        elif [[ ${args[$a]} == "--os" ]]; then
            debug "found command '${args[$a]}'"
            OS=${args[(($a+1))]}
            debug "OS=${OS}"
            ((a=a+1))
        elif [[ ${args[$a]} == "--os-version" ]]; then
            debug "found command '${args[$a]}'"
            OS_VERSION=${args[(($a+1))]}
            debug "OS_VERSION=${OS_VERSION}"
            ((a=a+1))
        elif [[ ${args[$a]} == "--py-version" ]]; then
            debug "found command '${args[$a]}'"
            PY_VERSION=${args[(($a+1))]}
            debug "PY_VERSION=${PY_VERSION}"
            ((a=a+1))
        elif [[ ${args[$a]} == "--arch" ]]; then
            debug "found command '${args[$a]}'"
            ARCHES=${args[(($a+1))]}
            debug "ARCHES=${ARCHES}"
            ((a=a+1))
        else
            err "Unknown argument '${args[$a]}'!"
            usage
        fi
    done

    check_vars

    IMAGE_TAG="${CANN_VERSION}-${CANN_CHIP}-${OS}${OS_VERSION}-py${PY_VERSION}"
    run_cmd docker buildx build \
        --pull ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
        -t ${IMAGE_NAME}:${IMAGE_TAG} \
        -f cann/${OS}/Dockerfile \
        --build-arg BASE_VERSION="${OS_VERSION}" \
        --build-arg PY_VERSION="${PY_VERSION}" \
        --build-arg CANN_CHIP="${CANN_CHIP}" \
        --build-arg CANN_VERSION="${CANN_VERSION}" \
        cann/
}

main
