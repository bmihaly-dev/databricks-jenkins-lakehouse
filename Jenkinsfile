pipeline {
  agent any
  options { timestamps(); ansiColor('xterm') }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Sanity')   { steps { echo '✅ Jenkins ok, repo ok – kész a Fázis 1 baseline.' } }
  }
}