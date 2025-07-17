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



|구분|modules/에 넣는 경우| environment/환경/ 에 넣는 경우|
|:---:|:---:|:---:|
|재사용 가능 로직|✅ 예: VPC, Subnet, ALB, EKS 구성 로직|❌|
|환경마다 다를 수 있는 것|❌ (하드코딩, 재사용 어려움)|✅ 예: SG, CIDR, IAM role name