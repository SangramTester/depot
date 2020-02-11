
#!/bin/bash
set -exu

echo "Running sonar scanner"

sonar-scanner \
  -Dsonar.projectKey=SangramTester_depot2 \
  -Dsonar.organization=sangramtester \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io