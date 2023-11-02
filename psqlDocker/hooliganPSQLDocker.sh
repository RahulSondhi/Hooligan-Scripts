#!/bin/bash 
# Package Versioning
PSQL_MAJOR_VERSION='15'
PSQL_MINOR_VERSION='4'

# DB Docker Access
DOCKER_NAME_PREFIX='Hooligan-PSQL-Docker'
DB_NAME='test'
DB_USER='test'
DB_PASSWORD='test'

# Internal Vars
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
DOCKER_IMAGE_NAME=$DOCKER_NAME_PREFIX-$DB_NAME-$PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION
DOCKER_VOLUME_NAME=$DOCKER_NAME_PREFIX-$DB_NAME-Data

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

# Function for CLI Checks
cli_check() {
	# Checking OS
	print_section_header "Checking OS"
	if command -v apt-get &> /dev/null; then
		print_bullet "${GREEN}apt-get package manager for Linux Detected"
		MAC=false
	elif command -v brew &> /dev/null; then
		print_bullet "${GREEN}brew package manager for Mac Detected"
		MAC=true
	else
		print_bullet "${RED}Requires brew for MacOS or apt-get for Linux"
		exit 1
	fi

	# Check if psql is installed
	print_section_header "Checking for Postgresql client version ${PSQL_MAJOR_VERSION}"
	if command -v psql &> /dev/null && psql -V | grep -o -E '[0-9]+' | head -1 | grep -q ${PSQL_MAJOR_VERSION}; then
		print_bullet "${GREEN}Postgresql is installed."
	else
		print_bullet "${RED}Postgresql version ${PSQL_MAJOR_VERSION} is not installed. Installing Postgresql."

		# Install psql using package manager (apt for Ubuntu/Debian, brew for macOS)
		if $MAC; then
			brew install postgresql@${PSQL_MAJOR_VERSION}
			brew link --overwrite postgresql@${PSQL_MAJOR_VERSION}
			brew services start postgresql@${PSQL_MAJOR_VERSION}
		else
			sudo apt-get install -y postgresql-${PSQL_MAJOR_VERSION}
		fi
	fi

	# Check if Docker is installed
	print_section_header "Checking for Docker"
	if command -v docker &> /dev/null; then
		print_bullet "${GREEN}Docker is installed."
	else
		print_bullet "${RED}Docker is not installed. Installing Docker."

		# Install Docker using package manager (special curl for Ubuntu/Debian, brew cask for macOS)
		if $MAC; then
			brew install docker --cask
		else
			curl -fsSL https://get.docker.com/ | sh
		fi
	fi

	# Wait for Docker To Boot
	print_section_header "Checking If Docker Is On"
	if docker images &> /dev/null; then
		print_bullet "${GREEN}Docker is running."
	else
		print_bullet "${RED}Docker is not running. Booting up."
		if $MAC; then
			open -g -a docker 
		else
			systemctl --user start docker-desktop
		fi

		print_bullet "${NC} Waiting for docker To Boot..."
		until docker images &> /dev/null; 
		do 
			sleep 5; 
		done
		
		print_bullet "${GREEN} Docker Booted Up"
	fi
}

# Function for stopping service logic
stop_service() {
	print_section_header "Stopping Docker Image"
	if docker ps -a | grep -q "$DOCKER_IMAGE_NAME"; then
		docker stop $DOCKER_IMAGE_NAME > /dev/null
		print_bullet "${GREEN}Docker Image Stopped and Removed."
		exit 0
	else
		print_bullet "${RED}No Docker Image Found To Stop"
		exit 1
	fi
}

# Function for starting service logic
start_service(){
	# Checking if we have postgres image
	print_section_header "Checking if Docker has Postgres image for $PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION"
	if docker images | grep "postgres" | awk '{print $2}' | grep -q "$PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION"; then
		print_bullet "${GREEN}Postgres image found."
	else
		print_bullet "${RED}Postgres image not found. Pulling image for Postgres $PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION."
		docker pull postgres:$PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION
		print_bullet "${GREEN}Postgres image pulled."
	fi

	# Checking if we have postgres volume setup
	print_section_header "Checking if Docker volume for DB is setup"
	if docker volume ls | grep -q "$DOCKER_VOLUME_NAME"; then
		print_bullet "${GREEN}Docker volume found."
	else
		print_bullet "${RED}Docker volume not found. Creating Docker volume for DB."
		docker volume create "$DOCKER_VOLUME_NAME"
		print_bullet "${GREEN}Docker Volume Created."
	fi

	print_section_header "Checking if PSQL port is open"
	if lsof -Pi :5432 -sTCP:LISTEN -t &> /dev/null; then
		print_bullet "${RED}Port 5432 is open by another process"
		exit 1
	else
		print_bullet "${GREEN}Port 5432 is ready for use"
	fi

	# Starting PSQL server in Docker
	print_section_header "Starting PSQL server in Docker"
	if docker ps -a | grep -q "$DOCKER_IMAGE_NAME"; then
		print_bullet "${GREEN}Running stopped Docker image"
		docker start "$DOCKER_IMAGE_NAME" > /dev/null
	else 
		print_bullet "${GREEN}Running new Docker image"
		docker run --name "$DOCKER_IMAGE_NAME" \
			-e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD -e POSTGRES_DB=$DB_NAME \
			-p 5432:5432 -v "$DOCKER_VOLUME_NAME:/var/lib/postgresql/data" -d postgres:$PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION \
			> /dev/null
	fi

	# Checking if PSQL Server in Docker is running
	print_section_header "Checking if PSQL Server in Docker is running"
	if docker ps | grep -q "$DOCKER_IMAGE_NAME"; then
		print_bullet "${GREEN}Docker image confirmed to be running."
	else
		print_bullet "${RED}Docker image not found. T-T Check what happened!"
		exit 1
	fi

	# Checking if DB Schema is setup
	print_section_header "Summary"
	print_bullet "${NC}Docker Image: $DOCKER_IMAGE_NAME"
	print_bullet "${NC}Docker Volume: $DOCKER_VOLUME_NAME"
	print_bullet "${NC}DB Name: $DB_NAME"
	print_bullet "${NC}PSQL Version: $PSQL_MAJOR_VERSION.$PSQL_MINOR_VERSION"
}

# Bootscript

# Checking Params
if [[ ! -n $1 ]]; then 
	echo -e "Hooligan PSQL Helper: ${RED}Must pass 'start' or 'stop' as parameter"
	exit 1
else
  OPERATION="$1"
fi

if [ $OPERATION = "stop" ]; then
	echo "Hooligan PSQL Helper: Stopping Service"
	cli_check
	stop_service
	echo "\n"
elif [ $OPERATION != "start" ]; then
	echo -e "Hooligan PSQL Helper: ${RED}Must pass 'start' or 'stop' as parameter"
	exit 1
else
	echo "Hooligan PSQL Helper: Starting Service"
	cli_check
	start_service
fi
