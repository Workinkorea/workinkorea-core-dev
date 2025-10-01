# Work in Korea core Server

Work in Korea core 시스템의 마이크로서비스 인프라입니다.

## 서비스 구성

| 서비스 | 프로필 | 포트 | 설명 |
|--------|--------|------|------|
| **Traefik** | `proxy` | 80, 443, 8081 | 리버스 프록시 및 SSL 관리 |
| **Jenkins** | `cicd` | 8080, 50000 | CI/CD 파이프라인 |
| **PostgreSQL** | `db` | 5432 | 메인 데이터베이스 |
| **MinIO** | `s3` | 9000, 9001 | S3 호환 객체 스토리지 |

## 빠른 시작

### 1. 네트워크 생성
```bash
docker network create core_network
```

### 2. 환경 변수 설정
`.env` 파일을 생성하고 다음 변수들을 설정하세요:

```bash
# 기본 도메인
BASE_DOMAIN=yourdomain.com

# Traefik 설정
LETSENCRYPT_EMAIL=your-email@example.com

# PostgreSQL 설정
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password123
POSTGRES_DB=workinkorea
POSTGRES_PORT=5432

# Jenkins 설정
JENKINS_PORT=8080
JENKINS_SLAVE_PORT=50000

# MinIO 설정
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=password123
MINIO_SUB_DOMAIN_API=api-s3
MINIO_SUB_DOMAIN_UI=ui-s3
MINIO_PORT=9000
MINIO_PORT_UI=9001
```

### 3. 서비스 실행

```bash
# 모든 서비스 실행
docker-compose up -d

# 특정 서비스만 실행
docker-compose --profile proxy up -d    # Traefik만
docker-compose --profile db up -d       # PostgreSQL만
docker-compose --profile cicd up -d     # Jenkins만
docker-compose --profile s3 up -d       # MinIO만
```

## 서비스 접근

| 서비스 | URL | 인증 |
|--------|-----|------|
| **Traefik Dashboard** | `https://tr.yourdomain.com` | admin / password |
| **Jenkins** | `https://jenkins.yourdomain.com` | 초기 설정 필요 |
| **MinIO API** | `https://api-s3.yourdomain.com/api` | admin / password123 |
| **MinIO UI** | `https://ui-s3.yourdomain.com` | admin / password123 |

## 서비스별 상세 문서

- [Traefik](./traefik/README.md) - 리버스 프록시 설정
- [Jenkins](./jenkins/README.md) - CI/CD 파이프라인 설정
- [Database](./database/README.md) - PostgreSQL 데이터베이스 관리
- [MinIO](./minio/README.md) - S3 호환 스토리지 설정

## 유용한 명령어

```bash
# 서비스 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs -f [service_name]

# 서비스 재시작
docker-compose restart [service_name]

# 서비스 중지
docker-compose down

# 볼륨까지 삭제
docker-compose down -v
```

## 문제 해결

### 일반적인 문제들

1. **네트워크 오류**: `core_network`가 생성되었는지 확인
2. **SSL 인증서 오류**: 도메인 DNS 설정 확인
3. **포트 충돌**: 다른 서비스와 포트 충돌 확인

### 로그 확인
```bash
# 전체 로그 확인
docker-compose logs

# 특정 서비스 로그 확인
docker-compose logs traefik
docker-compose logs jenkins
docker-compose logs postgres_dev
docker-compose logs minio
```