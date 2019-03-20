tds_path := ${abspath ${TDS_APPRE}}
smartclient_exe := ${join ${dir ${SMARTCLIENT_PATH}}, smartclient}
cur_dir := ${dir ${abspath ${lastword ${MAKEFILE_LIST}}}}
build_ini := ${join ${cur_dir}, build.ini}

build_command := "./tdscli.sh compile @${build_ini}"
run_command := "${smartclient_exe} -E=${environment} -P=${program} -Q"

build:
	@ echo ${smartclient_exe}
	@ echo "1. building project..."
	@ echo " - tds path:   ${tds_path}"
	@ echo " - build file: ${build_ini}"
	@ echo " - command:    ${build_command}"
	@ cd ${tds_path} && eval ${build_command}

run:
	@ echo "1. running project"
	@ echo " - program: ${program}"
	@ echo " - smartclient: ${smartclient_exe}"
	@ echo " - environment: ${environment}"
	@ echo " - command:     ${run_command}"
	@ eval ${run_command}
