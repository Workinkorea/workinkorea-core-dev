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

# sudo 권한 확인 및 비밀번호 입력
check_sudo_access(){
    print_info "sudo 권한 확인 중..."
    
    # sudo 권한이 필요한지 확인
    if sudo -n true 2>/dev/null; then
        print_success "sudo 권한이 이미 활성화되어 있습니다."
        return 0
    fi
    
    print_warning "일부 작업에 sudo 권한이 필요합니다."
    print_info "sudo 비밀번호를 입력해주세요:"
    
    # 비밀번호 입력 및 sudo 세션 활성화
    if sudo -v; then
        print_success "sudo 권한이 활성화되었습니다."
        return 0
    else
        print_error "sudo 비밀번호가 올바르지 않거나 권한이 없습니다."
        exit 1
    fi
}


# 데이터 디렉토리 생성
create_data_directories(){
    print_info "데이터 디렉토리 확인 및 생성 중..."
    
    # PostgreSQL 데이터 디렉토리
    if [ ! -d "database/postgresql-dev/data" ]; then
        print_info "PostgreSQL 데이터 디렉토리 생성 중..."
        mkdir -p database/postgresql-dev/data || sudo mkdir -p database/postgresql-dev/data
        
        # 소유권 및 권한 설정
        sudo chown -R 999:999 database/postgresql-dev/data 2>/dev/null || true
        sudo chmod 700 database/postgresql-dev/data 2>/dev/null || true
        print_success "PostgreSQL 데이터 디렉토리가 생성되었습니다."
    else
        print_success "PostgreSQL 데이터 디렉토리가 이미 존재합니다."
    fi
    
    # Redis 데이터 디렉토리
    if [ ! -d "database/redis-dev/data" ]; then
        print_info "Redis 데이터 디렉토리 생성 중..."
        mkdir -p database/redis-dev/data || sudo mkdir -p database/redis-dev/data
        
        # 소유권 및 권한 설정
        sudo chown -R 999:999 database/redis-dev/data 2>/dev/null || true
        sudo chmod 755 database/redis-dev/data 2>/dev/null || true
        print_success "Redis 데이터 디렉토리가 생성되었습니다."
    else
        print_success "Redis 데이터 디렉토리가 이미 존재합니다."
    fi
    
    # Jenkins 데이터 디렉토리
    if [ ! -d "jenkins/data" ]; then
        print_info "Jenkins 데이터 디렉토리 생성 중..."
        mkdir -p jenkins/data || sudo mkdir -p jenkins/data
        
        # 소유권 및 권한 설정
        sudo chown -R 1000:1000 jenkins/data 2>/dev/null || true
        sudo chmod 755 jenkins/data 2>/dev/null || true
        print_success "Jenkins 데이터 디렉토리가 생성되었습니다."
    else
        print_success "Jenkins 데이터 디렉토리가 이미 존재합니다."
    fi
    
    # MinIO 데이터 디렉토리
    if [ ! -d "minio/data" ]; then
        print_info "MinIO 데이터 디렉토리 생성 중..."
        mkdir -p minio/data || sudo mkdir -p minio/data
        print_success "MinIO 데이터 디렉토리가 생성되었습니다."
    else
        print_success "MinIO 데이터 디렉토리가 이미 존재합니다."
    fi
    
    # Traefik 데이터 및 로그 디렉토리
    if [ ! -d "traefik/data" ]; then
        print_info "Traefik 데이터 디렉토리 생성 중..."
        mkdir -p traefik/data || sudo mkdir -p traefik/data
        touch traefik/data/acme.json 2>/dev/null || sudo touch traefik/data/acme.json
        
        # acme.json 권한 설정
        sudo chmod 600 traefik/data/acme.json 2>/dev/null || chmod 600 traefik/data/acme.json 2>/dev/null || true
        print_success "Traefik 데이터 디렉토리가 생성되었습니다."
    else
        print_success "Traefik 데이터 디렉토리가 이미 존재합니다."
    fi
    
    if [ ! -d "traefik/logs" ]; then
        print_info "Traefik 로그 디렉토리 생성 중..."
        mkdir -p traefik/logs || sudo mkdir -p traefik/logs
        print_success "Traefik 로그 디렉토리가 생성되었습니다."
    else
        print_success "Traefik 로그 디렉토리가 이미 존재합니다."
    fi
    
    print_success "모든 데이터 디렉토리 확인이 완료되었습니다."
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
    check_sudo_access
    create_data_directories
    create_network
    print_success "모든 작업이 완료되었습니다."
    print_info "서비스 실행 중..."
    start_services
    print_success "서비스가 실행되었습니다."
}

main "$@"