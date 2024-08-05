#!/usr/bin/env bash 
# How To Use:
# source "$(dirname $0)/../relative-path/util/printUtil.sh"

# Internal Vars
NC='\033[0m'
Cyan='\033[0;36m'
Yellow='\033[1;33m'

# Function to print a section header
print_section_header() {
  string=$1
  string_len=${#string}
  terminal_len=$(tput cols)
  symbol_len_left=$(((terminal_len/2) - (string_len/2) - 2))
  symbol_len_right=$((terminal_len - 1 - (string_len + 1 + symbol_len_left)))

  echo -e "\n${NC}$(printf '=%.0s' $(seq $terminal_len))"
  echo -e "${NC}|$(printf "%0$((terminal_len - 2))d" 0|tr '0' ' ')|"
  echo -e "${NC}|$(printf "%0${symbol_len_left}d" 0|tr '0' ' ')${Cyan}$string${NC}$(printf "%0${symbol_len_right}d" 0|tr '0' ' ')|"
  echo -e "${NC}|$(printf "%0$((terminal_len - 2))d" 0|tr '0' ' ')|"
  echo -e "${NC}$(printf '=%.0s' $(seq $terminal_len))"

}

# Function to print a section header
print_section_sub_header() {
  string=$1
  string_len=${#string}
  terminal_len=$(tput cols); 
  symbol_len_left=$(((terminal_len/2) - (string_len/2) - 4))
  symbol_len_right=$((terminal_len - 2 - (string_len + 2 + symbol_len_left)))

  echo -e "\n${NC}$(printf "%0${symbol_len_left}d" 0|tr '0' '=')| ${Yellow}$string${NC} |$(printf "%0${symbol_len_right}d" 0|tr '0' '=')"
}

# Function to print bullet points

print_bullet() {
  [ -z "$2" ] && arrow_len=1 || arrow_len=$2

  echo -e "${NC}$(printf '=%.0s' $(seq $arrow_len))> $1"
}

# Function to pause
print_pause() {
	echo -e "\nPress any key to resume..."
  read -s -n 1
}


# Exporting Functions
export -f print_section_header
export -f print_section_sub_header
export -f print_bullet
export -f print_pause