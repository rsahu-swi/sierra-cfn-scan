#!/bin/sh

if [ -z "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "set the cloudformation_directory input value for the action. Quitting."
  exit 1
fi

if [ ! -d "$INPUT_CLOUDFORMATION_DIRECTORY" ]; then
  echo "${INPUT_CLOUDFORMATION_DIRECTORY} path not found. Quitting."
  exit 1
fi

if [ -z "$INPUT_SCANNER" ]; then
  echo "set the scanner input value for the action. Please use 'cfn-lint', 'cfn-nag', 'checkov', or 'all' Quitting."
  exit 1
fi

case $INPUT_SCANNER in

  cfn-lint|all)
    echo -n "scanning with cfn-lint"
    cfn-lint ${INPUT_CLOUDFORMATION_DIRECTORY}* -f sarif > cfn_lint.sarif
    ;;&

  cfn-nag|all)
    echo -n "...scanning with cfn-nag"
    cfn_nag_scan --input-path ${INPUT_CLOUDFORMATION_DIRECTORY} --output-format sarif > cfn_nag.sarif
    ;;&

  checkov|all)
    echo -n "...scanning with checkov"
    checkov -d ${INPUT_CLOUDFORMATION_DIRECTORY} -o sarif
    mv results.sarif cfn_checkov.sarif
    ;;&

  *)
    echo -n "Environment variable SCANNER is not set allowed option. Please use 'cfn-lint', 'cfn-nag', 'checkov', or 'all' Quitting."
    exit 1
    ;;
esac
