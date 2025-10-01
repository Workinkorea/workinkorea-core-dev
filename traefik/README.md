# Traefik Reverse Proxy

Work in Korea core 시스템의 리버스 프록시 서비스입니다.

## 주요 기능

- 자동 SSL 인증서 관리 (Let's Encrypt)
- Docker 컨테이너 자동 디스커버리
- 웹 대시보드 제공
- HTTP → HTTPS 자동 리다이렉션

## 실행 방법

```bash
# 네트워크 생성
docker network create core_network

# 서비스 시작
docker-compose --profile proxy up -d
```

## 접근 URL

- **대시보드**: `https://tr.yourdomain.com`
- **인증**: admin / password

## 환경 변수

`.env` 파일에 다음 변수들을 설정하세요:

```bash
BASE_DOMAIN=yourdomain.com
LETSENCRYPT_EMAIL=your-email@example.com
TRAEFIK_PORT=8080
DASHBOARD_BASIC_AUTH_USERS=admin:password123
```

## 서비스 연동

다른 서비스를 Traefik을 통해 노출하려면:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.service-name.rule=Host(`subdomain.yourdomain.com`)"
  - "traefik.http.routers.service-name.entrypoints=websecure"
  - "traefik.http.routers.service-name.tls.certresolver=le"
```

## 로그 확인

```bash
# 실시간 로그 모니터링
tail -f logs/access.log

# Traefik 로그 확인
docker logs traefik
```
