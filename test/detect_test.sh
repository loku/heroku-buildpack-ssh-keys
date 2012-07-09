#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  mkdir ${BUILD_DIR}/deploy
  touch ${BUILD_DIR}/deploy/id_rsa
  touch ${BUILD_DIR}/deploy/known_hosts
  
  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
  
  assertEquals 0 ${rtrn}
  assertEquals "Private SSH Keys" "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
}

testNoDetectMissingSSHKey()
{
  mkdir ${BUILD_DIR}/deploy
  touch ${BUILD_DIR}/deploy/known_hosts

  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
 
  assertEquals 1 ${rtrn}
  assertEquals "Can't find the ssh key file" "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
}

testNoDetectMissingKnownHosts()
{
  mkdir ${BUILD_DIR}/deploy
  touch ${BUILD_DIR}/deploy/id_rsa

  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
 
  assertEquals 1 ${rtrn}
  assertEquals "Can't find the known hosts file" "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
}
