#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testSshFails()
{
  capture ssh -T -i ${HOME}/.ssh/id_rsa -o StrictHostKeyChecking=no git@github.com
  assertEquals "Expected STD_OUT to be empty; was <$(cat ${STD_OUT})>" "" "$(cat ${STD_OUT})"
  assertFileContains "" "Warning: Permanently added 'github.com,207.97.227.239' (RSA) to the list of known hosts." "${STD_ERR}"
  assertFileContains "" "Permission denied (publickey)." "${STD_ERR}"
  rm -fr ${HOME}/.ssh
}

testCompileMissingSshKey()
{
  compile
  assertCapturedError "Can't find the key file"
}

testCompileInvalidSshKey()
{
  mkdir ${BUILD_DIR}/deploy
  touch ${BUILD_DIR}/deploy/id_rsa
  touch ${BUILD_DIR}/deploy/known_hosts

  compile
  assertCapturedError "SSH_KEY was invalid"
}

testCompileValidSshKey()
{
  mkdir ${BUILD_DIR}/deploy
  ssh-keygen -q -N '' -f ${BUILD_DIR}/deploy/id_rsa
  touch ${BUILD_DIR}/deploy/known_hosts

  compile
  assertCapturedSuccess
  assertCaptured "SSH_KEY is valid"
  assertCaptured "Copied ssh key deploy/id_rsa to user's ssh dir"
  assertCaptured "Copied deploy/known_hosts to user's ssh dir"

  capture ssh -T -i ${HOME}/.ssh/id_rsa -o StrictHostKeyChecking=no git@github.com
  assertEquals "Expected STD_OUT to be empty; was <$(cat ${STD_OUT})>" "" "$(cat ${STD_OUT})"
  assertFileContains "" "Warning: Permanently added 'github.com,207.97.227.239' (RSA) to the list of known hosts." "${STD_ERR}"
  assertFileContains "" "Permission denied (publickey)." "${STD_ERR}"
}
