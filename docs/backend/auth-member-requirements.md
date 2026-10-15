# SwingMate 회원 기능 백엔드 요구사항 명세서

## 1. 문서 목적과 범위

회원의 로그인·가입·휴대폰 본인 인증·온보딩 정보 저장·프로 연결을 지원하기 위한 백엔드 요구사항이다.

### 포함 범위

- 카카오·Google 소셜 로그인
- 신규/기존 회원 판별 및 액세스 토큰 발급
- 회원 역할 선택: 일반 회원(`MEMBER`) / 프로(`PRO`)
- 이름·휴대폰 번호 입력 및 SMS 인증
- 일반 회원의 레슨 관심 분야·골프 경력 저장
- 프로의 소개·경력·레슨 가능 요일 및 시간 저장
- 일반 회원의 프로 코드 연결 및 건너뛰기

### 제외 범위

- 홈 화면 데이터, 레슨 목록, 예약, 결제, 알림 등 홈 도메인 기능
- 프로필 사진 실제 업로드 UI 및 이미지 처리 정책
- Apple 로그인 (현재 앱 화면/구현 범위에서는 제외)

## 2. 용어 및 역할

| 용어 | 설명 |
| --- | --- |
| 사용자 | SwingMate 계정을 보유한 사람 |
| 일반 회원 | 레슨을 받는 사용자. 역할 값 `MEMBER` |
| 프로 | 레슨을 제공하는 사용자. 역할 값 `PRO` |
| 온보딩 | 역할 선택 후 필수 정보를 입력해 가입을 완료하는 과정 |
| 프로 코드 | 일반 회원이 특정 프로와 연결하는 식별 코드 |
| 인증 세션 | SMS 발송 후 인증번호 검증 전까지 유효한 서버 측 인증 단위 |

## 3. 사용자 흐름

### 3.1 공통 로그인 및 역할 선택

1. 사용자는 카카오 또는 Google으로 로그인한다.
2. 백엔드는 소셜 토큰을 검증한다.
3. 기존 가입 완료 사용자면 액세스/리프레시 토큰과 사용자 상태를 반환한다.
4. 신규 사용자 또는 가입 미완료 사용자면 온보딩용 토큰과 가입 상태를 반환한다.
5. 신규 사용자는 `MEMBER` 또는 `PRO` 역할을 선택한다.

### 3.2 일반 회원 가입

1. 이름과 휴대폰 번호를 입력한다.
2. SMS 인증번호를 요청하고 6자리 인증번호를 검증한다.
3. 레슨 관심 분야를 한 개 이상 선택하고 골프 경력을 한 개 선택한다.
4. 선택적으로 프로 코드를 입력해 프로와 연결하거나, 연결을 건너뛴다.
5. 가입 완료 처리 후 로그인 토큰을 발급한다.

### 3.3 프로 가입

1. 이름과 휴대폰 번호를 입력한다.
2. SMS 인증번호를 요청하고 6자리 인증번호를 검증한다.
3. 프로 소개와 경력을 입력한다. 소개는 최대 200자이며 경력은 최소 한 건이다.
4. 레슨 가능 요일과 시간대를 설정한다.
5. 가입 완료 처리 후 로그인 토큰을 발급한다.

## 4. 데이터 모델 요구사항

### 4.1 사용자

| 필드 | 타입/예시 | 필수 | 설명 |
| --- | --- | --- | --- |
| `id` | UUID | Y | 내부 사용자 식별자 |
| `role` | `MEMBER` / `PRO` | 가입 완료 시 Y | 사용자 역할 |
| `onboardingStatus` | `PENDING` / `COMPLETED` | Y | 가입 완료 여부 |
| `name` | 문자열 | Y | 한글 또는 영문 2자 이상 |
| `phoneNumber` | `01012345678` | Y | 숫자만 저장하는 국내 휴대폰 번호 |
| `phoneVerifiedAt` | ISO-8601 | Y | SMS 인증 성공 시각 |
| `profileImageUrl` | URL/null | N | 향후 프로필 사진 기능용 |
| `createdAt`, `updatedAt` | ISO-8601 | Y | 생성/수정 시각 |

