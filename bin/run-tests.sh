
#!/bin/bash
set -exu

echo "Run rspec"
bundle exec rspec

# echo "Install Rubocop"
# gem install rubocop

# echo "Run Rubocop"
# bundle exec rubocop --format json -o rubocop-result.json

# sleep 2m

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

# echo $HEROKU_APP_NAME

echo "Running sonar scanner - "

sonar-scanner -X \
  -Dsonar.login=$SONAR_TOKEN \
  # -Dsonar.branch.name=$(heroku config:get HEROKU_BRANCH -a $HEROKU_APP_NAME) \
  # -Dsonar.pullrequest.base=master \
  # -Dsonar.pullrequest.provider=GitHub \
  # -Dsonar.pullrequest.github.repository=SangramTester/depot \
  # -Dsonar.pullrequest.key=$HEROKU_PR_NUMBER
