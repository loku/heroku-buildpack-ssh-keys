#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompileMissingSshKey()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 1 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "       Can't find the key file"  "`cat ${STD_OUT}`"
}

testCompileInvalidSshKey()
{
  mkdir ${BUILD_DIR}/deploy
  touch ${BUILD_DIR}/deploy/id_rsa

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 1 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "       SSH_KEY was invalid"  "`cat ${STD_OUT}`"
}

testCompileValidSshKey()
{
  mkdir ${BUILD_DIR}/deploy
  ssh-keygen -q -N '' -f ${BUILD_DIR}/deploy/id_rsa

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "       SSH_KEY was invalid"  "`cat ${STD_OUT}`"

  # arrow "Checking GitHub identity"
  # indent `$GIT_SSH -T git@github.com 2>&1`

}

testCompileShowExistingKey()
{
  echo "Existing keys"
  ls ~/.ssh
}