# MinIO Object Storage

Work in Korea core 시스템의 S3 호환 객체 스토리지 서비스입니다.

## 주요 기능

- S3 호환 API 제공
- 웹 콘솔 UI 제공
- 파일 업로드/다운로드 관리

## 실행 방법

```bash
# 서비스 시작
docker-compose --profile s3 up -d
```

## 접근 URL

- **API**: `https://api-s3.yourdomain.com/api`
- **웹 콘솔**: `https://ui-s3.yourdomain.com`

## 환경 변수

`.env` 파일에 다음 변수들을 설정하세요:

```bash
# MinIO 인증 정보
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=password123

# 도메인 설정
MINIO_SUB_DOMAIN_API=api-s3
MINIO_SUB_DOMAIN_UI=ui-s3
BASE_DOMAIN=yourdomain.com

# 포트 설정
MINIO_PORT=9000
MINIO_PORT_UI=9001
```

## 로그 확인

```bash
# MinIO 로그 확인
docker logs minio
```