### 4.2 소셜 계정

한 사용자는 소셜 공급자별 계정을 연결할 수 있어야 한다.

| 필드 | 설명 |
| --- | --- |
| `userId` | 사용자 ID |
| `provider` | `KAKAO` 또는 `GOOGLE` |
| `providerUserId` | 공급자가 제공한 고유 사용자 ID |
| `email` | 공급자 제공 이메일. 미제공 가능 |
| `connectedAt` | 연결 시각 |

`provider + providerUserId`는 전역 유일해야 한다.

### 4.3 SMS 인증 세션

인증번호 원문은 저장하지 말고 해시값만 저장한다.

| 필드 | 설명 |
| --- | --- |
| `verificationId` | 클라이언트가 이후 검증·재발송에 사용하는 UUID |
| `phoneNumber` | 인증 대상 번호 |
| `purpose` | `SIGNUP_PHONE_VERIFICATION` |
| `codeHash` | 6자리 인증번호 해시 |
| `expiresAt` | 발송 시점부터 3분 |
| `attemptCount` | 인증번호 검증 시도 횟수 |
| `resendCount` | 재발송 횟수 |
| `verifiedAt` | 성공 시 기록 |

### 4.4 일반 회원 온보딩 데이터

| 필드 | 값 |
| --- | --- |
| `lessonInterests` | 아래 코드 중 1개 이상 배열 |
| `golfExperience` | 아래 코드 중 1개 |
| `connectedProId` | 연결 성공 시 프로 사용자 ID, 아니면 `null` |

`lessonInterests`: `BEGINNER`, `SWING_CORRECTION`, `SHORT_GAME`, `DRIVER`, `IRON`, `PUTTING`, `LOB_SHOT`, `STINGER_SHOT`, `OTHER`

`golfExperience`: `UNDER_6_MONTHS`, `MONTHS_6_TO_3_YEARS`, `YEARS_3_TO_7`, `OVER_7_YEARS`

### 4.5 프로 온보딩 데이터

| 필드 | 제약 |
| --- | --- |
| `introduction` | 1~200자 |
| `careers` | 문자열 배열, 최소 1개 |
| `availability` | 선택 요일별 시간대 배열 |
| `proCode` | 일반 회원 연결용 고유 코드 |

`availability` 예시:

```json
[
  {
    "dayOfWeek": "MONDAY",
    "timeRanges": [
      { "startTime": "09:00", "endTime": "13:00" },
      { "startTime": "18:00", "endTime": "22:00" }
    ]
  }
]
```

- 요일: `MONDAY`~`SUNDAY`
- 시간 형식: 서버 표준 `HH:mm` (24시간제)
- 각 시간대는 `startTime < endTime`이어야 한다.
- 같은 요일의 시간대는 서로 겹치면 안 된다.
- 최소 한 요일, 각 선택 요일에는 최소 한 시간대가 필요하다.

## 5. API 요구사항

기본 경로는 `/api/v1`로 가정한다. 실제 URL은 백엔드 설계에 따라 조정 가능하나 요청·응답 의미와 오류 코드는 유지한다.

### 5.1 소셜 로그인

`POST /auth/social/login`

```json
{
  "provider": "KAKAO",
  "idToken": "provider-issued-token"
}
```

| 응답 필드 | 설명 |
| --- | --- |
| `isNewUser` | 신규 소셜 계정 여부 |
| `onboardingStatus` | `PENDING` 또는 `COMPLETED` |
| `accessToken`, `refreshToken` | 가입 완료 사용자에만 필수 |
| `onboardingToken` | 가입 미완료 사용자에만 필수. 온보딩 API 인증용 |
| `user` | 가입 완료 사용자 기본 정보 |

- 공급자 토큰이 유효하지 않으면 `401 SOCIAL_TOKEN_INVALID`
- 공급자 계정이 가입 완료 상태라면 역할 선택 화면을 거치지 않는다.

### 5.2 역할 선택

`PATCH /onboarding/role`

인증: `Authorization: Bearer {onboardingToken}`

