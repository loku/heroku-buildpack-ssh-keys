#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompileMissingSshKey()
{
  compile
  assertCapturedError "Can't find the key file"
}

testCompileInvalidSshKey()
{
  mkdir ${BUILD_DIR}/deploy
  touch ${BUILD_DIR}/deploy/id_rsa

  compile
  assertCapturedError "SSH_KEY was invalid"
}

testCompileValidSshKey()
{
  mkdir ${BUILD_DIR}/deploy
  ssh-keygen -q -N '' -f ${BUILD_DIR}/deploy/id_rsa

  compile
  assertCapturedSuccess
  assertCaptured "SSH_KEY is valid"

  # arrow "Checking GitHub identity"
  # indent `$GIT_SSH -T git@github.com 2>&1`

}

testCompileShowExistingKey()
{
  echo "Existing keys"
  ls ~/.ssh
}