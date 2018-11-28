#!/usr/bin/env bash 

if [[ $TRAVIS_BRANCH == 'master' ]];then
	fastlane publish
elif [[ $TRAVIS_BRANCH == 'testflight' ]];then
	fastlane test
elif [[ $TRAVIS_BRANCH == 'firtest' ]];then
	fastlane firtest
else
	fastlane fir
fi
