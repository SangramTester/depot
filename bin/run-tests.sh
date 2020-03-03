
#!/bin/bash
set -exu

echo "Run rspec"
bundle exec rspec

# echo "Install Rubocop"
# gem install rubocop

# echo "Run Rubocop"
# bundle exec rubocop --format json -o rubocop-result.json


echo "Export Sonar scanner version"
export SONAR_SCANNER_VERSION=4.2.0.1873

echo "set Sonar scanner home"
export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux

echo "remove Sonar scanner home"
rm -rf $SONAR_SCANNER_HOME

echo "create Sonar scanner home"
mkdir -p $SONAR_SCANNER_HOME

echo "curl to get Sonar scanner"
curl -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip

echo "unzip Sonar scanner"
unzip $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/

echo "remove Sonar scanner zip"
rm $HOME/.sonar/sonar-scanner.zip

echo "set Sonar scanner path"
export PATH=$SONAR_SCANNER_HOME/bin:$PATH

echo "set Sonar scanner home"
export SONAR_SCANNER_OPTS="-server"

echo "test installation========================================================"
sonar-scanner -h

echo "*** Get github PR number. Put 0 if the response is empty ***"
GIT_PR_NUMBER=$(curl https://api.github.com/repos/SangramTester/depot/pulls?head=SangramTester:$HEROKU_TEST_RUN_BRANCH \
 -H "Authorization: token $GITHUB_API_KEY" \
 | ruby -e "require 'json'; response = JSON.parse(ARGF.read); response.count > 0 ? (puts response[0]['number']) : (puts 0) ")

echo "Running sonar scanner - "
echo "PR number========================================================"
echo $GIT_PR_NUMBER
echo $HEROKU_TEST_RUN_BRANCH
echo "test"
echo "PR number========================================================"

sonar-scanner -X \
  -Dsonar.login=$SONAR_TOKEN \
  -Dsonar.pullrequest.base=master \
  -Dsonar.branch.name=$HEROKU_TEST_RUN_BRANCH \
  -Dsonar.pullrequest.key=$GIT_PR_NUMBER
