# Jenkins CI/CD

Work in Korea core 시스템의 지속적 통합/배포(CI/CD) 서비스입니다.

## 주요 기능

- 자동화된 빌드 및 배포
- Docker 통합 지원
- 다양한 플러그인 지원
- 웹 기반 관리 인터페이스

## 실행 방법

```bash
# 서비스 시작
docker-compose --profile cicd up -d
```

## 접근 URL

- **Jenkins 웹 인터페이스**: `https://jenkins.yourdomain.com`

## 초기 설정

### 1. 관리자 비밀번호 확인
```bash
# 초기 비밀번호 확인
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 2. 웹 인터페이스 접근
1. 브라우저에서 `https://jenkins.yourdomain.com` 접속
2. 초기 비밀번호 입력
3. 플러그인 설치 (권장 플러그인 선택)
4. 관리자 계정 생성

## 환경 변수

`.env` 파일에 다음 변수들을 설정하세요:

```bash
# 도메인 설정
BASE_DOMAIN=yourdomain.com

# 포트 설정
JENKINS_PORT=8080
JENKINS_SLAVE_PORT=50000
```

## 로그 확인

```bash
# Jenkins 로그 확인
docker logs jenkins

# Jenkins 홈 디렉토리 접근
docker exec -it jenkins bash
```
