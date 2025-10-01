# Database Services

Work in Korea core 시스템의 데이터베이스 서비스입니다.

## 포함된 데이터베이스

- **PostgreSQL 17.4**: 메인 관계형 데이터베이스

## 실행 방법

```bash
# 데이터베이스 서비스 시작
docker-compose --profile db up -d
```

## 환경 변수

`.env` 파일에 다음 변수들을 설정하세요:

```bash
# PostgreSQL 설정
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password123
POSTGRES_DB=your_database_name
POSTGRES_PORT=5432
POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C
```

## 데이터베이스 접근

### 연결 정보
- **호스트**: your_domain.com
- **포트**: 5432 (기본값)
- **데이터베이스**: your_database_name
- **사용자**: postgres
- **비밀번호**: password123

## 로그 확인

```bash
# PostgreSQL 로그 확인
docker logs postgres_dev

# 실시간 로그 모니터링
docker logs -f postgres_dev
```
