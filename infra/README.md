# Infra：syd（主）+ mel（DR）

```
infra/
├── modules/region/   # 一个区域的完整栈：VPC / ALB / ECS / ECR / S3 数据桶
└── envs/
    ├── mel/          # ap-southeast-4，DR 站点，desired_count=0（pilot light），备份桶
    └── syd/          # ap-southeast-2，主站点 + OIDC/GitHub role + S3/ECR 跨区域复制
```

每个 env 有独立的 state（`envs/<env>/terraform.tfstate`）。

## 部署顺序

ap-southeast-4（墨尔本）是 opt-in 区域，先在 控制台 → Account → AWS Regions 里启用。

```bash
cd infra/envs/mel && terraform init && terraform apply   # 先建备份桶
cd ../syd         && terraform init && terraform apply   # 再建主桶 + 复制规则
```

syd 通过 `terraform_remote_state` 读取 mel 的备份桶 ARN，所以顺序不能反。
destroy 时反过来：先 syd，后 mel。

## DR 练习

**1. 验证复制**
```bash
SRC=$(cd envs/syd && terraform output -raw primary_bucket)
DST=$(cd envs/syd && terraform output -raw backup_bucket)
echo hello > test.txt && aws s3 cp test.txt s3://$SRC/
aws s3api head-object --bucket $SRC --key test.txt --query ReplicationStatus   # PENDING -> COMPLETED
aws s3api head-object --bucket $DST --key test.txt --region ap-southeast-4 --query '[ReplicationStatus,StorageClass]'  # REPLICA, STANDARD_IA
```

**2. 误删恢复**：在 syd 删除对象 → 删除标记会复制到 mel，但旧版本还在。
用 `aws s3api list-object-versions` 找到版本，删掉 delete marker 就恢复了。

**3. 已有对象不会复制**：复制规则只对新写入的对象生效，之前的对象要用 S3 Batch Replication。

**4. Failover 演练**：
```bash
cd envs/mel && terraform apply -var desired_count=1
curl http://$(terraform output -raw alb_dns_name)/health
```
镜像已经通过 ECR 复制同步到 mel，所以任务能直接拉到 `:latest`。
