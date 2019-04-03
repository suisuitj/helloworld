#!/bin/bash
set -o errexit
set -o nounset
readonly CONTROL_SCRIPT="control"
readonly OUTPUT_DIR="output" #硬性约定，所有结果存放在output文件夹中
readonly BIN_FILE_NAME="helloworld" #<最终程序名称>
readonly CONF_FILE="metric.toml"
readonly BIN_NAME="helloworld" #<程序名称>
readonly BASE_PATH="github.com/suisuitj/helloworld/" #<程序名称>
readonly INSTALL_CMD="${BASE_PATH}${BIN_NAME}" #编译程序的入口文件所在位置
#以golang程序为例
function set_env
{
    export GOPATH=$(pwd)
}
function prepare_files
{
    [[ ! -e ./${OUTPUT_DIR} ]] || {
        rm -rf ./${OUTPUT_DIR}
    }

    mkdir bin
    rm -rf "${BIN_NAME}.tmp"
    mkdir "${BIN_NAME}.tmp"
    ls -1 | fgrep -v "${BIN_NAME}.tmp" | xargs -I{}  cp -r  {} "${BIN_NAME}.tmp"
    
    rm -rf "./src"
    mkdir -p "src/${BASE_PATH}"
    mv "${BIN_NAME}.tmp" "src/${BASE_PATH}${BIN_NAME}"


    mkdir -p ${OUTPUT_DIR}/{bin,} #建立程序运行的目录结构
    mkdir -p ${OUTPUT_DIR}/bin/resource/jdres #建立程序运行的目录结构
    go install $INSTALL_CMD #实际的编译命令
    


    cp bin/${BIN_NAME} ${OUTPUT_DIR}/bin/${BIN_FILE_NAME} #拷贝结果到程序目录中
    cp $CONTROL_SCRIPT ${OUTPUT_DIR}/bin/
    cp ./resource/jdres/ResourceSpecification.json ${OUTPUT_DIR}/bin/resource/jdres/

    rm -rf "./src/"

}
function clear_temp_file
{
    [[ ! -e ./bin ]] || {
        rm -rf ./bin
    }
}
function main
{
    rm -f *.tar.gz *.bin
    set_env
    clear_temp_file
    prepare_files
    clear_temp_file
}
main "$@"
