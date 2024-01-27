#!/usr/bin/env bash 
# How To Use:
# source "$(dirname $0)/../relative-path/util/printUtil.sh"

# Internal Vars
NC='\033[0m' # No Color

# Function to print a section header
print_section_header() {
  echo -e "\n${NC}$(printf '=%.0s' $(seq 80))"
  echo -e "${NC}$1"
  echo -e "${NC}$(printf '=%.0s' $(seq 80))"
}

# Function to print bullet points
print_bullet() {
  echo -e "${NC}=> $1"
}

# Function to pause
print_pause() {
	echo -e "\nPress any key to resume..."
  read -s -n 1
}


# Exporting Functions
export -f print_section_header
export -f print_bullet
export -f print_pause