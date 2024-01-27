#!/bin/bash
source "$(dirname $0)/../util/printUtil.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
  echo "Please provide the path to the project folder."
  exit 1
fi

project_path="$1"

# Change to the project directory
cd "$project_path" || exit 1

# Check if jq is installed
print_section_header "Checking for jq"
if command -v jq &> /dev/null; then
  echo -e "${GREEN}jq is installed."
else
  echo -e "${RED}jq is not installed. Installing jq."

  # Install jq using package manager (apt for Ubuntu/Debian, brew for macOS)
  if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y jq
  elif command -v brew &> /dev/null; then
    brew install jq
  else
    echo "Unable to install jq automatically. Please install jq manually and run the script again."
    exit 1
  fi
fi

# Check if depcheck is installed
print_section_header "Checking for depcheck"
if command -v depcheck &> /dev/null; then
  echo -e "${GREEN}depcheck is installed."
else
  echo -e "${RED}depcheck is not installed. Installing depcheck."
  npm install -g depcheck
fi

# Continue with the rest of the script

# Check for unused packages using depcheck
print_section_header "Checking for unused packages"
unused_packages=$(depcheck . | awk '/^Unused/ { getline; print }' | sed 's/^\*\s*//; s/\s*$//')

# Check if unused packages are actually used in package.json (excluding dependencies and devDependencies)
used_packages=$(jq -r '. | .dependencies + .devDependencies | keys[]' package.json)

if [[ -z $unused_packages ]]; then
  echo -e "${GREEN}No unused packages found."
else
  echo -e "${RED}Unused packages:"
  while IFS= read -r package; do
    package=$(echo "$package" | xargs)  # Trim leading and trailing spaces
    if [[ ! "$used_packages" =~ (^|[[:space:]])"$package"($|[[:space:]]) ]]; then
      print_bullet "$package"
    fi
  done <<< "$unused_packages"
fi

# Check for unused environment variables
print_section_header "Checking for unused environment variables"
unused_variables=""
while IFS= read -r line; do
    if ! grep -q -r --exclude-dir=node_modules "$line" .; then
        unused_variables+="\n$line"
    fi
done < <(grep -v -e '^#' -e '^$' .env)

if [[ -z $unused_variables ]]; then
    echo -e "${GREEN}No unused environment variables found."
else
    echo -e "${RED}Unused environment variables:"
    while IFS= read -r variable; do
        print_bullet "$variable"
    done <<< "$unused_variables"
fi

# Check for outdated packages with major version difference
print_section_header "Checking for outdated packages"
outdated_packages=$(npm outdated --json | jq -r 'to_entries[] | select(.value | (.current | split(".")[0]) != (.latest | split(".")[0])) | .key')
if [[ -z $outdated_packages ]]; then
  echo -e "${GREEN}No outdated packages found."
else
  echo -e "${RED}Outdated packages with major version difference:"
  while IFS= read -r package; do
    print_bullet "$package"
  done <<< "$outdated_packages"
  echo -e "${NC}Use 'npm outdated' for more detailed information."
fi
