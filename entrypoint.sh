#!/bin/sh

if [ -z "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "Environment variable CLOUDFORMATION_DIRECTORY is not set. Quitting."
  exit 1
fi

if [ ! -d "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "${INPUT_CLOUDFORMATION_DIRECTORY} path not found. Quitting."
  exit 1
fi

if [ -z "$INPUT_SCANNER" ]; then
  echo "environment variable SCANNER is not set. Please use 'cfn-lint', 'cfn-nag', 'checkov', or 'all' Quitting."
  exit 1
fi

case $INPUT_SCANNER in

  "cfn-lint")
    echo -n "scanning with only cfn-lint"
    sh -c "cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}*"

    ;;

  "cfn-nag")
    echo -n "...scanning with only cfn-nag"
    sh -c "cfn_nag_scan --input-path ${INPUT_CLOUDFORMATION_DIRECTORY}"
    ;;

  "checkov")
    echo -n "...scanning with only checkov"
    sh -c "checkov -d ${INPUT_CLOUDFORMATION_DIRECTORY}"
    ;;

  "all")
    echo -n "...scanning with all tools"
    sh -c "cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}* -f sarif > cfn_lint.sarif"
    sh -c "cfn_nag_scan --input-path ${INPUT_CLOUDFORMATION_DIRECTORY} --output-format sarif > cfn_nag.sarif"
    sh -c "checkov -d ${INPUT_CLOUDFORMATION_DIRECTORY} -o sarif"
    sh -c "mv results.sarif cfn_checkov.sarif"
    ;;

  *)
    echo -n "Environment variable SCANNER is not set allowed option. Please use 'cfn-lint', 'cfn-nag', 'checkov', or 'all' Quitting."
    exit 1
    ;;
esac
