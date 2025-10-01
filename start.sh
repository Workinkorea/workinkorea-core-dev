#!/bin/bash

# work in korea core start script

set -e  # 에러 발생 시 스크립트 중단

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 헤더 출력
print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "           Work in Korea Core 시작 스크립트"
    echo "=================================================="
    echo -e "${NC}"
}

# 메시지 출력
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_error() {
    print_message "${RED} ERROR: $1 ${NC}"
}

print_success() {
    print_message "${GREEN} $1${NC}"
}

print_info() {
    print_message "${BLUE} $1 ${NC}"
}

print_warning() {
    print_message "${YELLOW} WARNING: $1 ${NC}"
}


# 필수 환경 확인
check_environment(){
    print_info "환경 확인 중..."

    if ! [ -f .env ]; then
        print_error ".env 파일이 없습니다."
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        print_error "Docker가 설치되어 있지 않습니다."
        exit 1
    fi

    if ! command -v docker compose &> /dev/null; then
        print_error "Docker Compose가 설치되어 있지 않습니다."
        exit 1
    fi   
    
    print_success "환경 확인이 완료되었습니다."
}


# 네트워크 생성
create_network(){
    print_info "네트워크 확인 중..."
    if docker network ls | grep -q "core_network"; then
        print_success "네트워크가 이미 존재합니다."
        return
    fi

    print_info "네트워크 생성 중..."
    docker network create core_network
    print_success "네트워크가 생성되었습니다."
}

# 모든 서비스 실행
start_services(){
    print_info "모든 서비스 실행 중..."
    docker compose --profile proxy --profile cicd --profile db --profile s3 up -d
    print_success "모든 서비스가 실행되었습니다."
}


# 메인 시작 함수
main(){
    print_header
    check_environment
    create_network
    print_success "모든 작업이 완료되었습니다."
    print_info "서비스 실행 중..."
    start_services
    print_success "서비스가 실행되었습니다."
}

main "$@"