```json
{ "role": "MEMBER" }
```

- 이미 가입 완료된 사용자는 변경 불가: `409 ONBOARDING_ALREADY_COMPLETED`

### 5.3 SMS 인증번호 발송 및 재발송

`POST /phone-verifications`

```json
{
  "phoneNumber": "01012345678",
  "purpose": "SIGNUP_PHONE_VERIFICATION"
}
```

```json
{
  "verificationId": "uuid",
  "expiresAt": "2026-10-13T12:03:00Z",
  "remainingSeconds": 180,
  "resendAvailableAt": "2026-10-13T12:00:30Z"
}
```

- 동일 번호에 대한 과도한 발송은 제한한다. 권장: 1분당 1회, 하루 5회.
- 인증 완료된 번호의 재발송은 `409 PHONE_ALREADY_VERIFIED`.
- 가입이 완료된 다른 계정이 이미 사용하는 번호는 정책에 따라 `409 PHONE_ALREADY_IN_USE` 반환. 번호 변경/중복 허용 정책은 백엔드·기획 합의가 필요하다.

재발송도 동일 API를 사용하되, 기존 `verificationId`를 선택적으로 전송한다.

```json
{
  "phoneNumber": "01012345678",
  "purpose": "SIGNUP_PHONE_VERIFICATION",
  "previousVerificationId": "uuid"
}
```

### 5.4 SMS 인증번호 검증

`POST /phone-verifications/{verificationId}/confirm`

```json
{ "code": "123456" }
```

```json
{
  "verificationToken": "short-lived-token",
  "phoneNumber": "01012345678",
  "verifiedAt": "2026-10-13T12:01:10Z"
}
```

- 인증번호는 숫자 6자리다.
- 만료: `410 VERIFICATION_EXPIRED`
- 불일치: `400 VERIFICATION_CODE_INVALID`
- 시도 횟수 초과: `429 VERIFICATION_ATTEMPTS_EXCEEDED`
- `verificationToken`은 온보딩 완료 요청에서만 사용하며 짧은 만료 시간을 둔다.

### 5.5 일반 회원 온보딩 저장 및 가입 완료

`PUT /onboarding/member`

인증: `onboardingToken` 및 `verificationToken` 필요

```json
{
  "name": "홍길동",
  "phoneNumber": "01012345678",
  "lessonInterests": ["BEGINNER", "PUTTING"],
  "golfExperience": "UNDER_6_MONTHS"
}
```

응답: 가입 완료 사용자, `accessToken`, `refreshToken`

- SMS 인증 대상 번호와 요청의 `phoneNumber`는 같아야 한다.
- 관심 레슨 분야 누락: `400 LESSON_INTEREST_REQUIRED`
- 골프 경력 누락: `400 GOLF_EXPERIENCE_REQUIRED`

### 5.6 프로 온보딩 저장 및 가입 완료

`PUT /onboarding/pro`

인증: `onboardingToken` 및 `verificationToken` 필요

```json
{
  "name": "홍길동",
  "phoneNumber": "01012345678",
  "introduction": "KPGA 투어 프로입니다.",
  "careers": ["KPGA 투어 프로", "골프 아카데미 코치"],
  "availability": [
    {
      "dayOfWeek": "MONDAY",
      "timeRanges": [
        { "startTime": "09:00", "endTime": "18:00" }
      ]
    }
  ]
}
```

응답: 가입 완료 사용자, `accessToken`, `refreshToken`, 생성된 `proCode`

- 프로 소개 누락: `400 PRO_INTRODUCTION_REQUIRED`
- 프로 경력 없음: `400 PRO_CAREER_REQUIRED`
- 레슨 가능 시간 없음 또는 형식 오류: `400 AVAILABILITY_INVALID`

### 5.7 프로 코드 연결

`POST /members/me/pro-connection`

인증: 가입 완료 일반 회원 액세스 토큰

```json
{ "proCode": "ABC123" }
```

```json
{
  "pro": {
    "id": "uuid",
    "name": "김프로",
    "profileImageUrl": null
  }
}
```

