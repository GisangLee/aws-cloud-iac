| 테라폼 IaC 템플릿

### 폴더 구조
```
├── environment
│   ├── dev
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── prod
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── stage
│       ├── main.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── modules
│   └── vpc
│       ├── main.tf
│       └── variables.tf
└── run.sh
```

> environment : 환경별 실행 루트

> modules: 리소스 모듈

> run.sh : 실행 자동화 스크립트


### 관리 방법

1. modules/ 하위에 생성하고자 하는 리소스를 정의

2. environment/환경/main.tf에 정의한 리소스를 참조하여 값을 전달

3. 전달되는 값은 modules/리소스/variables.tf에 명세.