- 코드가 없거나 비활성 프로면 `404 PRO_CODE_NOT_FOUND`
- 프로에게 연결할 수 없는 상태면 `409 PRO_CONNECTION_NOT_ALLOWED`
- 동일 프로와 중복 연결 요청은 멱등 처리한다.

### 5.8 토큰 갱신 및 로그아웃

| 메서드/경로 | 요구사항 |
| --- | --- |
| `POST /auth/token/refresh` | 리프레시 토큰으로 새 액세스 토큰(권장: 리프레시 토큰도 회전)을 발급 |
| `POST /auth/logout` | 현재 리프레시 토큰/세션을 무효화 |
| `GET /users/me` | 앱 재실행 시 사용자·역할·온보딩 상태 확인 |

## 6. 공통 검증 및 보안 요구사항

- 모든 휴대폰 번호는 공백·하이픈 제거 후 숫자 11자리 `01x` 형식으로 비교·저장한다.
- 이름은 한글 또는 영문 2자 이상만 허용한다. 공백·숫자·특수문자만의 이름은 거부한다.
- SMS 코드·소셜 토큰·액세스 토큰·리프레시 토큰은 로그에 남기지 않는다.
- SMS 인증번호는 해시 저장하며, 검증 성공/만료/시도 횟수 초과 시 재사용할 수 없게 한다.
- API 오류 응답은 최소 `code`, `message`, `traceId`를 포함한다.
- 상태 변경 API는 인증 주체가 자신의 온보딩 정보만 수정할 수 있어야 한다.
- 온보딩 완료 요청은 재시도해도 중복 사용자·프로 코드·연결 데이터가 생성되지 않게 멱등성을 보장한다.

## 7. 백엔드 확정이 필요한 항목

1. 하나의 휴대폰 번호를 여러 소셜 계정이 사용할 수 있는지 여부
2. 프로가 스스로 가입을 완료하는 즉시 활동 가능한지, 관리자 승인 후 활동 가능한지 여부
3. 프로 코드 형식·길이·재발급/비활성화 정책
4. 일반 회원이 여러 프로와 연결 가능한지, 기본 프로는 한 명인지 여부
5. SMS 발송 사업자, 발송 횟수 제한, 비용·차단 정책
6. 프로필 사진 업로드 저장소 및 허용 파일 정책
7. 소셜 로그인 공급자에 Apple을 포함할지 여부

## 8. 프론트엔드 현 구현과 연동 메모

- 앱은 `API_BASE_URL`(기본 `http://localhost:8080`)의 서버와 통신한다. Android 에뮬레이터에서는 `--dart-define=API_BASE_URL=http://10.0.2.2:8080`을 쓴다.
- 소셜 로그인 SDK(카카오·Google)는 아직 붙지 않았다. 개발 환경에서는 임의 토큰(`kakao-dev-user` 등, `--dart-define=DEV_SOCIAL_ID`로 변경)을 보내며, 서버를 `OAUTH_MOCK_ENABLED=true`로 켰을 때만 로그인된다. 운영 환경에서는 로그인이 막힌다.
- 연동된 API: 소셜 로그인, SMS 인증 발송·확인, 일반 회원·프로 가입 완료. 서버의 테스트 인증번호는 `123456`이며 응답/화면에 노출하지 않는다.
- 아직 연동하지 않은 것: 역할 선택 API(가입 완료 API가 역할을 함께 저장), 프로 코드 연결(앱은 "프로 확인 후 연결" 흐름이라 서버의 즉시 연결과 맞지 않음), 토큰 갱신·로그아웃, 앱 재실행 시 `GET /users/me`.
- 토큰은 메모리에만 보관해 앱을 다시 켜면 로그인해야 한다.
- 현재 로그인 버튼은 카카오와 Google UI만 구현되어 있다.
- 일반 회원의 프로 연결은 가입 후 선택 흐름이며, `나중에 연결하기`를 지원한다.
- 홈 화면 연동은 본 문서 범위 밖이며, 로그인 및 회원가입 API가 완료된 뒤 별도 명세로 작성한다.
